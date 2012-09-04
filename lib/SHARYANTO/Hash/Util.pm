package SHARYANTO::Hash::Util;

use 5.010;
use strict;
use warnings;
use Data::Clone;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(rename_key);

# VERSION

sub rename_key {
    my ($h, $okey, $nkey) = @_;
    die unless    exists $h->{$okey};
    die if        exists $h->{$nkey};
    $h->{$nkey} = delete $h->{$okey};
}

1;
# ABSTRACT: Hash utilities

=head1 SYNOPSIS

 use SHARYANTO::Hash::Util qw(rename_key);
 my %h = (a=>1, b=>2);
 rename_key(\%h, "a", "alpha"); # %h = (alpha=>1, b=>2)


=head1 FUNCTIONS

=head2 rename_key(\%hash, $old_key, $new_key)

Rename key. This is basically C<< $hash{$new_key} = delete $hash{$old_key} >>
with a couple of additional checks. It is a shortcut for:

 die unless exists $hash{$old_key};
 die if     exists $hash{$new_key};
 $hash{$new_key} = delete $hash{$old_key};

=cut
