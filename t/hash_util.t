#!perl -T

use 5.010;
use strict;
use warnings;

use Test::Exception;
use Test::More 0.96;

use SHARYANTO::Hash::Util qw(rename_key);

subtest "rename_key" => sub {
    my %h = (a=>1, b=>2);
    dies_ok { rename_key(\%h, "c", "d") }, "old key doesn't exist -> die";
    dies_ok { rename_key(\%h, "a", "b") }, "new key exists -> die";
    rename_key(\%h, "a", "a2");
    is_deeply(\%h, {a2=>1, b=>2}, "success 1");
};

DONE_TESTING:
done_testing();
