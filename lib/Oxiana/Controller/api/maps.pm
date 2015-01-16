package Oxiana::Controller::api::maps;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

sub auto :Private {
    my ( $self, $c ) = @_;
    $c->log->info('#' x 80);
}

__PACKAGE__->meta->make_immutable;

1;
