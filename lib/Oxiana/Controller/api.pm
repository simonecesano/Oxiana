package Oxiana::Controller::api;
use Moose;
use namespace::autoclean;
use utf8;

use List::AllUtils qw/zip/;
use Data::Dump qw/dump/;
use JSON;

BEGIN { extends 'Catalyst::Controller'; }

sub index :Path :Args(0) {
    my ( $self, $c, $model ) = @_;

    $c->response->body('nothing to look at here');
}

sub base :Chained("/") :PathPart("api") :CaptureArgs(0) {}

sub tables :Chained('base') :PathPart('') :Args(1) {
    my ($self, $c, $model) = @_;
    $c->res->body("list of tables for $model which is a " . (ref $c->model($model)));
}


sub item :Chained('base') :PathPart('') :CaptureArgs(2) {
    my ( $self, $c, $model, $table ) = @_;

    $c->log->info(join ' ', 'Model and table:', $model, $table);
    $c->stash->{search} = $c->model(join '::', $model, $table);
}


sub list_view :Chained('item') :PathPart('') :Args(0) {
    my ( $self, $c, $model, $table ) = @_;
    my $page   = $c->req->params->{p} || 1;
    my $items  = $c->req->params->{i} || 25;
    my $q;

    my $search =  $c->stash->{search};

    $c->detach(qw/Controller::Error index/) unless defined $search;

    for (grep { length > 1 } keys %{$c->req->params}) { $q->{$_} = $c->req->params->{$_} }
    $c->stash->{res} = [ map { $_->TO_JSON } $search->search($q)->all ];
}


sub item_view :Chained('item') :PathPart('') {
    my ( $self, $c, @args ) = @_;
    my $search = $c->stash->{search};
    my @keys = $search->result_source->primary_columns;
    if ($c->stash->{res} = $search->find({ zip @keys, @args })) {
	$c->stash->{res} = $c->stash->{res}->TO_JSON;
    } else {
	$c->detach(qw/Controller::Error index/);
    }
}

sub end :Private {
    my ($self, $c) = @_;
    my $json = JSON->new;
    $c->res->content_type('application/json');
    $c->res->body($json->utf8(1)->allow_nonref(1)->encode($c->stash->{res}));
    # $c->res->body(dump $c->stash->{res});
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
