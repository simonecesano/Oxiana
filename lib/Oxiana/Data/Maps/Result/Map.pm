use utf8;
package Oxiana::Data::Maps::Result::Map;

use strict;
use warnings;

use base 'Oxiana::Data::Maps::ItemClass::RootItem';

__PACKAGE__->table("maps");

__PACKAGE__->add_columns
    (
     "id",
     { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
     "user_id",
     { data_type => "varchar", is_nullable => 1, size => 32 },
     "name",
     { data_type => "varchar", is_nullable => 1, size => 64 },
     "saved",
     { data_type => "integer", is_nullable => 1 },
     "can_read",
     { data_type => "text", is_nullable => 1 },
     "can_write",
     { data_type => "text", is_nullable => 1 },
     "center_lat",
     { data_type => "float", is_nullable => 1 },
     "center_lon",
     { data_type => "float", is_nullable => 1 },
);

__PACKAGE__->resultset_class('Oxiana::Data::Maps::ResultClass::Map');

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many('pois' => 'Oxiana::Data::Maps::Result::Poi', 
		       { 'foreign.map_id' => 'self.id' });


1;
