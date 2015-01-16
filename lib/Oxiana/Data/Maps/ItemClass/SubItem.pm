use utf8;

package Oxiana::Data::Maps::ItemClass::SubItem;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw{Helper::Row::ToJSON});

sub readable_by {
    my ($self, $relationship, $user) = @_;
    my $o = $self->find_related($relationship, {});
    return ((index($o->user_id, $user) >= 0) || (index($o->can_read, $user) >= 0) || (index($o->can_write, $user) >= 0))
}

sub writeable_by {
    my ($self, $relationship, $user) = @_;
    my $o = $self->find_related($relationship, {});
    return ((index($o->user_id, $user) >= 0) || (index($o->can_write, $user) >= 0))
}

1;
