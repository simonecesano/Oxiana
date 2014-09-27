package Oxiana::Controller::Home;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Oxiana::Controller::Home - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
use Data::Dump qw/dump/;

sub index :Path :Args(1) {
    my ( $self, $c, $name ) = @_;
    $c->log->info("User: " . ($c->user->{id}));
    $c->log->info("Name: " . $name);
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
