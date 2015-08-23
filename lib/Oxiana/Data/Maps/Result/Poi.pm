package Oxiana::Data::Maps::Result::Poi;

use strict;
use warnings;
use Moose;

extends 'Oxiana::Data::Maps::ItemClass::SubItem';

__PACKAGE__->table("pois");

__PACKAGE__->load_components('InflateColumn::Serializer', 'Core');

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "map_id",
  { data_type => "integer", is_auto_increment => 0, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 64 },
  "lon",
  { data_type => "float", is_nullable => 1 },
  "lat",
  { data_type => "float", is_nullable => 1 },
  "poi_type",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "description",
  { data_type => "text", is_nullable => 1, is_serializable => 1 },
  "saved",
  { data_type => "integer", is_nullable => 1 },
  "extended_data",
  { 
   data_type => "text", is_nullable => 1,
   serializer_class => 'JSON',
   # is_serializable   => 1,
  },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->resultset_class('Oxiana::Data::Maps::ResultClass::SubItems');

__PACKAGE__->belongs_to('map' => 'Oxiana::Data::Maps::Result::Map', 
		       { 'foreign.id' => 'self.map_id' });

__PACKAGE__->has_many('book_items' => 'Oxiana::Data::Maps::Result::BookItem', 
			{
			 'foreign.poi_id' => 'self.id',
			});


__PACKAGE__->source_info({ "_parent_class" => 'map' });



sub has_description {
    my $self = shift;
    return $self->description && length($self->description) > 0 ? 1 : 0;
}

sub TO_JSON {
    my $self = shift;
    return { has_description => $self->has_description, %{ $self->next::method } }
}

sub as_XML {
    return "this is a stub";
}

use HTML::TreeBuilder;

sub print_description {
    my $desc = shift->description;
    return "" unless $desc;
    my $html = HTML::TreeBuilder->new_from_content($desc);
    for ($html->find('a')) {
	$_->replace_with($_->as_text)
    }
    return $html->find('body')->content->[0]->as_HTML(undef, " ");
}

1;
