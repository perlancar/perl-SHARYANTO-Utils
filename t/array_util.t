#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More 0.96;

use SHARYANTO::Array::Util qw(match_array_or_regex match_regex_or_array);

ok( match_array_or_regex("foo", [qw/foo bar baz/]), "match array 1");
ok(!match_array_or_regex("qux", [qw/foo bar baz/]), "match array 2");

ok( match_array_or_regex("foo", qr/foo?/), "match regex 1");
ok(!match_array_or_regex("qux", qr/foo?/), "match regex 2");

eval { match_array_or_regex("foo", {}) };
my $eval_err = $@;
ok($eval_err, "match invalid -> dies");

ok( match_regex_or_array("foo", qr/foo?/), "alias 1");
ok(!match_array_or_regex("qux", qr/foo?/), "alias 2");

DONE_TESTING:
done_testing();
