#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More 0.96;

plan skip_all => "symlink() not available"
    unless eval { symlink "", ""; 1 };

use File::Temp qw(tempfile);
use SHARYANTO::File::Util qw(file_exists);

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

DONE_TESTING:
done_testing();
