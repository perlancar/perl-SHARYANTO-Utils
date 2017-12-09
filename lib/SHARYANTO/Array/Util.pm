package SHARYANTO::Array::Util;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;
use experimental 'smartmatch';

use Perinci::Sub::Util qw(gen_modified_sub);

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       split_array
                       replace_array_content
               );

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Array-related utilities',
};

sub split_array {
    no strict 'refs';

    my ($pat, $ary, $limit) = @_;

    die "BUG: Second argument must be an array" unless ref($ary) eq 'ARRAY';
    $pat = qr/\A\Q$pat\E\z/ unless ref($pat) eq 'Regexp';

    my @res;
    my $num_elems = 0;
    my $i = 0;
  ELEM:
    while ($i < @$ary) {
        push @res, [];
      COLLECT:
        while (1) {
            if ($ary->[$i] =~ $pat) {
                push @res, [map { ${"$_"} } 1..@+-1] if @+ > 1;
                last COLLECT;
            }
            push @{ $res[-1] }, $ary->[$i];
            last ELEM unless ++$i < @$ary;
        }
        $num_elems++;
      LIMIT:
        if (defined($limit) && $limit > 0 && $num_elems >= $limit) {
            push @{ $res[-1] }, $ary->[$_] for $i..(@$ary-1);
            last ELEM;
        }
        $i++;
    }

    return @res;
}

sub replace_array_content {
    my $aryref = shift;
    @$aryref = @_;
    $aryref;
}

1;
# ABSTRACT:

=head1 SYNOPSIS

 use SHARYANTO::Array::Util qw(split_array);

 my @res = split_array('--', [qw/--opt1 --opt2 -- foo bar -- --val/]);
 # -> ([qw/--opt1 --opt2/],  [qw/foo bar/],  [qw/--val/])

 my @res = split_array(qr/--/, [qw/--opt1 --opt2 -- foo bar -- --val/], 2);
 # -> ([qw/--opt1 --opt2/],  [qw/foo bar -- --val/])

 my @res = split_array(qr/(--)/, [qw/--opt1 --opt2 -- foo bar -- --val/], 2);
 # -> ([qw/--opt1 --opt2/],  [qw/--/],  [qw/foo bar -- --val/])

 my @res = split_array(qr/(-)(-)/, [qw/--opt1 --opt2 -- foo bar -- --val/], 2);
 # -> ([qw/--opt1 --opt2/],  [qw/- -/],  [qw/foo bar -- --val/])


=head1 DESCRIPTION


=head1 append:FUNCTIONS

=head2 split_array($str_or_re, \@array[, $limit]) => LIST

Like the C<split()> builtin Perl function, but applies on an array instead of a
scalar. It loosely follows the C<split()> semantic, with some exceptions.

=head2 replace_array_content($aryref, @elems) => $aryref

Replace elements in <$aryref> with @elems. Return C<$aryref>. Do not create a
new arrayref object (i.e. it is different from: C<< $aryref = ["new", "content"]
>>).

Do not use this function. In Perl you can just use: C<< splice(@$aryref, 0,
length(@$aryref), @elems) >> or even easier: C<< @$aryref = @elems >>. I put the
function here for reminder.


=head1 SEE ALSO

L<SHARYANTO>
