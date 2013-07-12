#!perl

use 5.010;
use strict;
use warnings;

use Test::More 0.98;

use SHARYANTO::Data::Util qw(
                                has_circular_ref
                        );

subtest has_circular_ref => sub {
    ok(!has_circular_ref(undef), "undef");
    ok(!has_circular_ref("x"), "x");
    ok(!has_circular_ref([]), "[]");
    ok(!has_circular_ref([[], []]), "[[], []]");

    my $a;
    $a = [1]; push @$a, $a;
    ok( has_circular_ref($a), "circ 1");
    my $b = [];
    $a = [$b, $b];
    ok( has_circular_ref($a), "circ 2");
};

DONE_TESTING:
done_testing;
