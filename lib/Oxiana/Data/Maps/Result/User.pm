use utf8;
package Oxiana::Data::Maps::Result::User;

use strict;
use warnings;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
# use MooseX::NonMoose; # this is important for correctly handling DBIx::Class' new

# extends qw/DBIx::Class::Core Catalyst::Authentication::User/;
# extends qw/DBIx::Class::Core/;
extends 'Oxiana::Data::Maps::Result';
sub name { return shift->username };

__PACKAGE__->table("users");

__PACKAGE__->add_columns
    (
     'id'
     => {
	 'is_auto_increment' => 0,
	 'size' => '0',
	 'is_nullable' => 0,
	 'data_type' => 'varchar',
	 'size' => '128',
	 'name' => 'id',
	 'is_foreign_key' => 0,
	 'default_value' => undef
	},
     'username' 
     => {
	 'data_type' => 'varchar',
	 'name' => 'username',
	 'size' => '128',
	 'is_auto_increment' => 0,
	 'is_nullable' => 1,
	 'default_value' => undef,
	 'is_foreign_key' => 0
	 },
     'given_name' 
     => {
	 'is_nullable' => 1,
	 'is_auto_increment' => 0,
	 'size' => '128',
	 'name' => 'given_name',
	 'data_type' => 'varchar',
	 'default_value' => undef,
	 'is_foreign_key' => 0
	 },
     'family_name' 
     => {
	 'default_value' => undef,
	 'is_foreign_key' => 0,
	 'is_nullable' => 1,
	 'size' => '128',
	 'is_auto_increment' => 0,
	 'name' => 'family_name',
	 'data_type' => 'varchar'
	 },
     'email' 
     => {
	 'default_value' => undef,
	 'is_foreign_key' => 0,
	 'is_auto_increment' => 0,
	 'size' => '128',
	 'is_nullable' => 1,
	 'data_type' => 'varchar',
	 'name' => 'email'
	 },
     'password' 
     => {
	 'is_foreign_key' => 0,
	 'default_value' => undef,
	 'data_type' => 'varchar',
	 'name' => 'password',
	 'size' => '128',
	 'is_auto_increment' => 0,
	 'is_nullable' => 1
	 },
     uid
     => {
	 'is_foreign_key' => 0,
	 'default_value' => undef,
	 'data_type' => 'varchar',
	 'name' => 'uid',
	 'size' => '64',                  
	 'is_auto_increment' => 0,
	 'is_nullable' => 0
	}
     );

__PACKAGE__->set_primary_key("uid");

__PACKAGE__->has_many(
  "user_roles",
  "Oxiana::Data::Maps::Result::UserRole",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->many_to_many("roles", "user_roles", "role");

__PACKAGE__->resultset_class('Oxiana::Data::Maps::ResultSet::User');

__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
