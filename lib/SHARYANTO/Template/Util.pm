package SHARYANTO::Template::Util;

use 5.010;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(process_tt_recursive);

use File::Find;
use File::Slurp;
use Template::Tiny;

# VERSION

# recursively find *.tt and process them. can optionally delete the *.tt files
# after processing.
sub process_tt_recursive {
    my ($dir, $vars, $opts) = @_;
    $opts //= {};
    my $tt = Template::Tiny->new;
    find sub {
        return unless -f;
        return unless /\.tt$/;
        my $newname = $_; $newname =~ s/\.tt$//;
        my $input = read_file($_);
        my $output;
        #$log->debug("Processing template $File::Find::dir/$_ -> $newname ...");
        $tt->process(\$input, $vars, \$output);
        write_file($newname, $output);
        #$log->debug("Removing $File::Find::dir/$_ ...");
        if ($opts->{delete}) { unlink($_) }
    }, $dir;
}

1;
# ABSTRACT: Recursively process .tt files

=head1 FUNCTIONS

=head2 process_tt_recursive($dir, $vars, $opts)


=head1 SEE ALSO

L<SHARYANTO>

=cut
