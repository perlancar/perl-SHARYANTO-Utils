package SHARYANTO::File::Util;

use 5.010;
use strict;
use warnings;

use Cwd ();

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(file_exists l_abs_path dir_empty);

# VERSION

our %SPEC;

sub file_exists {
    my $path = shift;

    !(-l $path) && (-e _) || (-l _);
}

sub l_abs_path {
    my $path = shift;
    return Cwd::abs_path($path) unless (-l $path);

    $path =~ s!/\z!!;
    my ($parent, $leaf);
    if ($path =~ m!(.+)/(.+)!s) {
        $parent = Cwd::abs_path($1);
        return undef unless defined($path);
        $leaf   = $2;
    } else {
        $parent = Cwd::getcwd();
        $leaf   = $path;
    }
    "$parent/$leaf";
}

sub dir_empty {
    my ($dir) = @_;
    return undef unless (-d $dir);
    return undef unless opendir my($dh), $dir;
    my @d = grep {$_ ne '.' && $_ ne '..'} readdir($dh);
    my $res = !@d;
    #$log->tracef("dir_is_empty(%s)? %d", $dir, $res);
    $res;
}

1;
# ABSTRACT: File-related utilities

=head1 SYNOPSIS

 use SHARYANTO::File::Util qw(file_exists l_abs_path dir_empty);

 print "file exists" if file_exists("/path/to/file/or/dir");
 print "absolute path = ", l_abs_path("foo");
 print "dir exists and is empty" if dir_empty("/path/to/dir");

=head1 DESCRIPTION


=head1 FUNCTIONS

None are exported by default, but they are exportable.

=head2 file_exists($path) => BOOL

This routine is just like the B<-e> test, except that it assume symlinks with
non-existent target as existing. If C<sym> is a symlink to a non-existing
target:

 -e "sym"             # false, Perl performs stat() which follows symlink

but:

 -l "sym"             # true, Perl performs lstat()
 -e _                 # false

This function performs the following test:

 !(-l "sym") && (-e _) || (-l _)

=head2 l_abs_path($path) => STR

Just like Cwd::abs_path(), except that it wil follow not follow symlink if $path
is symlink (but it will follow symlinks for the parent paths).

Example:

 use Cwd qw(getcwd abs_path);

 say getcwd();              # /home/steven
 # s is a symlink to /tmp/foo
 say abs_path("s");         # /tmp/foo
 say l_abs_path("s");       # /home/steven/s
 # s2 is a symlink to /tmp
 say abs_path("s2/foo");    # /tmp/foo
 say l_abs_path("s2/foo");  # /tmp/foo

Mnemonic: l_abs_path -> abs_path is analogous to lstat -> stat.

Note: currently uses hardcoded C</> as path separator.

=head2 dir_empty($dir) => BOOL

Will return true if C<$dir> exists and is empty.

=cut
