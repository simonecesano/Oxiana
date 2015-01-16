use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Oxiana';
use Oxiana::Controller::TestArea;

ok( request('/testarea')->is_success, 'Request should succeed' );
done_testing();
