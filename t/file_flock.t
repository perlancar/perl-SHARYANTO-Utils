#!perl

use 5.010;
use strict;
use warnings;

use Cwd qw(abs_path);
use File::chdir;
use File::Slurp;
use File::Spec;
use Test::More 0.96;

use File::Temp qw(tempdir);
use SHARYANTO::File::Flock;

my $dir = abs_path(tempdir(CLEANUP=>1));
$CWD = $dir;

subtest "create" => sub {
    ok(!(-f "f1"), "f1 doesn't exist");
    my $lock = SHARYANTO::File::Flock->lock("f1");
    ok((-f "f1"), "f1 exists");
    $lock->unlock;
    ok((-f "f1"), "f1 still exists after unlock");
    undef $lock;
    ok((-f "f1"), "f1 still exists after DESTROY");
    unlink "f1";
};

subtest "already exists" => sub {
    write_file("f1", "");
    ok((-f "f1"), "f1 exists");
    my $lock = SHARYANTO::File::Flock->lock("f1");
    ok((-f "f1"), "f1 exists");
    $lock->unlock;
    ok((-f "f1"), "f1 still exists after unlock");
    undef $lock;
    ok((-f "f1"), "f1 still exists after DESTROY");
    unlink "f1";
};

subtest "create + opt:unlink (unlinked)" => sub {
    ok(!(-f "f1"), "f1 doesn't exist");
    my $lock = SHARYANTO::File::Flock->lock("f1", {unlink=>1});
    ok((-f "f1"), "f1 exists");
    $lock->unlock;
    ok(!(-f "f1"), "f1 doesn't exist after DESTROY");
};

subtest "create + opt:unlink (destroyed)" => sub {
    ok(!(-f "f1"), "f1 doesn't exist");
    my $lock = SHARYANTO::File::Flock->lock("f1", {unlink=>1});
    ok((-f "f1"), "f1 exists");
    undef $lock;
    ok(!(-f "f1"), "f1 doesn't exist after DESTROY");
};

DONE_TESTING:
done_testing();
if (Test::More->builder->is_passing) {
    diag "all tests successful, deleting test data dir";
    $CWD = "/";
} else {
    # don't delete test data dir if there are errors
    diag "there are failing tests, not deleting test data dir $dir";
}
