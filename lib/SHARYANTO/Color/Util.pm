package SHARYANTO::Color::Util;

use 5.010;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       mix_2_rgb_colors
                       rand_rgb_color
                       rgb2grayscale
               );

# VERSION

sub mix_2_rgb_colors {
    my ($rgb1, $rgb2, $pct) = @_;

    $pct //= 0.5;

    $rgb1 =~ /^#?([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})$/o
        or die "Invalid rgb1 color, must be in 'ffffff' form";
    my $r1 = hex($1);
    my $g1 = hex($2);
    my $b1 = hex($3);
    $rgb2 =~ /^#?([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})$/o
        or die "Invalid rgb2 color, must be in 'ffffff' form";
    my $r2 = hex($1);
    my $g2 = hex($2);
    my $b2 = hex($3);

    return sprintf("%02x%02x%02x",
                   $r1 + $pct*($r2-$r1),
                   $g1 + $pct*($g2-$g1),
                   $b1 + $pct*($b2-$b1),
               );
}

sub rand_rgb_color {
    my ($rgb1, $rgb2) = @_;

    $rgb1 //= '000000';
    $rgb1 =~ /^#?([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})$/o
        or die "Invalid rgb1 color, must be in 'ffffff' form";
    my $r1 = hex($1);
    my $g1 = hex($2);
    my $b1 = hex($3);
    $rgb2 //= 'ffffff';
    $rgb2 =~ /^#?([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})$/o
        or die "Invalid rgb2 color, must be in 'ffffff' form";
    my $r2 = hex($1);
    my $g2 = hex($2);
    my $b2 = hex($3);

    return sprintf("%02x%02x%02x",
                   $r1 + rand()*($r2-$r1+1),
                   $g1 + rand()*($g2-$g1+1),
                   $b1 + rand()*($b2-$b1+1),
               );
}

sub rgb2grayscale {
    my ($rgb) = @_;

    $rgb =~ /^#?([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})$/o
        or die "Invalid rgb color, must be in 'ffffff' form";
    my $r = hex($1);
    my $g = hex($2);
    my $b = hex($3);

    # basically we just average the R, G, B
    my $avg = int(($r + $g + $b)/3);
    return sprintf("%02x%02x%02x", $avg, $avg, $avg);
}

1;
# ABSTRACT: Color-related utilities

=head1 SYNOPSIS

 use SHARYANTO::Color::Util qw(
     mix_2_rgb_colors
     rand_rgb_color
     rgb2grayscale
 );

 say mix_2_rgb_colors('#ff0000', '#ffffff');     # pink (red + white)
 say mix_2_rgb_colors('ff0000', 'ffffff', 0.75); # pink with a whiter shade

 say rand_rgb_color();
 say rand_rgb_color('000000', '333333');         # limit range

 say rgb2grayscale('ff3322');                    # =>


=head1 DESCRIPTION


=head1 FUNCTIONS

None are exported by default, but they are exportable.

=head2 mix_2_rgb_colors($rgb1, $rgb2, $pct) => STR

Mix 2 RGB colors. C<$pct> is a number between 0 and 1, by default 0.5 (halfway),
the closer to 1 the closer the resulting color to C<$rgb2>.

=head2 rand_rgb_color([$low_limit[, $high_limit]]) => STR

Generate a random RGB color. You can specify the limit. Otherwise, they default
to the full range (000000 to ffffff).

=head2 rgb2grayscale($rgb) => RGB

Convert C<$rgb> to grayscale RGB value.


=head1 TODO

mix_rgb_colors() to mix several RGB colors. Args might be $rgb1, $rgb2, ... or
$rgb1, $part1, $rgb2, $part2, ... (e.g. 'ffffff', 1, 'ff0000', 1, '00ff00', 2).

=cut
