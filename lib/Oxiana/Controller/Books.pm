package Oxiana::Controller::Books;
use Moose;
use namespace::autoclean;

use Data::Dump qw/dump/;

BEGIN { extends 'Catalyst::Controller'; }

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Oxiana::Controller::Book in Book.');
}

sub base :Chained("/") :PathPart("books") :CaptureArgs(0) {}

sub book :Chained('base') :PathPart('') :CaptureArgs(2) {
    my ( $self, $c, $user, $book ) = @_;
    $c->stash->{book} = $c->model('Maps::Book')->find({ user_id => $user, name => $book});
    if ($c->stash->{book}) { 
	$c->stash->{user} = $user;
    } else {
    	$c->detach(qw/Controller::Error index/);
    }
}

sub list :Chained('base') :PathPart('') :Args(1) {
    my ( $self, $c, $user ) = @_;
    #---------------------------
    # this should be checked
    #---------------------------
    $c->stash->{user} = $user;
    $c->stash->{books} = $c->model('Maps::Book')->writeable_by($user);
    if ($c->stash->{books}) { 
	$c->res->content_type('text/plain');
	$c->res->body(dump [ map { $_->name } $c->stash->{books}->all ] )
    } else {
    	$c->detach(qw/Controller::Error index/);
    }
}

sub book_new :Chained('base') :PathPart('new') :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'books/new.tt2';
    $c->log->info('Create new book');
    $c->log->info($c->req->content_type);

    if (my $name = $c->req->params->{name} || $c->req->params->{json}) {
	$c->log->info($name);
	if (my $m = $c->model('Maps::Book')->create({ user_id => $c->user->uid, name => $name })) {
	    $m->update;
	    $c->res->body($c->uri_for('/books', $c->user->uid, $name))
	} else {
	    $c->detach(qw/Controller::Error index/);
	}
    }
}

sub book_view :Chained('book') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    
    $c->log->info($c->user->user_id);
    my $uid = $c->user->uid;
    $c->stash->{maps} = $c->model('Maps::Map')->readable_by($uid);
    
    $c->stash->{template} = 'books/view.tt2';
}

sub pois_add :Chained('base') :PathPart('pois/add') :Args(0) {
    my ( $self, $c ) = @_;
    $c->res->body('hello');
}

__PACKAGE__->meta->make_immutable;

1;
