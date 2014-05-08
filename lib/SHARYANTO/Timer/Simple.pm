package SHARYANTO::Timer::Simple;

use 5.010001;
use strict;
use warnings;
no strict 'refs';
no warnings 'once';

use Time::HiRes;
use Time::Stopwatch;

# VERSION
# DATE

tie our($TIMER), 'Time::Stopwatch';

sub timer(&) {
    local $TIMER = 0;
    shift->();
    say $TIMER;
}

sub import {
    my $class = shift;
    my $caller = caller;

    # this does not work, caller's $TIMER is not tied
    #${"$caller\::TIMER"} = $TIMER;
    tie ${"$caller\::TIMER"}, 'Time::Stopwatch';

    *{"$caller\::timer"} = \&timer;
}

1;
# ABSTRACT: Simple timer

=head1 SYNOPSIS

 use SHARYANTO::Timer::Simple; # exports timer() and $TIMER

 $TIMER = 0; do_something(); say $TIMER;
 timer { do_something_else() };


=head1 DESCRIPTION

This module exports C<timer> and C<$TIMER>. The former can be used to measure
the running time of a block of code, and the later is a shortcut/default for
L<Time::Stopwatch>.


=head1 EXPORTS

=head2 $TIMER


=head1 FUNCTIONS

=head2 timer CODE

Execute CODE and print the number of seconds passed.


=head1 SEE ALSO

L<Benchmark>, L<Bench>

L<Time::Stopwatch>
