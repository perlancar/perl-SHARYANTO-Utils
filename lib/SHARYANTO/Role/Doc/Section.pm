package SHARYANTO::Role::Doc::Section;

use 5.010;
use Log::Any '$log';
use Moo::Role;

# VERSION

has doc_sections => (is=>'rw');
has doc_lines => (is => 'rw'); # store final result, array
has doc_parse => (is => 'rw'); # store parsed items, hash
has indent_level => (is => 'rw');
has indent => (is => 'rw', default => sub{"  "}); # indent character

requires 'add_doc_lines';

sub add_doc_section_before {
    my ($self, $name, $before) = @_;
    my $ss = $self->doc_sections;
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

sub add_doc_section_after {
    my ($self, $name, $after) = @_;
    my $ss = $self->doc_sections;
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

sub delete_doc_section {
    my ($self, $name) = @_;
    my $ss = $self->doc_sections;
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

sub inc_indent {
    my ($self, $n) = @_;
    $n //= 1;
    $self->{indent_level} += $n;
}

sub dec_indent {
    my ($self, $n) = @_;
    $n //= 1;
    $self->{indent_level} -= $n;
    die "BUG: Negative indent level" unless $self->{indent_level} >=0;
}

sub before_generate_doc {}

sub after_generate_doc {}

sub generate_doc {
    my ($self, %opts) = @_;
    $log->tracef("-> generate_doc(opts=%s)", \%opts);

    $self->doc_lines([]);
    $self->indent_level(0);
    $self->doc_parse({});

    $self->before_generate_doc(%opts);

    for my $s (@{ $self->doc_sections // [] }) {
        my $meth = "doc_parse_$s";
        $log->tracef("=> $meth()");
        $self->$meth(%opts);
        $meth = "doc_gen_$s";
        $log->tracef("=> $meth()");
        $self->$meth(%opts);
    }

    $self->after_generate_doc(%opts);

    $log->tracef("<- generate_doc()");
    join("", @{ $self->doc_lines });
}

1;
#ABSTRACT: Role for class that generates documentation with sections

=head1 DESCRIPTION

SHARYANTO::Role::Doc::Section is a role for classes that produce documentation
with sections. This role provides a workflow for parsing and generating
sections, regulating indentation, and a C<generate_doc()> method.

To generate documentation, first you provide a list of section names in
C<doc_sections>. Then you run C<generate_doc()>, which will call
C<doc_parse_SECTION> and C<doc_gen_SECTION> methods for each section
consecutively. C<doc_parse_*> is supposed to parse information from some source
into a form readily usable in $self->doc_parse hash. C<doc_gen_*> is supposed to
generate the actual section in the final documentation format, by calling
C<add_doc_lines> to add text. Finally all the added lines is concatenated
together and returned.

This module uses L<Log::Any> for logging.

This module uses L<Moo> for object system.


=head1 ATTRIBUTES

=head2 doc_sections => ARRAY

=head2 doc_sections => ARRAY

=head2 doc_parse => HASH

=head2 indent_level => INT

=head2 indent => STR (default '  ' (two spaces))

Character(s) used for indent.


=head1 METHODS

=head2 add_doc_section_before($name, $anchor)

=head2 add_doc_section_after($name, $anchor)

=head2 after_generate_doc()

=head2 before_generate_doc()

=head2 delete_doc_section($name)

=head2 doc_lines()

=head2 add_doc_lines(@lines)

=head2 inc_indent([N])

=head2 dec_indent([N])

=head2 generate_doc() => STR


=head1 SEE ALSO

This module is used, among others, by: C<Perinci::To::*> modules.

=cut
