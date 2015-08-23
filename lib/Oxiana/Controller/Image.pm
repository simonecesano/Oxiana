package Oxiana::Controller::Image;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Oxiana::Controller::Image - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $re = quotemeta("data:image/png;base64,");
    my $img = $c->req->params->{img}; $img =~ s/^$re//;

    if ($img) {
	my $m = $c->model('Maps::BookItem');
	my $p = $c->req->params;
	my $item = $m->create({ item_type => 'map', poi_id => $p->{poi_id}, content => $img, book_id => $p->{book_id}, chapter_id => $p->{chapter_id} }); 
	unless ($item) {	
	    $c->res->status(500);
	    $c->detach('Modal', 'index', [ 'error' ]);
	}
	$c->res->body('yeah');
    } else {
    
	# my $cmd = printf "echo \"%s\" | base64 -D > foobar.png", $img;
	
	# $c->log->info(qx/$cmd/);

	# my $pois = $m->search(poi_id => $c->req->params->{poi_id});
	# my $poi;
	# for ($pois->count) {
	#     /^0$/ && do {
	# 	# ask for chapter
	# 	last;
	#     };
	#     /^1$/ && do {
	# 	$poi = $pois->first;
	# 	last;
	#     };
	#     # ask for book and chapter
	# }
	
	
	# check that the book exists
	# check whether the poi is in a chapter, and if so, add
	# if not pop up a window
	
	# open my $fh, '>', 'foobar_2.base64.png';
	# print $fh $img;
	
	$c->detach('Modal', 'index', [ 'take_picture' ]);
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
