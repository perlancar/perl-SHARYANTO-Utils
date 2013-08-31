package SHARYANTO::YAML::Any_SyckOnly;
package SHARYANTO::YAML::Any;

# NOTE: temporary namespace, will eventually be refactored, tidied up, and sent
# to a more proper namespace.

use 5.010;
use strict;
use Exporter ();

our @ISA       = qw(Exporter);
our @EXPORT    = qw(Dump Load);
our @EXPORT_OK = qw(DumpFile LoadFile);

our $VERSION   = '0.72';

use YAML::Syck;
$YAML::Syck::ImplicitTyping = 1;

1;
# ABSTRACT: Pick a YAML implementation and use it
__END__

=for Pod::Coverage .*
