requires Catalyst;
requires Catalyst::Runtime;
requires Catalyst::ScriptRunner;
requires Data::Dump;
requires JSON;
requires LWP::Simple;
requires Moose;
requires Try::Tiny;
requires XML::Simple;
requires XML::XPath;
requires base;
requires namespace::autoclean;
requires strict;
requires utf8;
requires warnings
requires Template::Plugin::JSON;
requires Template::Plugin::Dumper;

requires Catalyst::Plugin::ConfigLoader;
requires Catalyst::Plugin::Static::Simple;
requires Catalyst::Plugin::Authentication;
requires Catalyst::Plugin::Session;
requires Catalyst::Plugin::Session Session::Store::FastMmap;
requires Catalyst::Plugin::Session::State::Cookie;