use utf8;
package Oxiana::Data::Maps::ResultSet::User;

use strict;
use warnings;
use DateTime;
use parent 'DBIx::Class::ResultSet';
# use parent 'Catalyst::Authentication::Store::DBIx::Class';

sub create_or_update_user {
    my $self = shift;
    my $data = shift;

    my %conv = qw/last_name family_name first_name given_name name username/;

    $data->{id} = join '::', $data->{id}, $data->{provider};
    for (keys %conv) { $data->{$conv{$_}} = $data->{$_} if $data->{$_} };
    for (keys %$data) { delete $data->{$_} unless $self->result_source->has_column($_) };

    my $u;
    unless ($u = $self->find({ id => $data->{id} })) {
	$u = $self->create({ id => (join '::', $data->{id}, $data->{provider}), uid => $self->create_uid($data->{given_name}) });
    }
    $u->update($data);
    return $u;
}

sub create_uid {
    my $self = shift;
    my $name = shift;
    my $uid = _uid($name);
    while ($self->search({ uid => $uid })->count) { $uid = _uid($name) }
    return $uid;
}

use List::Util qw(shuffle);

sub _uid {
    my ($name, $l) = @_; $l ||= 3;
    my @a = (('a'..'z', 'A'..'Z', 0..9) x $l);
    return join '.', (lc $name), (substr ((join '', shuffle @a), 0, $l));
}

sub __uid {
    return sprintf "%x", int(rand(16 ** 6));
}

1;
