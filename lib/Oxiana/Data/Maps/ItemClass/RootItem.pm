use utf8;

package Oxiana::Data::Maps::ItemClass::RootItem;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw{Helper::Row::ToJSON});

sub readable_by {
    my ($self, $relationship, $user) = @_;
    my $o = $self;
    return ((index($o->user_id, $user) >= 0) || (index($o->can_read, $user) >= 0) || (index($o->can_write, $user) >= 0))
}

sub writeable_by {
    my ($self, $relationship, $user) = @_;
    my $o = $self;
    return ((index($o->user_id, $user) >= 0) || (index($o->can_write, $user) >= 0))
}

1;


__DATA__
sub has_rights {
    my ($self, $user, $rights) = @_;
    return 1 if $self->can_read eq '*';

    my $uid = ref $user ? $user->uid : $user;
    return 1 if $self->user_id eq $uid;

    $uid = quotemeta($uid);
    return $self->can_read =~ /$uid/;
}

sub is_readable_by {
    my ($self, $user) = @_;
    return $self->has_rights($user, 'can_read');
}

sub is_writeable_by {
    my ($self, $user) = @_;
    return $self->has_rights($user, 'can_write');
}

