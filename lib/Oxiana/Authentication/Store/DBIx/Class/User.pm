package Oxiana::Authentication::Store::DBIx::Class::User;
use Moose;
use namespace::autoclean;

extends "Catalyst::Authentication::Store::DBIx::Class::User";

use Data::Dump qw/dump/;

override 'for_session' => sub {
    my $self = shift;
    # print STDERR '-' x 80;
    # _dump($self);
    
    return super();
};


sub _dump {
    local $\ = "\n";
    print STDERR '-' x 80;
    print STDERR join ' ', caller();
    print STDERR dump @_;
    print STDERR '-' x 80; 
}

# print STDERR ('+' x 80) . "\n";

