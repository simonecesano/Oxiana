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
    -Debug
    ConfigLoader
    Static::Simple
    Authentication
    Session
    Session Session::Store::FastMmap
    Session::State::Cookie
/;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config
    (
     name => 'Oxiana',
     encoding => 'UTF-8',
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

$\ = "\n";

my $host = qx(hostname);
if ($host =~ /DEHER/) {
    __PACKAGE__->config( 'Plugin::ConfigLoader' => { file => 'oxiana.conf' } );
} else {
    __PACKAGE__->config( 'Plugin::ConfigLoader' => { file => 'oxiana_heroku.conf' } );
}

use Log::Log4perl::Catalyst;

__PACKAGE__->log( Log::Log4perl::Catalyst->new() );

__PACKAGE__->setup();

sub uri_for {
    my $self = shift;
    my $uri = $self->next::method(@_);
    $uri =~ s/\.com:\d+/.com/;
    return $uri;
}


1;
