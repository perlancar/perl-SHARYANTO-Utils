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

    ${"$caller\::TIMER"} = $TIMER;
    *{"$caller\::timer"} = \&timer;
}

1;
# ABSTRACT: Simple timer

=head1 SYNOPSIS

 use SHARYANTO::Timer::Simple; # exports timer() and $TIMER

 $TIMER = 0; do_something(); say $TIMER;
 timer { do_something_else() };


=head1 SEE ALSO

L<Benchmark>, L<Bench>

L<Time::Stopwatch>
