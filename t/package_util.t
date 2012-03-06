#!perl -T

use 5.010;
use strict;
use warnings;

use SHARYANTO::Package::Util qw(package_exists);
use Test::More 0.96;

BEGIN { ok(!package_exists("cps61kDkaNlLTrdXC91"), "package_exists 1"); }

package cps61kDkaNlLTrdXC91;
package main;

ok( package_exists("cps61kDkaNlLTrdXC91"), "package_exists 1b");

package cps61kDkaNlLTrdXC92::cps61kDkaNlLTrdXC93;
package main;

ok( package_exists("cps61kDkaNlLTrdXC92"), "package_exists 2");
ok( package_exists("cps61kDkaNlLTrdXC92::cps61kDkaNlLTrdXC93"),
    "package_exists 3");

DONE_TESTING:
done_testing();
