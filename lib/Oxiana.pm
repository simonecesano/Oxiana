package Oxiana;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    ConfigLoader
    Static::Simple
    Authentication
    Session
    Session Session::Store::FastMmap
    Session::State::Cookie
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in oxiana.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config
    (
     name => 'Oxiana',
     'default_view' => 'HTML',
     disable_component_resolution_regex_fallback => 1,
     enable_catalyst_header => 1, # Send X-Catalyst header
     'Plugin::Static::Simple'
     => {
	 dirs
	 => [
	     '/static',
	     qr/^(images|css)/,
	    ],
	 no_logs => 1,
	 logging => 0,
	},
     'Plugin::Authentication'
     => {
	 default_realm => 'users',
	 realms
	 => {
	     users
	     => {
		 credential
		 => {
		     class => 'Password',
		     password_field => 'password',
		     password_type => 'clear'
		    },
		 store
		 => {
		     class => 'Minimal',
		     users
		     => {
			 simone => { password => "luca" },
			 tomas  => { password => "leonardo" }
			}
		    }
		}
	    }
	}
    );

# Start the application
__PACKAGE__->setup();

sub uri_for {
    my $self = shift;
    my $uri = $self->next::method(@_);
    $uri =~ s/\.com:\d+/.com/;
    return $uri;
}


=encoding utf8

=head1 NAME

Oxiana - Catalyst based application

=head1 SYNOPSIS

    script/oxiana_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Oxiana::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Cesano, Simone

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
