package Oxiana::Model::Google::Maps;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Model::Adaptor';
__PACKAGE__->config( class => 'HTTP::Tiny' );


# sub mangle_arguments {
#     my ($self, $args) = @_;
#     return ( agent => 'curl/7.8 (i386-redhat-linux-gnu) libcurl 7.8 (OpenSSL 0.9.6b) (ipv6 enabled)')
# }

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
