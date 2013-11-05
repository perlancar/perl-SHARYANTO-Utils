package SHARYANTO::Log::Util;

use 5.010;
use strict;
use warnings;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(@log_levels $log_levels_re);

# VERSION

our @log_levels = (qw/trace debug info warn error fatal/);
our $log_levels_re = join("|", @log_levels);
$log_levels_re = qr/\A(?:$log_levels_re)\z/;

1;
# ABSTRACT: Log-related utilities

=head1 SYNOPSIS

 use SHARYANTO::Log::Util qw(@log_levels $log_levels_re);


=head1 DESCRIPTION


=head1 VARIABLES

None are exported by default, but they are exportable.

=head2 @log_levels

Contains log levels, from lowest to highest. Currently these are:

 (qw/trace debug info warn error fatal/)

They can be used as method names to L<Log::Any> ($log->debug, $log->warn, etc).

=head2 $log_levels_re

Contains regular expression to check valid log levels.


=head1 SEE ALSO

L<SHARYANTO>

L<Log::Any>

=cut
