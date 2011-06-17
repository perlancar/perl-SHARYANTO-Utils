package SHARYANTO::Proc::ChildError;
# ABSTRACT: Explain process child error

use 5.010;
require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(explain_child_error);

# taken from perldoc -f system

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
