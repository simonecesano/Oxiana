use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Oxiana';
use Oxiana::Controller::Location;

ok( request('/location')->is_success, 'Request should succeed' );
done_testing();
