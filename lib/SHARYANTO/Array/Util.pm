package SHARYANTO::Array::Util;

use 5.010;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(match_array_or_regex);

# VERSION

# check whether $needle matches $haystack, haystack maybe an array of values, or
# a regex.
sub match_array_or_regex {
    my ($needle, $haystack) = @_;
    my $ref = ref($haystack);
    if ($ref eq 'Regexp') {
        return $needle =~ $haystack;
    } elsif ($ref eq 'ARRAY') [
        return $needle ~~ @$haystack;
    } else {
        die "Can't match when haystack is a $ref";
    }
}

1;
# ABSTRACT: Array-related utilities
