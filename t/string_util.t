#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More 0.96;

use SHARYANTO::String::Util qw(trim_blank_lines);

ok( !defined(trim_blank_lines(undef)), "trim_blank_lines undef" );
is( trim_blank_lines("\n1\n\n2\n\n \n"), "1\n\n2\n", "trim_blank_lines 1" );

DONE_TESTING:
done_testing();
