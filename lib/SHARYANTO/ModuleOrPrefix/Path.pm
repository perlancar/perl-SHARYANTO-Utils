package SHARYANTO::ModuleOrPrefix::Path;

use 5.010;
use strict;
use warnings;
use File::Basename 'dirname';

# VERSION

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(module_or_prefix_path);

my $SEPARATOR;

BEGIN {
    if ($^O =~ /^(dos|os2)/i) {
        $SEPARATOR = '\\';
    } elsif ($^O =~ /^MacOS/i) {
        $SEPARATOR = ':';
    } else {
        $SEPARATOR = '/';
    }
}

sub module_or_prefix_path {
    my $module = shift;
    my $relpath;
    my $fullpath;

    ($relpath = $module) =~ s/::/$SEPARATOR/g;
    $relpath .= '.pm' unless $relpath =~ m!\.pm$!;

    my $relpathp = $relpath;
    $relpathp =~ s/\.pm$//;

    for my $which ('f', 'd') {
        foreach my $dir (@INC) {
            # see 'perldoc -f require' on why you might find
            # a reference in @INC
            next if ref($dir);

            # If $dir is a symlink, then we resolve it.
            # Returing a full path containing a symlinked directory can
            # cause problems: https://github.com/neilbowers/Module-Path/issues/4
            if (-l $dir) {
                my $linkdir = readlink($dir);
                $dir = index($linkdir, $SEPARATOR) == 0
                    ? $linkdir
                        : dirname($dir) . $SEPARATOR . $linkdir;
            }

            if ($which eq 'f') {
                $fullpath = $dir . $SEPARATOR . $relpath;
                return $fullpath if -f $fullpath;
            } else {
                $fullpath = $dir . $SEPARATOR . $relpathp;
                return $fullpath . $SEPARATOR if -d $fullpath;
            }
        }
    }

    return undef;
}

1;
# ABSTRACT: Get the full path to a locally installed module or prefix

=head1 SYNOPSIS

 use SHARYANTO::ModuleOrPrefix::Path qw(module_or_prefix_path);

 say module_or_prefix_path('Test::More');  # "/path/to/Test/More.pm"
 say module_or_prefix_path('Test');        # "/path/to/Test.pm"
 say module_or_prefix_path('File::Slurp'); # "/path/to/File/Slurp.pm"
 say module_or_prefix_path('File');        # "/path/to/File/"
 say module_or_prefix_path('Foo');         # undef


=head1 DESCRIPTION

The code is based on Neil Bower's L<Module::Path>.


=head1 FUNCTIONS

=head2 module_or_prefix_path(MODULE) => STR


=head1 SEE ALSO

L<Module::Path>

=cut
