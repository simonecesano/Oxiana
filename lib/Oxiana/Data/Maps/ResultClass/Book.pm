package Oxiana::Data::Maps::ResultClass::Book;

use base 'DBIx::Class::ResultSet';

use strict;
use warnings;
no warnings qw/uninitialized/;

sub writeable_by {
    my $self = shift;
    my $user = shift;
    return $self->search( [ \ [ 'position(? in can_write) > 0', $user ], { user_id => $user } ])
}

sub readable_by {
    my $self = shift;
    my $user = shift;
    return $self->search( [ \ [ 'position(? in can_write) > 0', $user ], \ [ 'position(? in can_read) > 0', $user ], { user_id => $user } ])
}

1
