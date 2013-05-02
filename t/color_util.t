#!perl

use 5.010;
use strict;
use warnings;

use SHARYANTO::Color::Util qw(
                                 mix_2_rgb_colors
                                 rand_rgb_color
                                 rgb2grayscale
                         );
use Test::More 0.98;

subtest mix_2_rgb_colors => sub {
    is(mix_2_rgb_colors('#ff8800', '#0033cc'), '7f5d66');
    is(mix_2_rgb_colors('ff8800', '0033cc', 0), 'ff8800');
    is(mix_2_rgb_colors('FF8800', '0033CC', 1), '0033cc');
    is(mix_2_rgb_colors('0033CC', 'FF8800', 0.75), 'bf7233');
    is(mix_2_rgb_colors('0033CC', 'FF8800', 0.25), '3f4899');
};

subtest rand_rgb_color => sub {
    ok "currently not tested";
};

subtest rgb2grayscale => sub {
    is(rgb2grayscale('0033CC'), '555555');
};

DONE_TESTING:
done_testing();
