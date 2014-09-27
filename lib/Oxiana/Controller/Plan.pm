package Oxiana::Controller::Plan;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Oxiana::Controller::Plan - Catalyst Controller

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
    $c->stash->{template} = "plan/index.tt2";
}

sub googlemaps :Path('googlemaps') :Args(0) {
    my ( $self, $c ) = @_;

    if (my $url = $c->req->params->{url}) {
	($url) = ($url =~ /mid=(.+)/);
	$c->res->redirect($c->uri_for("/plan/googlemaps/$url"));
    }
}

sub googlemaps_view :Path('googlemaps') :Args(1) {
    my ( $self, $c, $url ) = @_;

    my $kml = 'https://mapsengine.google.com/map/kml?mid=' . $url;
    $c->stash->{url} = $kml;
    $c->stash->{id} = $url;
    $kml = get($kml);
    $c->stash->{kml} = [ map { XMLin($_->toString) } ( XML::XPath->new( xml => $kml )->find('//Placemark/Point/..')->get_nodelist) ];
    $c->stash->{template} = 'plan/google/import.tt2';
}

sub googlemap_point :Path('googlemaps') :Args(2) {
    my ( $self, $c, $url, $point ) = @_;
    $c->stash->{template} = \$point;
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


__DATA__

/maps/:user
/maps/:user/:mapname
/maps/m/:mapname/:mapid/print

/pois/:poiname/:poiid
/pois/:poiname/:poiid/edit

/book/:bookname/:bookid

maps
 name
 id   

pois
 name
 id
 lon
 lat
 text

pictures
 caption
 id
 base64
 type
