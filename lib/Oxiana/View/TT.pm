package Oxiana::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config
    (
     TEMPLATE_EXTENSION => '.tt2',
     render_die => 1,
     INCLUDE_PATH => [
		      Oxiana->path_to( 'root', 'src' ),
		      Oxiana->path_to( 'root', 'lib' )
		     ],
     ENCODING     => 'utf-8',
     ERROR        => 'error.tt2',
     PLUGIN_BASE => 'Oxiana::TT::Plugin',
);

=head1 NAME

Oxiana::View::TT - TT View for Oxiana

=head1 DESCRIPTION

TT View for Oxiana.

=head1 SEE ALSO

L<Oxiana>

=head1 AUTHOR

Cesano, Simone

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
