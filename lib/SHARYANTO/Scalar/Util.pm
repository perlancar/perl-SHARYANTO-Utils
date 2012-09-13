use SHARYANTO::Scalar::Util;

use 5.010;
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

use Exporter qw(import);
our @EXPORT_OK = qw(
                       looks_like_int
                       looks_like_float
                       looks_like_real
               );

# VERSION

sub looks_like_int {
    my $l = looks_like_number($_[0]);
    $l==1 || $l==2 || $l==9 || $l==10 || $l==4352;
}

sub looks_like_float {
    my $l = looks_like_number($_[0]);
    $l==4 || $l==5 || $l==6 || $l==12 || $l==13 || $l==14 ||
        $l==20 || $l==28 || $l==36 || $l==44 || $l==8704;
}

sub looks_like_real {
    my $l = looks_like_number($_[0]);
    $l==1 || $l==2 || $l==9 || $l==10 || $l==4352 ||
    $l==4 || $l==5 || $l==6 || $l==12 || $l==13 || $l==14 ||
        $l==20 || $l==28 || $l==36 || $l==44 || $l==8704;
}

1;
# ABSTRACT: Scalar utilities

=head1 SYNOPSIS

 use SHARYANTO::Scalar::Util qw(
     looks_like_int
     looks_like_float
     looks_like_real
 );

 say looks_like_int(10);              # 1, isint() also returns 1
 say looks_like_int("1".("0" x 100)); # 1, isint() returns 0 here
 say looks_like_int("123a");          # 0

 say looks_like_float(1.1);           # 1
 say looks_like_float("1e2");         # 1
 say looks_like_float("-Inf");        # 1
 say looks_like_float("");            # 0

 # either looks like int, or float
 say looks_like_real(1);              # 1
 say looks_like_real(1.1);            # 1


=head1 FUNCTIONS

=head2 looks_like_int($arg) => BOOL

Uses L<Scalar::Util>'s C<looks_like_number()> to check whether C<$arg> looks
like an integer.

=head2 looks_like_float($arg) => BOOL

Uses L<Scalar::Util>'s C<looks_like_number()> to check whether C<$arg> looks
like a floating point number.

=head2 looks_like_real($arg) => BOOL

Uses L<Scalar::Util>'s C<looks_like_number()> to check whether C<$arg> looks
like a real number (either an integer or a floating point).


=head1 SEE ALSO

L<Scalar::Util>

L<Scalar::Util::Numeric>

=cut
