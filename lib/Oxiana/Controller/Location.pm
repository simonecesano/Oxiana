package Oxiana::Controller::Location;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Oxiana::Controller::Location - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    if ($c->req->params->{name}) {
	$c->detach(qw/Controller::Poi add/);
    }
}

__PACKAGE__->meta->make_immutable;

1;
