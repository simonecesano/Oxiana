use utf8;
package Oxiana::Data::Maps::Result::Pois;

use strict;
use warnings;

use base 'DBIx::Class::Core';

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
  { data_type => "text", is_nullable => 1 },
  "saved",
  { data_type => "integer", is_nullable => 1 },
  "extended_data",
  { 
   data_type => "text", is_nullable => 1,
   serializer_class => 'JSON',
  },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->resultset_class('Oxiana::Data::Maps::ResultClass::Pois');

1;
