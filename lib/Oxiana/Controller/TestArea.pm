package Oxiana::Controller::TestArea;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Oxiana::Controller::TestArea - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Oxiana::Controller::TestArea in TestArea.');
}

sub foo :Path :Args(1) {
    my ($self, $c, $include) = @_;
    $c->stash->{markdown} = <<EOF
## this is

- markdown
- text
- that has
- been included

then some more stuff

    a = 12

and some code

--------------

A line above this
EOF
	;
    $c->stash->{include} = $include;
    $c->stash->{template} = 'test_area/foo.tt2';
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
