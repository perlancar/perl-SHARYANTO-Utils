package SHARYANTO::Role::ColorTheme;

use 5.010;
use Moo::Role;

# VERSION

with 'SHARYANTO::Role::TermAttrs';

has color_theme_args  => (is => 'rw', default => sub { {} });
has _all_color_themes => (is => 'rw');

sub color_theme {
    my $self = shift;

    if (!@_) { return $self->{color_theme} }
    my $ct = shift;

    my $p2 = "";
    if (!ref($ct)) {
        $p2 = " named $ct";
        $ct = $self->get_color_theme($ct);
    }

    my $err;
    if (!$ct->{no_color} && !$self->use_color) {
        $err = "color theme uses color but use_color is set to false";
    }
   die "Can't select color theme$p2: $err" if $err;

    $self->{color_theme} = $ct;
}

sub get_color_theme {
    my ($self, $ct) = @_;

    my $prefix = (ref($self) ? ref($self) : $self ) .
        '::ColorTheme'; # XXX allow override

    my $cts;
    my $pkg;
    if ($ct =~ s/(.+):://) {
        $pkg = "$prefix\::$1";
        my $pkgp = $pkg; $pkgp =~ s!::!/!g;
        require "$pkgp.pm";
        no strict 'refs';
        $cts = \%{"$pkg\::color_themes"};
    } else {
        #$cts = $self->list_color_themes(1);
        die "Please use SubPackage::name to choose color theme, ".
            "use list_color_themes() to list available themes";
    }
    $cts->{$ct} or die "Unknown color theme name '$ct'".
        ($pkg ? " in package $prefix\::$pkg" : "");
    $cts->{$ct};
}

sub list_color_themes {
    require Module::List;
    require Module::Load;

    my ($self, $detail) = @_;

    my $prefix = (ref($self) ? ref($self) : $self ) .
        '::ColorTheme'; # XXX allow override

    my $all_ct = $self->_all_color_themes;

    if (!$all_ct) {
        my $mods = Module::List::list_modules("$prefix\::",
                                              {list_modules=>1});
        no strict 'refs';
        $all_ct = {};
        for my $mod (sort keys %$mods) {
            #$log->tracef("Loading color theme module '%s' ...", $mod);
            Module::Load::load($mod);
            my $ct = \%{"$mod\::color_themes"};
            for (keys %$ct) {
                my $cutmod = $mod;
                $cutmod =~ s/^\Q$prefix\E:://;
                my $name = "$cutmod\::$_";
                $ct->{$_}{name} = $name;
                $all_ct->{$name} = $ct->{$_};
            }
        }
        $self->_all_color_themes($all_ct);
    }

    if ($detail) {
        return $all_ct;
    } else {
        return sort keys %$all_ct;
    }
}

1;
# ABSTRACT: Role for class wanting to support color themes

=head1 DESCRIPTION

This role is for class that wants to support color themes. For description about
color themes, currently please refer to L<Text::ANSITable>.


=head1 ATTRIBUTES

=head2 color_theme => HASH

=head2 color_theme_args => HASH


=head1 METHODS

=head2 $cl->get_color_theme($name) => HASH

=head2 $cl->list_color_themes($detail) => ARRAY

=cut
