package Oxiana::Controller::Poi;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use URI;
use URI::Escape;
use Data::Dump qw/dump/;

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Oxiana::Controller::Poi in Poi.');
}

sub add :Path('add') :Args(0) {
    my ( $self, $c ) = @_;

    unless (keys %{$c->req->params}) {
	$c->stash->{template} = 'pois/add.tt2';
	$c->forward('View::HTML');
    } else {
	$c->log->info("Current map " . $c->session->{current_map});
 	$c->stash->{map} = $c->model('Maps::Map')->find({ id => $c->session->{current_map}});
	$c->detach('add_by_url') if $c->req->params->{url};
	$c->detach('add_by_location') if $c->req->params->{name};
	$c->detach('add_by_address') if $c->req->params->{address};
    }
}

sub add_by_url :Private {
    my ( $self, $c ) = @_;
    my $poi = $self->_google_url_to_loc($c->req->params->{url});
    $c->detach(qw/Controller::Error index/) unless ($poi->{name} && defined $poi->{lat} && defined $poi->{lon});

    $c->log->info(dump $poi);
    my $map = $c->stash->{map};
    if ($c->stash->{poi} = $c->stash->{map}->related_resultset('pois')->create($poi)) {
	$c->res->redirect($c->uri_for('/maps', $map->user_id, $map->name, $poi->{name}, 'edit'));
    } else {
    	$c->detach(qw/Controller::Error index/);
    }
}

sub add_by_location :Private {
    my ( $self, $c ) = @_;
    my $q = $c->req->params;
    my $map = $c->stash->{map};
    if ($q->{name} && defined $q->{lat} && defined $q->{lon}) {
	my $poi = {}; @{$poi}{qw/name lat lon/} = @{$q}{qw/name lat lon/};
	if ($c->stash->{poi} = $map->related_resultset('pois')->create($poi)) {
	    # XXXX this is messy, and it should be refactored with add_by_url
	    $c->res->redirect($c->uri_for('/maps', $map->user_id, $map->name, $poi->{name}, 'edit'));
	} else {
	    $c->detach(qw/Controller::Error index/);
	}
    } else {
    	$c->detach(qw/Controller::Error index/);
    }
}

sub add_by_address :Private {
    my ( $self, $c ) = @_;
    $c->log->info($c->req->params->{address});
    $c->res->body('address');
}

sub iframe :Path('iframe') {
    my ( $self, $c ) = @_;
    $c->res->body('<h1>Hallo!</h1><p>I am an iframe!</p><p>There will be a form here</p>');
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


__PACKAGE__->meta->make_immutable;

1;
