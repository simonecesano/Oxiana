package Oxiana::Controller::Maps;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use Hash::Merge qw( merge );
use URI::Escape;
use Try::Tiny;

sub base :Chained("/") :PathPart("maps") :CaptureArgs(0) {}

sub user :Chained('base') :PathPart('') :Args(1) {
    my ($self, $c, $user) = @_;
    $c->detach(qw/Controller::Home home/, [ $user ]);
}

sub map :Chained('base') :PathPart('') :CaptureArgs(2) {
    my ( $self, $c, $user, $map ) = @_;
    $c->stash->{map} = $c->model('Maps::Map')->find({ user_id => $user, name => $map});
    if ($c->stash->{map}) { 
	$c->session->{current_map} = $c->stash->{map}->id;
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
    $c->stash->{template} = 'maps/new.tt2';
    if ($c->req->params->{name}) {
	if (my $m = $c->model('Maps::Map')->create({ user_id => $c->user->uid, name => $c->req->params->{name}})) {
	    $m->center_lat($c->req->params->{lat});
	    $m->center_lon($c->req->params->{lon});
	    $m->update;
	    $c->res->redirect($c->uri_for('/maps', $c->user->uid, $c->req->params->{name}))
	} else {
	    $c->detach(qw/Controller::Error index/);
	}
    }
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




sub poi_edit :Chained('poi') :PathPart('edit') :Args(0) {
    my ( $self, $c ) = @_;
    if (keys %{$c->req->params}) {
	# editor contains the editor source
	# this cleans up the HTML
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

sub poi_delete  :Chained('poi') :PathPart('delete') :Args(0) {
    my ( $self, $c ) = @_;
    $c->log->info(ref $c->stash->{poi});
    my $map = $c->stash->{map};
    try {
	
	$c->stash->{poi}->delete;
	# $c->res->body("done");
	$c->res->redirect($c->uri_for('/maps', $map->user_id, $map->name));
    } catch {
	$c->detach(qw/Controller::Error index/);
    }
}


sub foobar :Path('/foobar') {
    my ($self, $c) = @_;

    $c->stash->{r} = [qw/vicenza amsterdam erlangen treviso venezia berlin/];
    $c->forward('View::JSON');

}


__PACKAGE__->meta->make_immutable;

1;


__DATA__

http://nominatim.openstreetmap.org/search?q=amsterdam&format=json
