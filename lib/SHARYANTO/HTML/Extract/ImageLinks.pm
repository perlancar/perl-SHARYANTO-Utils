package SHARYANTO::HTML::Extract::ImageLinks;

use 5.010;
use strict;
use warnings;

use HTML::Parser;
use URI::URL;

use Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(extract_image_links);

# VERSION

our %SPEC;

$SPEC{extract_image_links} = {
    v => 1.1,
    summary => 'Extract image links from HTML document',
    description => <<'_',

Either specify either url, html.

_
    args => {
        html => {
            schema => 'str*',
            req => 1,
            summary => 'HTML document to extract from',
            cmdline_src => 'stdin_or_files',
        },
        base => {
            schema => 'str',
            summary => 'base URL for images',
        },
    },
};
sub extract_image_links {
    my %args = @_;

    my $html = $args{html};
    my $base = $args{base};

    # get base from <BASE HREF> if exists
    if (!$base) {
        if ($html =~ /<base\b[^>]*\bhref\s*=\s*(["']?)(\S+?)\1[^>]*>/is) {
            $base = $2;
        }
    }

    my %memory;
    my @res;
    my $p = HTML::Parser->new(
        api_version => 3,
        start_h => [
            sub {
                my ($tagname, $attr) = @_;
                return unless $tagname =~ /^img$/i;
                for ($attr->{src}) {
                    s/#.*//;
                    if (++$memory{$_} == 1) {
                        push @res, URI::URL->new($_, $base)->abs()->as_string;
                    }
                }
            }, "tagname, attr"],
    );
    $p->parse($html);

    [200, "OK", \@res];
}

1;
# ABSTRACT: Extract image links from HTML document

=head1 SEE ALSO

L<SHARYANTO>

=cut
