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

sub google :Path('google') :Args(0) {
    my ( $self, $c ) = @_;

    if (my $url = $c->req->params->{url}) {
	$url = URI->new($url);

	if ($url->query_form_hash->{mid}) {
	    $c->stash->{url} = 'https://mapsengine.google.com/map/kml?mid=' . $url->query_form_hash->{mid};
	} elsif ($url->query_form_hash->{msid}) {
	    $c->stash->{url} = 'https://www.google.com/maps/ms?msa=0&ie=UTF8&output=kml&msid=' . $url->query_form_hash->{msid};
	} else {
	    $c->detach(qw/Controller::Error index/)
	}

	$c->log->info("Map id: " . $url);
	my $map = $c->req->params->{map};

	$c->stash->{id} = $url;
	$c->stash->{map} = $c->req->params->{map};
	$c->forward('get_google_data');
	$c->forward('load_google_data');
	$c->res->body($c->uri_for("/maps", $c->user->{id}, $map));
    }
}

sub kml :Path('kml') :Args(0) {
    my ( $self, $c ) = @_;
    my $user = $c->user || $c->res->redirect($c->uri_for("/login"));
    my ($kml, $name);
    if (keys %{$c->req->params}) {
	if ($c->req->params->{file}) { $kml = $c->req->upload('file')->slurp } else { $c->detach(qw/Controller::Error index/) };
	my $xml = XML::XPath->new( xml => $kml ) || $c->detach(qw/Controller::Error index/);
	my ($name) = map { XMLin($_->toString) } $xml->find('//Document/name')->get_nodelist;
	$c->log->info($name);
	$c->stash->{map_name} = $name;
	$c->stash->{kml} = [ map { XMLin($_->toString) } ( $xml->find('//Placemark/Point/..')->get_nodelist) ];
	$c->forward('load_google_data');
	# $c->res->redirect($c->uri_for('/maps', $c->stash->{map}->id, $c->stash->{map}->name));
	$c->res->body($c->uri_for('/maps', $c->stash->{map}->id, $c->stash->{map}->name)); 
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
	$c->log->info("KML: \n" . $kml);
	$c->stash->{kml} = [ map { XMLin($_->toString) } ( XML::XPath->new( xml => $kml )->find('//Placemark/Point/..')->get_nodelist) ];
    } else {
	$c->log->info("Status: " . $kml->{status});
	$c->log->info("Reason: " . $kml->{reason});
	$c->forward(qw/Controller::Error index/);
    }
}

use Try::Tiny;

sub load_google_data :Private {
    my ( $self, $c ) = @_;
    my $m = $c->model('Maps::Map')->create({ user_id => $c->user->uid, name => $c->stash->{map_name}});
    $m->insert;
    for (@{$c->stash->{kml}}) {
	my $i;
	($i->{lon}, $i->{lat}) = split ',', $_->{Point}->{coordinates};
	$c->log->info($_->{name});
	$i->{name} = $_->{name}; $i->{name} =~ s/^\s+|\s+$//g;
	try { my $e = $m->create_related('pois', $i); $e->insert }
	    catch { $c->log->info("Error in loading data:\n" . dump $_) };
    }
    $c->stash->{map} = $m;
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
