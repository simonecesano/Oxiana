package Oxiana::Controller::Books;
use Moose;
use namespace::autoclean;

use Data::Dump qw/dump/;

BEGIN { extends 'Catalyst::Controller'; }

sub auto :Private {
    my ( $self, $c ) = @_;
    $c->log->info($c->user);
    unless ($c->user) {
	$c->log->info($c->uri_for($c->action));
	$c->res->redirect($c->uri_for("/login"));
	$c->detach;
    }
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Oxiana::Controller::Book in Book.');
}

sub base :Chained("/") :PathPart("books") :CaptureArgs(0) {}

sub book :Chained('base') :PathPart('') :CaptureArgs(3) {
    my ( $self, $c, $user, $book_id, $book ) = @_;
    $c->stash->{book} = $c->model('Maps::Book')->find({ user_id => $user, id => $book_id});
    if ($c->stash->{book}) { 
	$c->stash->{user} = $user;
    } else {
    	$c->detach(qw/Controller::Error index/);
    }
}

sub book_list :Chained('base') :PathPart('') :Args(1) {
    my ( $self, $c, $user ) = @_;
    #---------------------------
    # this should be checked
    #---------------------------
    $c->stash->{user} = $user;
    $c->stash->{books} = $c->model('Maps::Book'); #->writeable_by($user);
    $c->log->info("count " . $c->stash->{books}->count);
    $c->log->info("all   " . (join ', ', map { $_->name } $c->stash->{books}->all));
    $c->log->info("user  " . $user);
    if ($c->stash->{books}) { 
	$c->stash->{books} = $c->model('Maps::Book')->search({ user_id => $user });
	$c->log->info("count " . $c->stash->{books}->count);
	$c->stash->{template} = "books/list.tt2"
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
	    $c->res->body($c->uri_for('/books', $c->user->uid, $m->id, $m->name))
	} else {
	    $c->detach(qw/Controller::Error index/);
	}
    }
}

sub book_view :Chained('book') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'books/view.tt2';
}

use JSON;
use Data::Dump qw/dump/;

sub pois_add :Chained('base') :PathPart('pois/add') :Args(0) {
    my ( $self, $c ) = @_;
    my @pois = map { $_->{properties} } @{from_json($c->req->param('pois'))->{pois}};
    $c->log->info(dump \@pois);
    $c->log->info(from_json($c->req->param('pois')));

    my $chapter_id = ($c->req->param('new_chapter') eq 'true') ?
	$c->model('Maps::Chapter')->create({ name => $c->req->param('chapter_name'), map_id => $c->req->param('map_id'), book_id => $c->req->param('book_id') })->id :
	$c->req->param('chapter_id');
    $c->detach(qw/Controller::Error index/) unless $chapter_id;

    my $items = $c->model('Maps::BookItem'); 
    for (@pois) {
	$items->create({
			poi_id => $_->{id},
			book_id => $c->req->param('book_id'),
			chapter_id => $chapter_id,
			item_type => 'poi'
		       }) unless $items->search({ poi_id => $_->{id}, chapter_id => $chapter_id })->count;
    }
    $c->res->body('hello');
}

sub book_print_view :Chained('book') :PathPart('print') :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'books/print.tt2';
    $c->forward('View::HTML');
    
}



__PACKAGE__->meta->make_immutable;

1;


__DATA__

