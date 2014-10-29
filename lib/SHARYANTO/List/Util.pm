package SHARYANTO::List::Util;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       uniq_adj uniq_adj_ci uniq_ci
                       find_missing_nums_in_seq
                       find_missing_strs_in_seq
                       max_in_range maxstr_in_range
                       min_in_range minstr_in_range
                       pick pick_n
               );

# TODO: minmaxstr (not included in List::MoreUtils)
# TODO: minmax_in_range. minmaxstr_in_range
# TODO: *_in_xrange

sub uniq_adj {
    my @res;

    return () unless @_;
    my $last = shift;
    push @res, $last;
    for (@_) {
        next if !defined($_) && !defined($last);
        # XXX $_ becomes stringified
        next if defined($_) && defined($last) && $_ eq $last;
        push @res, $_;
        $last = $_;
    }
    @res;
}

sub uniq_adj_ci {
    my @res;

    return () unless @_;
    my $last = shift;
    push @res, $last;
    for (@_) {
        next if !defined($_) && !defined($last);
        # XXX $_ becomes stringified
        next if defined($_) && defined($last) && lc($_) eq lc($last);
        push @res, $_;
        $last = $_;
    }
    @res;
}

sub uniq_ci {
    my @res;

    my %mem;
    for (@_) {
        push @res, $_ unless $mem{lc $_}++;
    }
    @res;
}

sub find_missing_nums_in_seq {
    require List::Util;

    my @res;
    my $min = List::Util::min(@_);
    my $max = List::Util::max(@_);

    my %h = map { $_=>1 } @_;
    for ($min..$max) {
        push @res, $_ unless $h{$_};
    }
    wantarray ? @res : \@res;
}

sub find_missing_strs_in_seq {
    require List::Util;

    my @res;
    my $min = List::Util::minstr(@_);
    my $max = List::Util::maxstr(@_);

    my %h = map { $_=>1 } @_;
    for ($min..$max) {
        push @res, $_ unless $h{$_};
    }
    wantarray ? @res : \@res;
}

sub max_in_range {
    my $lower = shift;
    my $upper = shift;

    my $ans;
    for (@_) {
        $ans = $_ if defined($_) &&
            (!defined($ans)   || $ans < $_) &&
            (!defined($lower) || $lower <= $_) &&
            (!defined($upper) || $upper >= $_);
    }
    $ans;
}

sub maxstr_in_range {
    my $lower = shift;
    my $upper = shift;

    my $ans;
    for (@_) {
        $ans = $_ if defined($_) &&
            (!defined($ans)   || $ans lt $_) &&
            (!defined($lower) || $lower le $_) &&
            (!defined($upper) || $upper ge $_);
    }
    $ans;
}

sub min_in_range {
    my $lower = shift;
    my $upper = shift;

    my $ans;
    for (@_) {
        $ans = $_ if defined($_) &&
            (!defined($ans)   || $ans > $_) &&
            (!defined($lower) || $lower <= $_) &&
            (!defined($upper) || $upper >= $_);
    }
    $ans;
}

sub minstr_in_range {
    my $lower = shift;
    my $upper = shift;

    my $ans;
    for (@_) {
        $ans = $_ if defined($_) &&
            (!defined($ans)   || $ans gt $_) &&
            (!defined($lower) || $lower le $_) &&
            (!defined($upper) || $upper ge $_);
    }
    $ans;
}

sub pick {
    $_[@_ * rand];
}

sub pick_n {
    my $n = shift;
    my @res;
    while (@_ && @res < $n) {
        push @res, splice(@_, @_*rand(), 1);
    }
    @res;
}

1;
# ABSTRACT: List utilities

=head1 FUNCTIONS

Not exported by default but exportable.

=head2 uniq_adj(@list) => LIST

Remove I<adjacent> duplicates from list, i.e. behave more like Unix utility's
B<uniq> instead of L<List::MoreUtils>'s C<uniq> function, e.g.

 my @res = uniq(1, 4, 4, 3, 1, 1, 2); # 1, 4, 3, 1, 2

=head2 uniq_adj_ci(@list) => LIST

Like C<uniq_adj> except case-insensitive.

=head2 uniq_ci(@list) => LIST

Like C<List::MoreUtils>' C<uniq> except case-insensitive.

=head2 find_missing_nums_in_seq(LIST) => LIST

Given a list of integers, return number(s) missing in the sequence, e.g.:

 find_missing_nums_in_seq(1, 2, 3, 4, 7, 8); # (5, 6)

=head2 find_missing_strs_in_seq(LIST) => LIST

Like C<find_missing_nums_in_seq>, but for strings/letters "a".."z".

 find_missing_strs_in_seq("a", "e", "b"); # ("c", "d")
 find_missing_strs_in_seq("aa".."zu", "zz"); # ("zv", "zw", "zx", "zy")

=head2 min_in_range($lower, $upper, @list) => $num

Find lowest number C<$num> in C<@list> which still satisfies C<< $lower <= $num
<= $upper >>. C<$lower> and/or C<$upper> can be undef to express no limit.

=head2 minstr_in_range($lower, $upper, @list) => $str

Find lowest string C<$str> in C<@list> which still satisfies C<< $lower le $x
le $upper >>. C<$lower> and/or C<$upper> can be undef to express no limit.

=head2 max_in_range($lower, $upper, @list) => $num

Find highest number C<$num> in C<@list> which still satisfies C<< $lower <= $num
<= $upper >>. C<$lower> and/or C<$upper> can be undef to express no limit.

=head2 maxstr_in_range($lower, $upper, @list) => $str

Find highest string C<$str> in C<@list> which still satisfies C<< $lower le $x
le $upper >>. C<$lower> and/or C<$upper> can be undef to express no limit.

=head2 pick(@list) => $item

Randomly pick an item from list. It is actually simply done as:

 $_[@_ * rand]

=head2 pick_n($n, @list) => @picked

Randomly pick C<n> (distinct) items from list.


=head1 SEE ALSO

L<SHARYANTO>
