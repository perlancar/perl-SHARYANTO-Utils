package SHARYANTO::Package::Util;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(package_exists);

# VERSION

sub package_exists {
    my $pkg = shift;

    return unless $pkg =~ /\A\w+(::\w+)*\z/;
    if ($pkg =~ s/::(\w+)\z//) {
        return ${$pkg . "::"}{$1 . "::"} ? 1:0;
    } else {
        return $::{$pkg . "::"} ? 1:0;
    }
}

1;
# ABSTRACT: Array-related utilities

=head1 SYNOPSIS

 use SHARYANTO::Package::Util qw(package_exists);

 print "Package Foo::Bar exists" if package_exists("Foo::Bar");


=head1 DESCRIPTION


=cut
