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
	# if ($c->authenticate( {
	# 		       username => $c->request->params->{'name'},
	# 		       password => $c->request->params->{'password'}
	# 		      } )) {  
	#     $c->res->redirect($c->uri_for("/home"));
	# } else {
	#     $c->stash->{template} = \"sorry";
	# }
    } else {
	$c->session->{login_referer} ||= $c->req->referer;
	$c->log->info(sprintf "login_referer %s\n", $c->req->referer);
	$c->log->info(sprintf "login_referer in session %s\n", $c->session->{login_referer});
	$c->stash->{template} = "login.tt2";
    }
}

sub logout :Path('/logout') :Args(0) {
    my ( $self, $c ) = @_;
    $c->logout;
    $c->res->redirect($c->uri_for("/"));
}

sub oauth :Path Args(1) {
    my ($self, $c, $provider) = @_;
    unless ($c->req->params->{code}) {
	$c->log->info(sprintf "without code - login_referer %s\n", $c->session->{login_referer});
	$c->authenticate({ provider => $provider });
    } else {
	$c->log->info(sprintf "with code - login_referer %s\n", $c->session->{login_referer});
	$c->authenticate({ provider => $provider });
	#------------------------------
	# need to redirect somewhere
	#------------------------------
	$c->res->redirect($c->uri_for("/maps", $c->user->uid || $c->session->{login_referer}));

	# $c->res->body('authenticated! "'. $c->user->uid . '"');
    }
}


__PACKAGE__->meta->make_immutable;

1;
