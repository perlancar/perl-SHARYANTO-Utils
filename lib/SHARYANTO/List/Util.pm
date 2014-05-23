package SHARYANTO::List::Util;

use 5.010;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       uniq
                       find_missing_nums_in_seq
                       find_missing_strs_in_seq
               );

# VERSION
# DATE

sub uniq {
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

1;
# ABSTRACT: List utilities

=head1 FUNCTIONS

Not exported by default but exportable.

=head2 uniq(@list) => LIST

Remove I<adjacent> duplicates from list, i.e. behave more like Unix utility's
B<uniq> instead of L<List::MoreUtils>'s C<uniq> function, e.g.

 my @res = uniq(1, 4, 4, 3, 1, 1, 2); # 1, 4, 3, 1, 2

=head2 find_missing_nums_in_seq(LIST) => LIST

Given a list of integers, return number(s) missing in the sequence, e.g.:

 find_missing_nums_in_seq(1, 2, 3, 4, 7, 8); # (5, 6)

=head2 find_missing_strs_in_seq(LIST) => LIST

Like C<find_missing_nums_in_seq>, but for strings/letters "a".."z".

 find_missing_strs_in_seq("a", "e", "b"); # ("c", "d")
 find_missing_strs_in_seq("aa".."zu", "zz"); # ("zv", "zw", "zx", "zy")


=head1 SEE ALSO

L<SHARYANTO>
