package Oxiana::Model::Google::Maps;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Model::Adaptor';
__PACKAGE__->config( class => 'HTTP::Tiny' );


=head1 NAME

Oxiana::Model::Google::Maps - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.


=encoding utf8

=head1 AUTHOR

Cesano, Simone

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
