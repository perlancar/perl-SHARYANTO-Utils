#!perl

use 5.010;
use strict;
use warnings;

use SHARYANTO::Version::Util qw(
                                   cmp_version
                                   version_eq
                                   version_lt version_le version_gt version_ge);
use Test::More 0.96;

subtest cmp_version => sub {
    is(cmp_version("1.1.0", "1.1.0"),  0);
    is(cmp_version("1.1.2", "1.2.0"), -1);
    is(cmp_version("1.11" , "1.9.0"),  1);
};

subtest version_eq => sub {
    ok(!version_eq("1.1.0" , "1.2.0"));
    ok( version_eq("1.1.0" , "1.1.0"));
    ok(!version_eq("1.1.0" , "1.0.1"));
};

subtest version_gt => sub {
    ok(!version_gt("1.1.0" , "1.2.0"));
    ok(!version_gt("1.1.0" , "1.1.0"));
    ok( version_gt("1.1.0" , "1.0.1"));
};

subtest version_ge => sub {
    ok(!version_ge("1.1.0" , "1.2.0"));
    ok( version_ge("1.1.0" , "1.1.0"));
    ok( version_ge("1.1.0" , "1.0.1"));
};

subtest version_lt => sub {
    ok( version_lt("1.1.0" , "1.2.0"));
    ok(!version_lt("1.1.0" , "1.1.0"));
    ok(!version_lt("1.1.0" , "1.0.1"));
};

subtest version_le => sub {
    ok( version_le("1.1.0" , "1.2.0"));
    ok( version_le("1.1.0" , "1.1.0"));
    ok(!version_le("1.1.0" , "1.0.1"));
};

DONE_TESTING:
done_testing();
