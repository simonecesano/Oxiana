requires "Catalyst";
requires "Catalyst::Runtime";
requires "Catalyst::ScriptRunner";
requires "Data::Dump";
requires "JSON";
requires "LWP::Simple", '6.00';
requires "Moose";
requires "Try::Tiny";
requires "XML::Simple";
requires "XML::XPath";
requires "base";
requires "namespace::autoclean";
requires "strict";
requires "utf8";
requires "Template::Plugin::JSON";
requires "Template::Plugin::Dumper";

requires "Catalyst::Plugin::ConfigLoader";
requires "Catalyst::Plugin::Static::Simple";
requires "Catalyst::Plugin::Authentication";
requires "Catalyst::Plugin::Session";
requires "Catalyst::Plugin::Session::Store::FastMmap";
requires "Catalyst::Plugin::Session::State::Cookie";

requires "Catalyst::Model::DBIC::Schema";
requires "DBD::Pg";

requires "Catalyst::View::TT";
requires "Catalyst::View::JSON";

requires "Config::General";

requires 'Catalyst::Action::RenderView', '0.16';
requires 'JSON::XS', '3.01';