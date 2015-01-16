package Oxiana::Data::Maps::ResultClass::RootItems;

use Moose;
extends 'DBIx::Class::ResultSet';

use strict;
use warnings;
no warnings qw/uninitialized/;

sub writeable_by {
    my $self = shift;
    my $user = shift;
    return $self->search( [
			   { user_id => $user },
			   { can_write => '*' },
			   \ [ 'position(? in can_write) > 0', $user ],
			  ])
}

sub readable_by {
    my $self = shift;
    my $user = shift;
    return $self->search( [
			   { user_id => $user },
			   { can_read => '*' },
			   { can_write => '*' },
			   \ [ 'position(? in can_write) > 0', $user ],
			   \ [ 'position(? in can_read) > 0', $user ],
			  ])
}

__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1
