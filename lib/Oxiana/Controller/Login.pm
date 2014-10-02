package Oxiana::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Oxiana::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    my $name = $c->req->params->{name};

    if ($name) {
	if ($c->authenticate( {
			       username => $c->request->params->{'name'},
			       password => $c->request->params->{'password'}
			      } )) {  
	    $c->res->redirect($c->uri_for("/home"));
	} else {
	    $c->stash->{template} = \"sorry";
	}
    } else {
	$c->stash->{template} = "login.tt2";
    }
}

sub logout :Path('/logout') :Args(0) {
    my ( $self, $c ) = @_;
    $c->logout;
    $c->res->redirect($c->uri_for("/"));
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
