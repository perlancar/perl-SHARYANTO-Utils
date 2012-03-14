package SHARYANTO::Doc::Base;

use 5.010;
use Log::Any '$log';
use Moo;

has sections => (is=>'rw');
has lang => (is => 'rw');
has fallback_lang => (is => 'rw');
has mark_fallback_text => (is => 'rw', default=>sub{1});
has _lines => (is => 'rw'); # store final result, array
has _parse => (is => 'rw'); # store parsed items, hash
has loc_class => (
    is => 'rw',
    default => sub {
        my $self = shift;
        ref($self) . '::I18N';
    },
); # store name of localize (project) class
has lh => (
    is => 'rw',
    lazy => 1,
    default => sub {
        require Module::Load;

        my $self = shift;
        Module::Load::load($self->loc_class);
        my $obj = $self->loc_class->new;
        my $lh = $obj->get_handle($self->lang)
            or die "Can't determine language";
        $lh;
    },
); # store localize handle
has _indent_level => (is => 'rw');
has indent => (is => 'rw', default => sub{"  "}); # indent character

# VERSION

sub BUILD {
    my ($self, $args) = @_;

    if (!defined($self->{lang}) && $ENV{LANG}) {
        my $l = $ENV{LANG}; $l =~ s/\W.*//;
        $self->{lang} = $l;
    }
    if (!defined($self->{lang}) && $ENV{LANGUAGE}) {
        my $l = $ENV{LANGUAGE}; $l =~ s/\W.*//;
        $self->{lang} = $l;
    }
    $self->{lang} //= "en_US";
    $self->{fallback_lang} //= "en_US";
}

sub add_section_before {
    my ($self, $name, $before) = @_;
    my $ss = $self->sections;
    return unless $ss;
    my $i = 0;
    my $added;
    while ($i < @$ss && defined($before)) {
        if ($ss->[$i] eq $before) {
            my $pos = $i;
            splice @$ss, $pos, 0, $name;
            $added++;
            last;
        }
        $i++;
    }
    unshift @$ss, $name unless $added;
}

sub add_section_after {
    my ($self, $name, $after) = @_;
    my $ss = $self->sections;
    return unless $ss;
    my $i = 0;
    my $added;
    while ($i < @$ss && defined($after)) {
        if ($ss->[$i] eq $after) {
            my $pos = $i+1;
            splice @$ss, $pos, 0, $name;
            $added++;
            last;
        }
        $i++;
    }
    push @$ss, $name unless $added;
}

sub delete_section {
    my ($self, $name) = @_;
    my $ss = $self->sections;
    return unless $ss;
    my $i = 0;
    while ($i < @$ss) {
        if ($ss->[$i] eq $name) {
            splice @$ss, $i, 1;
        } else {
            $i++;
        }
    }
}

# return single-line dump of data structure, e.g. "[1, 2, 3]" (no trailing
# newlines either).
sub dump_data_sl {
    require Data::Dump::OneLine;

    my ($self, $data) = @_;
    Data::Dump::OneLine::dump1($data);
}

# return a pretty dump of data structure
sub dump_data {
    require Data::Dump;

    my ($self, $data) = @_;
    Data::Dump::dump($data);
}

sub add_lines {
    my $self = shift;
    my $opts;
    if (ref($_[0]) eq 'HASH') { $opts = shift }
    $opts //= {};

    my @lines = map { $_ . (/\n\z/s ? "" : "\n") }
        map {/\n/ ? split /\n/ : $_} @_;

    my $indent = $self->indent x $self->_indent_level;
    push @{$self->_lines},
        map {"$indent$_"} @lines;
}

sub inc_indent {
    my ($self, $n) = @_;
    $n //= 1;
    $self->{_indent_level} += $n;
}

sub dec_indent {
    my ($self, $n) = @_;
    $n //= 1;
    $self->{_indent_level} -= $n;
    die "BUG: Negative indent level" unless $self->{_indent_level} >=0;
}

sub loc {
    my ($self, @args) = @_;
    $self->lh->maketext(@args);
}

sub _trim_blank_lines {
    my $self = shift;
    local $_ = shift;
    return $_ unless defined;
    s/\A(?:\n\s*)+//;
    s/(?:\n\s*){2,}\z/\n/;
    $_;
}

# get text from property of appropriate language. XXX should be moved to
# Perinci-Object later.
sub _get_langprop {
    my ($self, $meta, $prop, $opts) = @_;
    $opts    //= {};
    my $lang   = $self->{lang};
    my $mlang  = $meta->{default_lang} // "en_US";
    my $fblang = $self->{fallback_lang};

    my $v;
    my $x; # x = exists
    if ($lang eq $mlang) {
        $x = exists $meta->{$prop};
        $v = $meta->{$prop};
    } else {
        my $k = "$prop.alt.lang.$lang";
        $x = exists $meta->{$k};
        $v = $meta->{$k};
    }
    $v = $self->_trim_blank_lines($v);
    return $v if $x;

    if ($fblang ne $lang) {
        if ($fblang eq $mlang) {
            $v = $meta->{$prop};
        } else {
            my $k = "$prop.alt.lang.$fblang";
            $v = $meta->{$k};
        }
        $v = $self->_trim_blank_lines($v);
        if (defined($v) && $self->mark_fallback_text) {
            my $has_nl = $v =~ s/\n\z//;
            $v = "{$fblang $v}" . ($has_nl ? "\n" : "");
        }
    }
    $v;
}

sub generate {
    my ($self, %opts) = @_;
    $log->tracef("<- DocBase's generate(), opts=%s, lang=%s",
                 \%opts, $self->lang);

    $self->_lines([]);
    $self->_indent_level(0);
    $self->_parse({});

    for my $s (@{ $self->sections // [] }) {
        my $meth = "parse_$s";
        $log->tracef("=> $meth()");
        $self->$meth;
        $meth = "gen_$s";
        $log->tracef("=> $meth()");
        $self->$meth;
    }

    $log->tracef("<- DocBase's generate()");
    join("", @{ $self->_lines });
}

1;
#ABSTRACT: Base class for documentation generators

=for Pod::Coverate ^section_ ^parse_ ^gen_

=head1 DESCRIPTION

SHARYANTO::Doc::Base is a base class for classes that produce documentation.
This base class provides a system for translation, indentation, and a
C<generate()> method.

To generate a documentation, first you provide a list of section names in
C<sections>. Then you run C<generate()>, which will call C<parse_SECTION> and
C<gen_SECTION> methods for each section consecutively. C<parse_*> is supposed to
parse information from some source into a form readily usable in $self->_parse
hash. C<gen_*> is supposed to generate the actual section in the final
documentation format, by calling C<add_lines> to add text. Finally all the added
lines is concatenated together and returned.

This module uses L<Log::Any> for logging.

This module uses L<Moo> for object system.


=head1 SEE ALSO

This module is used, among others, by: C<Perinci::To::*> modules.

=cut
