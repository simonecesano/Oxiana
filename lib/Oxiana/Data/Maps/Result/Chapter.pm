use utf8;
package Oxiana::Data::Maps::Result::Chapter;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Oxiana::Data::Maps::Result::BookItem

=cut

use strict;
use warnings;

# use base 'DBIx::Class::Core';
use base 'Oxiana::Data::Maps::ItemClass::SubItem';

=head1 TABLE: C<maps>

=cut

__PACKAGE__->table("chapters");

__PACKAGE__->add_columns
    (
     "id",
     { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
     "name",
     { data_type => "varchar", is_nullable => 1, size => 64 },
     # "chapter_sequence",
     # { data_type => "integer", is_nullable => 1, accessor => 'sequence' },
     "book_id",
     { data_type => "integer", is_nullable => 0 },
     "map_id",
     { data_type => "integer", is_nullable => 0 },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->add_unique_constraint([ qw/name/ ]);

__PACKAGE__->belongs_to('book' => 'Oxiana::Data::Maps::Result::Book', 
		       { 'foreign.id' => 'self.book_id' });

__PACKAGE__->belongs_to('map' => 'Oxiana::Data::Maps::Result::Map', 
		       { 'foreign.id' => 'self.map_id' });

__PACKAGE__->might_have('items' => 'Oxiana::Data::Maps::Result::BookItem', 
		       { 'foreign.chapter_id' => 'self.id' });

1;

