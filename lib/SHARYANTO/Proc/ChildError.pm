package SHARYANTO::Proc::ChildError;

use 5.010;
require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(explain_child_error);

# VERSION

sub explain_child_error {
    my ($num, $str);
    if (defined $_[0]) {
        $num = $_[0];
    } else {
        $num = $?;
        $str = $!;
    }

    if ($num == -1) {
        return "failed to execute: ".($str ? "$str ":"")."($num)";
    } elsif ($num & 127) {
        return sprintf(
            "died with signal %d, %s coredump",
            ($num & 127),
            (($num & 128) ? 'with' : 'without'));
    } else {
        return sprintf("exited with code %d", $num >> 8);
    }
}

1;
# ABSTRACT: Explain process child error

=head1 FUNCTIONS

=head2 explain_child_error(INT) => STR

Taken from perldoc -f system. Converts error number to something like one of the
following:

 failed to execute: No such file or directory (-1)
 died with signal 15, with coredump
 exited with value 3

=cut
