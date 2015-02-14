package SHARYANTO::HTTP::DetectUA::Simple;

use 5.010;
require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(detect_http_ua_simple);

# VERSION

our %SPEC;

$SPEC{":package"} = {
    v => 1.1,
    summary => 'A very simple and generic browser detection library',
    description => <<'_',

I needed a simple and fast routine which can detect whether HTTP client is a GUI
browser (like Chrome or Firefox), a text browser (like Lynx or Links), or
neither (like curl, or L<LWP>). Hence, this module.

_
};

$SPEC{detect_http_ua_simple} = {
    v => 1.1,
    summary => 'Detect whether HTTP client is a GUI/TUI browser',
    description => <<'_',

This function is a simple and fast routine to detect whether HTTP client is a
GUI browser (like Chrome or Firefox), a text-based browser (like Lynx or Links),
or neither (like curl or LWP). Extra information can be provided in the future.

Currently these heuristic rules are used:

* check popular browser markers in User-Agent header (e.g. 'Chrome', 'Opera');
* check Accept header for 'image/';

It is several times faster than the other equivalent Perl modules, this is
because it does significantly less.

_
    args => {
        env => {
            pos => 0,
            summary => 'CGI-compatible environment, e.g. \%ENV or PSGI\'s $env',
        },
    },
    result => {
        description => <<'_',

* 'is_gui_browser' key will be set to true if HTTP client is a GUI browser.

* 'is_text_browser' key will be set to true if HTTP client is a text/TUI
  browser.

* 'is_browser' key will be set to true if either 'is_gui_browser' or
  'is_text_browser' is set to true.

_
        schema => 'hash*',
    },
    links => [
        {url => "pm:HTML::ParseBrowser"},
        {url => "pm:HTTP::BrowserDetect"},
        {url => "pm:HTTP::DetectUserAgent"},
        {url => "pm:Parse::HTTP::UserAgent"},
        {url => "pm:HTTP::headers::UserAgent"},
    ],
    args_as => "array",
    result_naked => 0,
};

sub detect_http_ua_simple {
    my ($env) = @_;
    my $res = {};
    my $det;

    my $ua = $env->{HTTP_USER_AGENT};
    if ($ua) {
        # check for popular browser GUI UA
        if ($ua =~ m!\b(?:Mozilla/|MSIE |Chrome/|Opera/|
                         Profile/MIDP-
                     )!x) {
            $res->{is_gui_browser} = 1;
            $det++;
        }
        # check for popular webbot UA
        if ($ua =~ m!\b(?:Links |ELinks/|Lynx/|w3m/)!) {
            $res->{is_text_browser} = 1;
            $det++;
        }
    }

    if (!$det) {
        # check for accept mime type
        my $ac = $env->{HTTP_ACCEPT};
        if ($ac) {
            if ($ac =~ m!\b(?:image/)!) {
                $res->{is_gui_browser} = 1;
                $det++;
            }
        }
    }

    $res->{is_browser} = 1 if $res->{is_gui_browser} || $res->{is_text_browser};
    $res;
}

1;
# ABSTRACT:

=head1 SEE ALSO

L<SHARYANTO>

=cut
