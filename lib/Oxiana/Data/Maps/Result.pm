use utf8;

package Oxiana::Data::Maps::Result;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw{Helper::Row::ToJSON});

1;
