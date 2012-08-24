#!perl -T

use 5.010;
use strict;
use warnings;

use File::chdir;
use File::Spec;
use Test::More 0.96;

plan skip_all => "symlink() not available"
    unless eval { symlink "", ""; 1 };

use File::Temp qw(tempfile tempdir);
use SHARYANTO::File::Util qw(file_exists l_abs_path);

subtest file_exists => sub {
    my ($fh1, $target)  = tempfile();
    my ($fh2, $symlink) = tempfile();

    ok(file_exists($target), "existing file");

    unlink($symlink);
    symlink($target, $symlink);
    ok(file_exists($symlink), "symlink to existing file");

    unlink($target);
    ok(!file_exists($target), "non-existing file");
    ok(file_exists($symlink), "symlink to non-existing file");

    unlink($symlink);
};

subtest l_abs_path => sub {
    my $dir = tempdir(CLEANUP=>1);
    local $CWD = $dir;

    my $tmp = File::Spec->tmpdir;
    symlink $tmp, "s";
    is(l_abs_path("s"), "$dir/s", "s");
    is(l_abs_path("s/foo"), "$tmp/foo", "s/foo");
};

DONE_TESTING:
done_testing();
