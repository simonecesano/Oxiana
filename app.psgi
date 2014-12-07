use strict;
use warnings;

use lib './lib';
use Plack::Builder;
use Plack::App::File;

use Oxiana;

my $app = Oxiana->apply_default_middlewares(Oxiana->psgi_app);

builder {
    mount "/" => builder { $app };
    mount "/static" => builder { Plack::App::File->new(root => "./root/static")->to_app };
}

