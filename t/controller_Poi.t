use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Oxiana';
use Oxiana::Controller::Poi;

ok( request('/poi')->is_success, 'Request should succeed' );
done_testing();
