package SHARYANTO::Array::Util;

use 5.010;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(match_array_or_regex match_regex_or_array);

# VERSION

our %SPEC;

$SPEC{match_array_or_regex} = {
    summary => 'Check whether an item matches array of values or regex',
    args_as => 'array',
    args => {
        needle => ["str*" => {
            arg_pos => 0,
        }],
        haystack => ["any*" => {
            of => [["array*"=>{of=>"str*"}], "str*"], # XXX 2nd should be regex*
            arg_pos => 1,
        }],
    },
};
sub match_array_or_regex {
    my ($needle, $haystack) = @_;
    my $ref = ref($haystack);
    if ($ref eq 'Regexp') {
        return $needle =~ $haystack;
    } elsif ($ref eq 'ARRAY') {
        return $needle ~~ @$haystack;
    } else {
        die "Can't match when haystack is a $ref";
    }
}

*match_regex_or_array = \&match_array_or_regex;
$SPEC{match_regex_or_array} = $SPEC{match_array_or_regex};

1;
# ABSTRACT: Array-related utilities

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 FUNCTIONS

None are exported by default, but they are exportable.
