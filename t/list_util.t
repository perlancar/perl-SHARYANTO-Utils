#!perl

use 5.010;
use strict;
use warnings;

use Test::More 0.98;

use SHARYANTO::List::Util qw(
                                uniq
                                find_missing_nums_in_seq
                                find_missing_strs_in_seq
                        );

subtest "uniq" => sub {
    is_deeply([uniq(1, 2, 4, 4, 4, 2, 4)], [1, 2, 4, 2, 4]);
};

subtest find_missing_nums_in_seq => sub {
    is_deeply([find_missing_nums_in_seq(1, 1, 3, 4, 6, 8, 7)], [2, 5]);
};

subtest find_missing_strs_in_seq => sub {
    is_deeply([find_missing_strs_in_seq("a", "c", "e")], ["b", "d"]);
};

DONE_TESTING:
done_testing;
