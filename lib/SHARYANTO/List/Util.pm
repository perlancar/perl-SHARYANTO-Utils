package SHARYANTO::List::Util;

use 5.010;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       uniq
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

1;
# ABSTRACT: List utilities

=head1 SYNOPSIS

 use SHARYANTO::List::Util qw(uniq);

 my @res = uniq(1, 4, 4, 3, 1, 1, 2); # 1, 4, 3, 1, 2


=head1 DESCRIPTION


=head1 FUNCTIONS

=head2 uniq(@list) => LIST

Remove I<adjacent> duplicates from list, i.e. behave more like Unix utility's
B<uniq> instead of L<List::MoreUtils>'s C<uniq> function.


=head1 SEE ALSO

L<SHARYANTO>
