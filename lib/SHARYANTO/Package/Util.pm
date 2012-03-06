package SHARYANTO::Package::Util;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(package_exists);

# VERSION

sub package_exists {
    my $pkg = shift;

    return unless $pkg =~ /\A\w+(::\w+)*\z/;
    if ($pkg =~ s/::(\w+)\z//) {
        return !!${$pkg . "::"}{$1 . "::"};
    } else {
        return !!$::{$pkg . "::"};
    }
}

1;
# ABSTRACT: Package-related utilities

=head1 SYNOPSIS

 use SHARYANTO::Package::Util qw(package_exists);

 print "Package Foo::Bar exists" if package_exists("Foo::Bar");


=head1 DESCRIPTION


=head1 FUNCTIONS

None are exported by default, but they can be.

=head2 package_exists($name) => BOOL

Return true if package "exists". By "exists", it means that the package has been
defined by C<package> statement or some entries have been created in the symbol
table (e.g. C<$Foo::var = 1;> will make the C<Foo> package "exist").

This function can be used e.g. for checking before aliasing one package to
another. Or to casually check whether a module has been loaded.

=cut
