package SHARYANTO::File::Flock;

use 5.010;
use strict;
use warnings;

use Fcntl ':flock';

# VERSION

sub lock {
    my ($class, $path, $opts) = @_;
    $opts //= {};
    my %h;

    defined($path) or die "Please specify path";
    $h{path}    = $path;
    $h{unlink}  = $opts->{unlink}  //  0;
    $h{retries} = $opts->{retries} // 60;

    my $self = bless \%h, $class;
    $self->_lock;
    $self;
}

# return 1 if we lock, 0 if already locked. die on failure.
sub _lock {
    my $self = shift;

    # already locked
    return 0 if $self->{_fh};

    my $path = $self->{path};
    my $exists;
    my $tries = 0;
  TRY:
    while (1) {
        $tries++;

        # 1
        open $self->{_fh}, ">>", $path
            or die "Can't open lock file '$path': $!";

        # 2
        my @st1 = stat($self->{_fh}); # stat before lock

        # 3
        if (flock($self->{_fh}, LOCK_EX | LOCK_NB)) {
            # if file is unlinked by another process between 1 & 2, @st1 will be
            # empty and we check here.
            redo TRY unless @st1;

            # 4
            my @st2 = stat($path); # stat after lock

            # if file is unlinked between 3 & 4, @st2 will be empty and we check
            # here.
            redo TRY unless @st2;

            # if file is recreated between 2 & 4, @st1 and @st2 will differ in
            # dev/inode, we check here.
            redo TRY if $st1[0] != $st2[0] || $st1[1] != $st2[1];

            # everything seems okay
            last;
        } else {
            $tries <= $self->{retries}
                or die "Can't acquire lock on '$path' after $tries seconds";
            sleep 1;
        }
    }
    1;
}

# return 1 if we unlock, 0 if already unlocked. die on failure.
sub _unlock {
    my ($self) = @_;

    my $path = $self->{path};

    # don't unlock if we are not holding the lock
    return 0 unless $self->{_fh};

    unlink $self->{path} if $self->{unlink};

    {
        # to shut up warning about flock on closed filehandle (XXX but why
        # closed if we are holding the lock?)
        no warnings;

        flock $self->{_fh}, LOCK_UN;
    }
    close delete($self->{_fh});
    1;
}

sub release {
    my $self = shift;
    $self->_unlock;
}

sub unlock {
    my $self = shift;
    $self->_unlock;
}

sub DESTROY {
    my $self = shift;
    $self->_unlock;
}

1;
#ABSTRACT: Yet another flock module

=for Pod::Coverage ^(DESTROY)$

=head1 SYNOPSIS

 use SHARYANTO::File::Flock;

 # try to acquire exclusive lock. if fail to acquire lock within 60s, die.
 my $lock = SHARYANTO::File::Flock->lock($file);

 # automatically release the lock if object is DESTROY-ed.
 undef $lock;

 # set number of retries and unlink lock file during DESTROY.
 $lock = SHARYANTO::File::Flock->lock($path, {retries=>30, unlink=>1});

 # explicitly unlock
 $lock->release;


=head1 DESCRIPTION

This is yet another flock module. The name (under SHARYANTO:: namespace) is
probably temporary. The module is quite tiny like L<File::Flock::Tiny>, but
different in the following ways:

=over 4

=item * Can be instructed to unlink the lock file during DESTROY

=item * Does retries (by default for 60s) when trying to acquire lock

I prefer this approach to blocking/waiting indefinitely.

=back


=head1 METHODS

=head2 $lock = SHARYANTO::File::Flock->lock($path, \%opts)

Acquire an exclusive lock on C<$path>. C<$path> will be created if not already
exists. If $path is already locked by another process, will retry (by default
for 60 seconds). Will die if failed to acquire lock.

Will automatically unlock if C<$lock> goes out of scope.

Available options:

=over

=item * unlink => BOOL (default: 0)

If set to true, will unlink C<$path> when unlinking. This is convenient to clean
lock files.

=item * retries => INT (default: 60)

Number of retries (equals number of seconds, since retry is done every second).

=back

=head2 $lock->unlock

Unlock.

=head2 $lock->release

Synonym for unlock().

=head2 DESTROY

When C<unlink> option is set to true, will unlink lock file during object
destruction. Will only do so if current process holds the lock.


=head1 CAVEATS

Not yet tested on Windows. Some filesystems do not support inode?


=head1 SEE ALSO

L<File::Flock>

L<File::Flock::Tiny>

flock() Perl function.

https://github.com/trinitum/perl-File-Flock-Tiny/issues/1

=cut
