#!perl

use 5.010;
use strict;
use warnings;

use SHARYANTO::Getopt::Long::Util qw(
                                        gospec2human
                         );
use Test::More 0.98;

subtest gospec2human => sub {
    is(gospec2human('help|h|?'), '--help, -h, -?');
    is(gospec2human('foo=s'), '--foo=s');
    is(gospec2human('--foo=s'), '--foo=s');
    is(gospec2human('foo|bar=s'), '--foo=s, --bar=s');
};

DONE_TESTING:
done_testing();
