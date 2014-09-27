use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Oxiana';
use Oxiana::Controller::Plan;

ok( request('/plan')->is_success, 'Request should succeed' );
done_testing();
