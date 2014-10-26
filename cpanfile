requires "base";
requires "namespace::autoclean";
requires "strict";
requires "utf8";
requires "Moose";

requires "Catalyst";
requires "Catalyst::Runtime";
requires "Catalyst::ScriptRunner";
requires "Data::Dump";
requires "JSON";
requires "LWP::Simple", '6.00';

# google maps processing
requires "Try::Tiny";
requires "IO::Socket::SSL";
requires "XML::Simple";
requires "XML::XPath";

requires "URI::QueryParam";
requires "URI";


requires "Catalyst::Plugin::ConfigLoader";
requires 'Catalyst::Action::RenderView', '0.16';
requires "Catalyst::Plugin::Static::Simple";
requires "Catalyst::Plugin::Authentication";
requires "Catalyst::Plugin::Session";
requires "Catalyst::Plugin::Session::Store::FastMmap";
requires "Catalyst::Plugin::Session::State::Cookie";

requires "Catalyst::Model::DBIC::Schema";
requires "DBD::Pg";

requires "Catalyst::View::TT";
requires "Catalyst::View::JSON";
requires "Catalyst::Model::Adaptor";
requires "Log::Log4perl::Catalyst"; 
requires "Template::Plugin::JSON";
requires "Template::Plugin::Dumper";
requires "Template::Plugin::Markdown";

requires "Config::General";

requires 'JSON::XS', '3.01';
requires 'DBIx::Class::InflateColumn::Serializer';
requires 'DBIx::Class::InflateColumn::Serializer::Hstore';
