package Oxiana::Data::Maps::ResultClass::SubItems;

use Moose;
extends 'DBIx::Class::ResultSet';

use Class::ISA;
use Data::Dump qw/dump/;

use strict;
use warnings;
no warnings qw/uninitialized/;


sub writeable_by {
    my ($self, $user) = @_;
    return $self->search({ map_id =>
			   { -in => $self->search_related($self->result_source->source_info->{_parent_class})
			                 ->writeable_by($user)
			                 ->get_column('id')->as_query } })
}

sub readable_by {
    my ($self, $user) = @_;
    printf STDERR "%s\n%s\n%s\n", '-' x 80, (dump [ Class::ISA::super_path(ref $self),
						    $self->result_source->relationships,
						    $self->result_source->source_info->{_parent_class} ]), '-' x 80;
    return $self->search({ map_id =>
			   { -in => $self->search_related($self->result_source->source_info->{_parent_class})
			                 ->readable_by($user)
			                 ->get_column('id')->as_query } })
}

__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1
