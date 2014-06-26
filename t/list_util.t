#!perl

use 5.010;
use strict;
use warnings;

use Test::More 0.98;

use SHARYANTO::List::Util qw(
                                uniq_adj
                                uniq_adj_ci
                                uniq_ci
                                find_missing_nums_in_seq
                                find_missing_strs_in_seq
                        );

subtest "uniq_adj" => sub {
    is_deeply([uniq_adj(1, 2, 4, 4, 4, 2, 4)], [1, 2, 4, 2, 4]);
};

subtest "uniq_adj_ci" => sub {
    is_deeply([uniq_adj   (qw/a b B a b C c/)], [qw/a b B a b C c/]);
    is_deeply([uniq_adj_ci(qw/a b B a b C c/)], [qw/a b a b C/]);
};

subtest "uniq_ci" => sub {
    #is_deeply([uniq   (qw/a b B a b C c/)], [qw/a b B C c/]);
    is_deeply([uniq_ci(qw/a b B a b C c/)], [qw/a b C/]);
};

subtest find_missing_nums_in_seq => sub {
    is_deeply([find_missing_nums_in_seq(1, 1, 3, 4, 6, 8, 7)], [2, 5]);
};

subtest find_missing_strs_in_seq => sub {
    is_deeply([find_missing_strs_in_seq("a", "c", "e")], ["b", "d"]);
};

DONE_TESTING:
done_testing;
