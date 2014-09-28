use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Oxiana';
use Oxiana::Controller::Error;

ok( request('/error')->is_success, 'Request should succeed' );
done_testing();
