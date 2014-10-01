package Oxiana::Controller::Import;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Oxiana::Controller::Import - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
use LWP::Simple;

use XML::Simple;
use XML::XPath;

use Data::Dump qw/dump/;

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Oxiana::Controller::Import in Import.');
}

sub google :Path('google') :Args(0) {
    my ( $self, $c ) = @_;

    if (my $url = $c->req->params->{url}) {
	my $map = $c->req->params->{map};
	($url) = ($url =~ /mid=(.+)/);

	$c->stash->{url} = 'https://mapsengine.google.com/map/kml?mid=' . $url;
	$c->stash->{id} = $url;
	$c->stash->{map} = $c->req->params->{map};
	$c->forward('get_google_data');
	$c->forward('load_google_data');
	$c->res->redirect($c->uri_for("/maps", $c->user->{id}, $map));
    }
}

sub get_google_data :Private {
    my ( $self, $c ) = @_;
    $c->log->info($c->stash->{url});

    my $m = $c->model('Google::Maps');
    my $kml = $m->get($c->stash->{url});
    if ($kml->{success} || 1) {
	$kml = $kml->{content};
	my $url = $c->stash->{url};
	# $kml = qx/curl $url/;
	$c->log->info("KML: \n" . $kml);
	$c->flash->{kml} = [ map { XMLin($_->toString) } ( XML::XPath->new( xml => $kml )->find('//Placemark/Point/..')->get_nodelist) ];
    } else {
	$c->log->info("Status: " . $kml->{status});
	$c->log->info("Reason: " . $kml->{reason});
	$c->forward('Error index');
    }
}

use Try::Tiny;

sub load_google_data :Private {
    my ( $self, $c ) = @_;
    # my $m = $c->model('Maps::Map')->create({ user_id => $c->user->{id}, name => $c->stash->{map}});
    my $m = $c->model('Maps::Map')->create({ user_id => $c->user->{id}, name => $c->stash->{map}});
    $m->insert;
    for (@{$c->flash->{kml}}) {
	my $i;
	($i->{lon}, $i->{lat}) = split ',', $_->{Point}->{coordinates};
	$c->log->info($_->{name});
	$i->{name} = $_->{name}; $i->{name} =~ s/\s+$//;
	try { my $e = $m->create_related('pois', $i); $e->insert } catch { $c->log->info(dump $_) };
    }
    return 1;
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
