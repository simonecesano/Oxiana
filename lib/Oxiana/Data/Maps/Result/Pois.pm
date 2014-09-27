use utf8;
package Oxiana::Data::Maps::Result::Pois;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Oxiana::Data::Maps::Result::Pois

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<pois>

=cut

__PACKAGE__->table("pois");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 lon

  data_type: 'float'
  is_nullable: 1

=head2 lat

  data_type: 'float'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 saved

  data_type: 'integer'
  is_nullable: 1

=cut

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
  "description",
  { data_type => "text", is_nullable => 1 },
  "saved",
  { data_type => "integer", is_nullable => 1 },
  "extended_data",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07040 @ 2014-09-18 22:32:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3M1YfItKj8fp4bGq5+h2Ng

__PACKAGE__->resultset_class('Oxiana::Data::Maps::ResultClass::Pois');

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
