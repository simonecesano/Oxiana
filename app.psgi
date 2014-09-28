use strict;
use warnings;

use lib './lib';

use Oxiana;

my $app = Oxiana->apply_default_middlewares(Oxiana->psgi_app);
$app;

