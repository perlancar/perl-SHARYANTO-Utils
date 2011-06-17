package SHARYANTO::HTML::Extract::ImageLinks;
# ABSTRACT: Extract image links from HTML document

use 5.010;
use strict;
use warnings;

use HTML::Parser;
use URI::URL;

use Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(extract_image_links);

our %SPEC;

$SPEC{extract_image_links} = {
    summary => 'Extract image links from HTML document',
    description => <<'_',

Either specify either url, html.

_
    args => {
        html => ['str' => {
            summary => 'HTML document to extract from',
            arg_from_stdin => 1,
        }],
        base => ['str' => {
            summary => 'base URL for images',
        }],
    },
};
sub extract_image_links {
    my %args = @_;

    my $html = $args{html};
    defined($html) or return [400, "Please specify html"];
    my $base = $args{base};

    # get base from <BASE HREF> if exists
    if (!$base) {
        if ($html =~ /<base\b[^>]*\bhref\s*=\s*(["']?)(\S+?)\1[^>]*>/is) {
            $base = $2;
        }
    }
    $base //= '';

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
