package Oxiana::Controller::Maps;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Oxiana::Controller::Maps - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base :Chained("/") :PathPart("maps") :CaptureArgs(0) {}

sub user :Chained('base') :PathPart('') :Args(1) {
    my ($self, $c, $user) = @_;
    $c->detach(qw/Controller::Home index/, [ $user ]);
}

sub map :Chained('base') :PathPart('') :CaptureArgs(2) {
    my ( $self, $c, $user, $map ) = @_;
    $c->stash->{map} = $c->model('Maps::Map')->find({ user_id => $user, name => $map});
    if ($c->stash->{map}) { 
	$c->session->{current_map} = $map;
	$c->stash->{user} = $user;
    } else {
    	$c->detach(qw/Controller::Error index/);
    }
}

sub map_view :Chained('map') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'maps/list.tt2';
}


sub map_new :Chained('base') :PathPart('new') :Args(0) {
    my ($self, $c) = @_;
    $c->stash->{template} = \'making a new map here';
}

sub poi :Chained('map') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $poi ) = @_;
    $c->stash->{poi} = $c->stash->{map}->find_related('pois', { name => $poi })
	|| $c->detach(qw/Controller::Error index/);
}

sub poi_view :Chained('poi') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'pois/view.tt2';
}



use Hash::Merge qw( merge );

sub poi_edit :Chained('poi') :PathPart('edit') :Args(0) {
    my ( $self, $c ) = @_;
    if (keys %{$c->req->params}) {
	my $h = $c->req->params->{editor};
	$h =~ s/\n/ /g;
	$c->stash->{poi}->description($h);
	for (grep { !/editor/ } keys %{$c->req->params}) {
	    my $ed = $c->stash->{poi}->extended_data;
	    if ($c->stash->{poi}->result_source->has_column($_)) {
		$c->stash->{poi}->set_column($_ => $c->req->params->{$_})
	    } else {
		$ed->{$_} = $c->req->params->{$_};
	    }
	    $c->stash->{poi}->extended_data($ed);
	}
	$c->stash->{poi}->update;
    } 
    $c->stash->{template} = 'pois/edit.tt2';
}

use URI::Escape;
use URI;
use Data::Dump qw/dump/;

sub poi_add :Path('/poi/add') :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{map} = $c->model('Maps::Map')->find({ user_id => $c->user->id, name => $c->session->{current_map}});

    my $poi = $self->_google_url_to_loc($c->req->params->{url});
    $c->detach(qw/Controller::Error index/) unless ($poi->{name} && defined $poi->{lat} && defined $poi->{lon});

    $c->log->info(dump $poi);
    if ($c->stash->{poi} = $c->stash->{map}->related_resultset('pois')->create($poi)) {
	$c->res->redirect($c->uri_for('/maps', $c->user->id, $c->session->{current_map}, $poi->{name}, 'edit'));
    } else {
    	$c->detach(qw/Controller::Error index/);
    }
}


sub _google_url_to_loc {
    shift;
    my $uri = URI->new(shift);
    my $check = quotemeta('https://www.google.de/maps/place/');
    return unless $uri =~ /$check/;
    my $iri = uri_unescape($uri->as_iri);

    for ($iri) { s/.+?place\///; s/@//; s/\+/ /g };
    my ($place, $latlon) = split /\//, $iri;
    my @latlon = split ',', $latlon;
    my $r = { name => $place, lat  => $latlon[0], lon  => $latlon[1] };
    return $r;
}

=encoding utf8

=head1 AUTHOR

Cesano, Simone

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
