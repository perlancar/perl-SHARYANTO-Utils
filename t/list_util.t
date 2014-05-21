#!perl

use 5.010;
use strict;
use warnings;

use Test::More 0.98;

use SHARYANTO::List::Util qw(
                                uniq
                        );

subtest "uniq" => sub {
    is_deeply([uniq(1, 2, 4, 4, 4, 2, 4)], [1, 2, 4, 2, 4]);
};

DONE_TESTING:
done_testing;
