use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Oxiana';
use Oxiana::Controller::Image;

ok( request('/image')->is_success, 'Request should succeed' );
done_testing();
