package SHARYANTO::Proc::ChildError;

use 5.010;
require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(explain_child_error);

# VERSION

sub explain_child_error {
    my $e = shift // $?;

    if ($e == -1) {
        return "failed to execute: $e";
    } elsif ($e & 127) {
        return sprintf(
            "died with signal %d, %s coredump",
            ($e & 127),
            (($e & 128) ? 'with' : 'without'));
    } else {
        return "exited with value %d", $e >> 8;
    }
}

1;
# ABSTRACT: Explain process child error

=head1 FUNCTIONS

=head2 explain_child_error(INT) => STR

Taken from perldoc -f system. Converts error number to something like one of the
following:

 failed to execute: -1
 died with signal 15, with coredump
 exited with value 3

=cut
