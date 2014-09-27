package Oxiana::Controller::Maps;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Oxiana::Controller::Maps - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(2) {
    my ( $self, $c, $user, $map ) = @_;
    $c->stash->{map} = $c->model('Maps::Map')->find({ user => $user, name => $map});
    $c->stash->{template} = 'maps/view.tt2';
}

sub poi :Path :Args(3) {
    my ( $self, $c, $user, $map, $poi ) = @_;
    if (defined $c->req->params) {
	my $h = $c->req->params->{desc_editor};
	$h =~ s/\n/ /gr;
	$c->log->info($h);
    } else {
	$c->stash->{map} = $c->model('Maps::Map')->find({ user => $user, name => $map});
	$c->stash->{poi} = $c->stash->{map}->find_related('pois', { name => $poi });
	$c->stash->{template} = 'maps/poi.tt2';
    }
}

=encoding utf8

=head1 AUTHOR

Cesano, Simone

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
