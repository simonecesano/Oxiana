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

sub map :Chained('base') :PathPart('') :Args(2) {
    my ( $self, $c, $user, $map ) = @_;
    $c->stash->{map} = $c->model('Maps::Map')->find({ user_id => $user, name => $map});
    if ($c->stash->{map}) { 
	$c->stash->{user} = $user;
	$c->stash->{template} = 'maps/list.tt2';
    } else {
    	$c->forward(qw/Controller::Error index/);
    }
}

sub map_new :Chained('base') :PathPart('new') :Args(0) {
    my ($self, $c) = @_;
    $c->stash->{template} = \'making a new map here';
}

sub poi :Chained('base') :PathPart('') :CaptureArgs(3) {
    my ( $self, $c, $user, $map, $poi ) = @_;
    $c->stash->{user} = $user;
    $c->stash->{map} = $c->model('Maps::Map')->find({ user_id => $user, name => $map});
    $c->stash->{poi} = $c->stash->{map}->find_related('pois', { name => $poi });
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
	$c->log->info($h);
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

sub poi_add :Chained('poi') :PathPart('edit') :Args(0) {
    my ( $self, $c ) = @_;
    $c->res->body('added');
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
