use utf8;
package Oxiana::Data::Maps::Result::Pois;

use strict;
use warnings;

use base 'Oxiana::Data::Maps::Result';

__PACKAGE__->table("pois");

__PACKAGE__->load_components('InflateColumn::Serializer', 'Core');

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "map_id",
  { data_type => "integer", is_auto_increment => 0, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 64 },
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

__PACKAGE__->resultset_class('Oxiana::Data::Maps::ResultClass::Pois');

__PACKAGE__->belongs_to('maps' => 'Oxiana::Data::Maps::Result::Map', 
		       { 'foreign.id' => 'self.map_id' });


sub has_description {
    my $self = shift;
    return $self->description && length($self->description) > 0 ? 1 : 0;
}

sub TO_JSON {
    my $self = shift;
    return { has_description => $self->has_description, %{ $self->next::method } }
}

1;
