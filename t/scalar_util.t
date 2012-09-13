#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More 0.96;

use SHARYANTO::Scalar::Util qw(looks_like_int looks_like_float looks_like_real);

my @ints = (0, 1, -1, "1", "-1",
            "1111111111111111111111111111111111111111",
            "-1111111111111111111111111111111111111111");
my @floats = (1.1, -1.1, 1.11e1, -1.11e1, "1.1", "-1.1", "1e10", "-1e10",
              "1e-1000", "-1e-1000",
              "11111111111111111111111111111111111111.1",
              "-11111111111111111111111111111111111111.1",
              "Inf", "-Inf", "Infinity", "-Infinity",
              "NaN", "-nan",);
my @nonnums = ("", " ", "123a", "1e", "-", "+", "abc");

ok( looks_like_int($_), "looks_like_int($_)=1") for @ints;
ok(!looks_like_int($_), "looks_like_int($_)=0") for @floats;
ok(!looks_like_int($_), "looks_like_int($_)=0") for @nonnums;

ok(!looks_like_float($_), "looks_like_float($_)=0") for @ints;
ok( looks_like_float($_), "looks_like_float($_)=1") for @floats;
ok(!looks_like_float($_), "looks_like_float($_)=0") for @nonnums;

ok( looks_like_real($_), "looks_like_real($_)=1") for @ints;
ok( looks_like_real($_), "looks_like_real($_)=1") for @floats;
ok(!looks_like_real($_), "looks_like_real($_)=0") for @nonnums;

DONE_TESTING:
done_testing();
