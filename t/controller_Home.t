use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Oxiana';
use Oxiana::Controller::Home;

ok( request('/home')->is_success, 'Request should succeed' );
done_testing();
