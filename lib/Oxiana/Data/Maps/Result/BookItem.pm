use utf8;
package Oxiana::Data::Maps::Result::BookItem;

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

__PACKAGE__->table("book_items");

__PACKAGE__->add_columns
    (
     "id",
     { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
     "book_id",
     { data_type => "integer", is_nullable => 0 },
     "chapter_id",
     { data_type => "integer", is_nullable => 0 },
     "poi_id",
     { data_type => "integer", is_nullable => 0, default_value => 0 },
     "item_sequence",
     { data_type => "integer", is_nullable => 1, accessor => 'sequence' },
     "item_type", # latex, html, markdown, image in base64, PDF
     { data_type => "varchar", is_nullable => 1, size => 64, accessor => 'type' },
     "path",     # path when output to filesystem
     { data_type => "varchar", is_nullable => 1, size => 512 },
     "content",  # LaTeX converted from POI, LaTeX from markdown, or image or whatever
     { data_type => "text", is_nullable => 1 },
     "saved",
     { data_type => "integer", is_nullable => 1 },
);


sub item_sequence { return shift->sequence(@_) };
sub item_type { return shift->type(@_) };

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to('book' => 'Oxiana::Data::Maps::Result::Book', 
		       { 'foreign.id' => 'self.book_id' });

__PACKAGE__->belongs_to('chapter' => 'Oxiana::Data::Maps::Result::Chapter', 
		       { 'foreign.id' => 'self.chapter_id' });

__PACKAGE__->has_many('related_items' => 'Oxiana::Data::Maps::Result::BookItem', 
			{
			 'foreign.poi_id' => 'self.poi_id',
			 'foreign.book_id' => 'self.book_id'
			});

__PACKAGE__->might_have('poi' => 'Oxiana::Data::Maps::Result::Poi', 
		       { 'foreign.id' => 'self.poi_id' });

__PACKAGE__->source_info({ "_parent_class" => 'book' });

1;

