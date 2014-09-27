package Oxiana::Data::Maps::ResultClass::Pois;

use base 'DBIx::Class::ResultSet';

use strict;
use warnings;
no warnings qw/uninitialized/;


use JSON;

sub as_json {
    my $self = shift;
    $self = $self->search;
    $self->result_class('DBIx::Class::ResultClass::HashRefInflator');

    my $json = JSON->new;
    return $json->pretty->encode([ $self->all ]);
}

sub foo {
    return 'hallo'
}

1
