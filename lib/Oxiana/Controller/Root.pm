package Oxiana::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

Oxiana::Controller::Root - Root Controller for Oxiana

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'index.tt2';
    $c->forward('View::HTML');
}

use Try::Tiny;
use Data::Dump qw/dump/;
sub auto :Private {
    my ( $self, $c ) = @_;
    $c->log->info(('-' x 40) . " user " . ('-' x 40));

    $c->log->info(sprintf "Private path: %s\n", $c->action->private_path);
    $c->log->info(sprintf "Path: %s\n", $c->req->path);
    $c->log->info(sprintf "Reverse path: %s\n", $c->action->reverse);
    $c->log->info(sprintf "User agent: %s\n", $c->req->user_agent);
    $c->log->info(sprintf "Attributes:\n%s\n", dump $c->action->attributes);
    
    unless ($c->action->private_path =~ /\/index/
	    || $c->action->private_path =~ /\/login/) {
	$c->log->info("This action would be redirected");
    } else {
	$c->log->info("This action would not be redirected");
    }
    try {
	$c->log->info("The user is " . $c->user->uid);
    } catch {
	$c->log->info("The user is not logged in");
    }
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Cesano, Simone

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
