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

    unless ($c->user) {
	$c->log->info("Uri for action with params: " . $c->uri_for($c->action, $c->req->query_params));
	$c->log->info("Referer: " . $c->req->uri);
	# this is the way to redirect with Heroku
	$c->session->{login_referer} = $c->uri_for($c->action, $c->req->query_params);
	$c->res->redirect($c->uri_for("/login"));
	$c->detach;
    }

    unless (keys %{$c->req->params}) {
	$c->stash->{template} = 'pois/add.tt2';
	$c->forward('View::HTML');
    } else {
	$c->log->info("Current map " . $c->session->{current_map});
	$c->log->info("referer " . $c->req->referer);
	$c->log->info("referer should be " . $c->uri_for('/location'));
 	$c->stash->{map} = $c->model('Maps::Map')->find({ id => $c->session->{current_map}});


	$c->detach('add_by_url') if $c->req->params->{url} =~ /google.+maps.+place/i;
	$c->detach('add_by_address') if $c->req->params->{sel};

	# this needs to check referer
	$c->detach('add_by_location') if $c->req->params->{name};
    }
}

sub add_by_url :Private {
    my ( $self, $c ) = @_;

    
    my $poi = $self->_google_url_to_loc($c->req->params->{url});
    $poi->{name} = substr($poi->{name}, 0, 64); # this sucks

    $c->detach(qw/Controller::Error index/) unless ($poi->{name} && defined $poi->{lat} && defined $poi->{lon});

    $c->log->info(dump $poi);
    my $map = $c->stash->{map};
    $c->log->info(ref $map);
    $c->log->info(ref $c->stash->{map}->related_resultset('pois'));
    if (my $new_poi = $c->stash->{poi} = $c->stash->{map}->related_resultset('pois')->create($poi)) {
	$new_poi->update($poi);
	$c->res->redirect($c->uri_for('/maps', $map->id, $map->name, $new_poi->id, $new_poi->name, 'edit'));
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
	if (my $new_poi = $c->stash->{poi} = $map->related_resultset('pois')->create($poi)) {
	    # XXXX this is messy, and it should be refactored with add_by_url
	$c->res->redirect($c->uri_for('/maps', $map->id, $map->name, $new_poi->id, $new_poi->name, 'edit'));
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
    $c->res->body('address ' . $c->req->params->{sel});
}

sub iframe :Path('iframe') {
    my ( $self, $c ) = @_;
    $c->res->body('<h1>Hallo!</h1><p>I am an iframe!</p><p>There will be a form here</p>');
}

sub _google_url_to_loc {
    shift;
    my $uri = URI->new(shift);

    return unless $uri =~ /google.+maps.+place/i;
    my $iri = uri_unescape($uri->as_iri);

    for ($iri) { s/.+?place\///; s/@//; s/\+/ /g };
    my ($place, $latlon) = split /\//, $iri;
    my @latlon = split ',', $latlon;
    my $r = { name => $place, lat  => $latlon[0], lon  => $latlon[1] };
    return $r;
}




__PACKAGE__->meta->make_immutable;

1;
