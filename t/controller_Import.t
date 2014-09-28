use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Oxiana';
use Oxiana::Controller::Import;

ok( request('/import')->is_success, 'Request should succeed' );
done_testing();
