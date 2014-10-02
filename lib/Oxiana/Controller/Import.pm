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
use URI;
use URI::QueryParam;
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
	$url = URI->new($url);
	$url = $url->query_form_hash->{mid} || $url->query_form_hash->{msid};
	$c->log->info("Map id: " . $url);
	my $map = $c->req->params->{map};
	# ($url) = ($url =~ /mid=(.+)/);
	$c->stash->{url} = 'https://mapsengine.google.com/map/kml?mid=' . $url;
	$c->stash->{id} = $url;
	$c->stash->{map} = $c->req->params->{map};
	$c->forward('get_google_data');
	$c->forward('load_google_data');
	$c->res->redirect($c->uri_for("/maps", $c->user->{id}, $map));
    }
}

sub kml :Path('kml') :Args(0) {
    my ( $self, $c ) = @_;
    my $user = $c->user->{id} || $c->detach(qw/Controller::Error index/);
    my ($kml, $name);
    if (keys %{$c->req->params}) {
	if ($c->req->params->{file}) {
	    $kml = $c->req->upload('file')->slurp;
	} elsif ($c->req->params->{url}) {
	    $c->stash->{map} = $c->req->params->{map};
	    $kml = $c->model('Google::Maps')->get($c->req->params->{url});
	    if ($kml->{success}) { $kml = $kml->{content} } else { $c->detach(qw/Controller::Error index/) }
	};
	my $xml = XML::XPath->new( xml => $kml );
	my ($name) = map { XMLin($_->toString) } $xml->find('//Document/name')->get_nodelist;
	$c->stash->{map} ||= $name; $name = $c->stash->{map};
	$c->flash->{kml} = [ map { XMLin($_->toString) } ( $xml->find('//Placemark/Point/..')->get_nodelist) ];
	$c->forward('load_google_data');

	if ($c->req->params->{file}) { $c->res->body("/maps/$user/$name") } 
	elsif ($c->req->params->{url}) { $c->res->redirect($c->uri_for("/maps", $user, $name)) }
    }
}

sub get_google_data :Private {
    my ( $self, $c ) = @_;
    $c->log->info($c->stash->{url});

    my $m = $c->model('Google::Maps');
    my $kml = $m->get($c->stash->{url});
    if ($kml->{success}) {
	$kml = $kml->{content};
	my $url = $c->stash->{url};
	# $kml = qx/curl $url/;
	$c->log->info("KML: \n" . $kml);
	$c->flash->{kml} = [ map { XMLin($_->toString) } ( XML::XPath->new( xml => $kml )->find('//Placemark/Point/..')->get_nodelist) ];
    } else {
	$c->log->info("Status: " . $kml->{status});
	$c->log->info("Reason: " . $kml->{reason});
	$c->forward(qw/Controller::Error index/);
    }
}

use Try::Tiny;

sub load_google_data :Private {
    my ( $self, $c ) = @_;
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
