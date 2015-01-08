use strict;
use warnings;

use lib './lib';
use Plack::Builder;
use Plack::App::File;

use Oxiana;

my $app = Oxiana->apply_default_middlewares(Oxiana->psgi_app);

builder {
    enable 'CrossOrigin', origins => '*';
    mount "/favicon.ico" => Plack::App::File->new(file => './root/favicon.ico')->to_app;
    mount "/static" => builder { Plack::App::File->new(root => "./root/static")->to_app };
    mount "/" => builder { $app };
}

