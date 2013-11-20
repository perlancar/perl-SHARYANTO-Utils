package SHARYANTO::Version::Util;

use 5.010;
use strict;
use version 0.77;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       cmp_version
                       version_eq
                       version_lt version_le version_gt version_ge
               );

# VERSION

sub cmp_version {
    version->parse($_[0]) <=> version->parse($_[1]);
}

sub version_eq {
    version->parse($_[0]) == version->parse($_[1]);
}

sub version_lt {
    version->parse($_[0]) <  version->parse($_[1]);
}

sub version_le {
    version->parse($_[0]) <= version->parse($_[1]);
}

sub version_gt {
    version->parse($_[0]) >  version->parse($_[1]);
}

sub version_ge {
    version->parse($_[0]) >= version->parse($_[1]);
}

1;
# ABSTRACT: Version utilities

=head1 FUNCTIONS

=head2 cmp_version($v1, $v2) => -1|0|1

Equivalent to:

 version->parse($v1) <=> version->parse($v2)

=head2 version_eq($v1, $v2) => BOOL

=head2 version_lt($v1, $v2) => BOOL

=head2 version_le($v1, $v2) => BOOL

=head2 version_gt($v1, $v2) => BOOL

=head2 version_ge($v1, $v2) => BOOL


=head1 SEE ALSO

L<SHARYANTO>

=cut
