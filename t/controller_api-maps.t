use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Oxiana';
use Oxiana::Controller::api::maps;

ok( request('/api/maps')->is_success, 'Request should succeed' );
done_testing();
