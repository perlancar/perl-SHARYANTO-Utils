package SHARYANTO::Marpa::Simple;

use Marpa::R2;
use UUID::Random;

use Exporter qw(import);
our @EXPORT_OK = qw(gen_parser);

# VERSION
# DATE

our %SPEC;

$SPEC{gen_parser} = {
    v => 1.1,
    summary => 'Generate Marpa-based parser',
    args => {
        grammar => {
            summary => '',
            schema  => 'str*',
            req => 1,
            pos => 0,
        },
        actions => {
            summary => '',
            schema  => ['hash*', each_value => 'code*'],
        },
    },
    result_naked => 1,
    result => {
        schema => 'code*',
    },
};
sub gen_parser {
    no strict 'refs';

    my %args = @_;

    my $grammar = Marpa::R2::Scanless::G->new({source => \$args{grammar} });
    my $pkg = __PACKAGE__ . '::gen' . substr(UUID::Random::generate(), 0, 8);
    my $acts = $args{actions};
    for (keys %$acts) {
        *{"$pkg\::$_"} = $acts->{$_};
    }

    my $parser = sub {
        my $input = shift;

        my $recce = Marpa::R2::Scanless::R->new({
            grammar => $grammar,
            semantics_package => $pkg,
        });
        $recce->read(\$input);
        my $valref = $recce->value;
        if (!defined($valref)) {
            die "No parse was found after reading the entire input\n";
            # XXX show last expression
        }
        $$valref;
    };

    $parser;
}

1;
# ABSTRACT: Generate Marpa-based parser

=head1 SYNOPSIS

 use SHARYANTO::Marpa::Simple qw(gen_parser);

 my $parser = gen_parser(
     grammar => <<'EOG',
 :start     ::= expr
 expr       ::= num
              | num '+' num    action => do_add
 num        ~ [\d]+
 :discard   ~ whitespace
 whitespace ~ [\s]+
 EOG
     actions => {
         do_add => sub { shift; $_[0] + $_[2] }
     },
 );

 print $parser->('3 + 4'); # -> 7
 print $parser->('3 + ');  # dies with parse error

which is a shortcut for roughly this:

 no strict 'refs';
 use Marpa::R2;
 my $grammar = Marpa::R2::Scanless::G->new({source => \$args{grammar}});
 my $pkg = "SHARYANTO::Marpa::Simple::gen" . some_random_value();
 my $actions = $args{actions};
 for (keys %$actions) {
     ${"$pkg\::$_"} = $actions->{$_};
 }
 my $parser = sub {
     my $input = shift;
     my $recce = Marpa::R2::Scanless::R->new({
         grammar => $grammar,
         semantics_package => $pkg,
     });
 };


=head1 DESCRIPTION

This module tries to simplify the incantation of producing a parser using
L<Marpa::R2> (the scanless interface) by reducing the process to a single
function call: C<gen_parser>.


=head1 SEE ALSO

L<Marpa::R2>
