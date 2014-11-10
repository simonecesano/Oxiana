use utf8;
package Oxiana::Data::Maps::Result::UserRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Oxiana::Data::Maps::Result::UserRole

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user_role>

=cut

__PACKAGE__->table("user_role");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 role_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "role_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=item * L</role_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id", "role_id");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Oxiana::Data::Maps::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Oxiana::Data::Maps::Result::Role",
  { id => "role_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 user

Type: belongs_to

Related object: L<Oxiana::Data::Maps::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Oxiana::Data::Maps::Result::User",
  { id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07040 @ 2014-11-01 10:48:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OMvoTMe6icWf75tLMEyvcg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
