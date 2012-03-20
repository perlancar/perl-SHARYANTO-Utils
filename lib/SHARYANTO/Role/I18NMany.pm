package SHARYANTO::Role::I18NMany;

use 5.010;
use Log::Any '$log';
use Moo::Role;

# VERSION

has langs => (
    is => 'rw',
    default => sub { ['en_US'] },
);
has loc_class => (
    is => 'rw',
    default => sub {
        my $self = shift;
        ref($self) . '::I18N';
    },
);

sub lh {
    my ($self, $lang) = @_;
    die "Please specify lang" unless $lang;

    state $obj;
    if (!$obj) {
        require Module::Load;
        Module::Load::load($self->loc_class);
        $obj = $self->loc_class->new;
    }

    state $lhs = {};
    return $lhs->{$lang} if $lhs->{$lang};

    my $lh = $obj->get_handle($lang)
        or die "Can't get language handle for lang=$lang";
    my %class;
    for (my ($l, $h) = each %$lh) {
        my $c = ref($h);
        die "Lang=$lang falls back to lang=$l (class=$c)" if $class{$c};
        $class{$c} = $l;
    }

    $lhs->{$lang} = $lh;
    $lh;
}

sub locl {
    my ($self, $lang, @args) = @_;
    $self->get_lh($lang)->maketext(@args);
}


1;
# ABSTRACT: Role for internationalized class

=head1 DESCRIPTION

This role is like L<SHARYANTO::Role::I18N> but for class that wants to localize
text for more than one languages. Its locl() accepts desired language as its
first argument.


=head1 ATTRIBUTES

=head2 lang

Defaults to LANG or LANGUAGE environment variable, or C<en_US>.

=head2 loc_class

Project class. Defaults to $class::I18N.


=head1 METHODS

=head2 $doc->lh($lang) => OBJ

Get language handle for a certain language. $lang is required.

=head2 $doc->locl($lang, @args) => STR

Shortcut for C<$doc->lh($lang)->maketext(@args)>.

=cut
