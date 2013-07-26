package SHARYANTO::Role::Doc::Section::AddTextLines;

use 5.010;
use Log::Any '$log';
use Moo::Role;

# VERSION

requires 'doc_lines';
has wrap => (is => 'rw', default => sub {1});

sub add_doc_lines {
    my $self = shift;
    my $opts;
    if (ref($_[0]) eq 'HASH') { $opts = shift }
    $opts //= {};

    my @lines = map { $_ . (/\n\z/s ? "" : "\n") }
        map {/\n/ ? split /\n/ : $_} @_;

    # debug
    #my @c = caller(2);
    #$c[1] =~ s!.+/!!;
    #@lines = map {"[from $c[1]:$c[2]]$_"} @ lines;

    my $indent = $self->indent x $self->indent_level;
    my $wrap = $opts->{wrap} // $self->wrap;

    if ($wrap) {
        require Text::Wrap;

        # split into paragraphs, merge each paragraph text into a single line
        # first
        my @para;
        my $i = 0;
        my ($start, $type);
        $type = '';
        #$log->warnf("lines=%s", \@lines);
        for (@lines) {
            if (/^\s*$/) {
                if (defined($start) && $type ne 'blank') {
                    push @para, [$type, [@lines[$start..$i-1]]];
                    undef $start;
                }
                $start //= $i;
                $type = 'blank';
            } elsif (/^\s{4,}\S+/ && (!$i || $type eq 'verbatim' ||
                         (@para && $para[-1][0] eq 'blank'))) {
                if (defined($start) && $type ne 'verbatim') {
                    push @para, [$type, [@lines[$start..$i-1]]];
                    undef $start;
                }
                $start //= $i;
                $type = 'verbatim';
            } else {
                if (defined($start) && $type ne 'normal') {
                    push @para, [$type, [@lines[$start..$i-1]]];
                    undef $start;
                }
                $start //= $i;
                $type = 'normal';
            }
            #$log->warnf("i=%d, lines=%s, start=%s, type=%s",
            #            $i, $_, $start, $type);
            $i++;
        }
        if (@para && $para[-1][0] eq $type) {
            push @{ $para[-1][1] }, [$type, [@lines[$start..$i-1]]];
        } else {
            push @para, [$type, [@lines[$start..$i-1]]];
        }
        #$log->warnf("para=%s", \@para);

        for my $para (@para) {
            if ($para->[0] eq 'blank') {
                push @{$self->doc_lines}, @{$para->[1]};
            } else {
                if ($para->[0] eq 'normal') {
                    for (@{$para->[1]}) {
                        s/\n/ /g;
                    }
                    $para->[1] = [join("", @{$para->[1]}) . "\n"];
                }
                #$log->warnf("para=%s", $para);
                local $Text::Wrap::columns = $ENV{COLUMNS} // 80;
                push @{$self->doc_lines},
                    Text::Wrap::wrap($indent, $indent, @{$para->[1]});
            }
        }
    } else {
        push @{$self->doc_lines},
            map {"$indent$_"} @lines;
    }
}

1;

# ABSTRACT: Provide add_doc_lines() to add text with optional text wrapping

=head1 DESCRIPTION

This role provides C<add_doc_lines()> which can add optionally wrapped text to
C<doc_lines>.

The default column width for wrapping is from C<COLUMNS> environment variable,
or 80.


=head1 ATTRIBUTES

=head2 wrap => BOOL (default: 1)

Whether to do text wrapping.


=head1 REQUIRES

=head2 $o->doc_lines()


=head1 METHODS

=head2 $o->add_doc_lines([$opts, ]@lines)


=head1 ENVIRONMENT

=head2 COLUMNS => INT

Used to set column width.


=head1 SEE ALSO

L<SHARYANTO::Role::Doc::Section>

=cut
