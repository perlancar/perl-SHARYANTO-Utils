package SHARYANTO::String::Util;

use 5.010;
use strict;
use warnings;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(trim_blank_lines);

sub trim_blank_lines {
    local $_ = shift;
    return $_ unless defined;
    s/\A(?:\n\s*)+//;
    s/(?:\n\s*){2,}\z/\n/;
    $_;
}

1;
# ABSTRACT: String utilities

=head1 FUNCTIONS

=head2 trim_blank_lines($str) => STR

Trim blank lines at the beginning and the end. Won't trim blank lines in the
middle. Blank lines include lines with only whitespaces in them.

=cut
