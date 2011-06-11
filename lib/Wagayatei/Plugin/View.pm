package  Wagayatei::Plugin::View;
use strict;
use warnings;

use Exporter::Lite;
use Text::Xslate::Util;

our @EXPORT = qw(nl2br);

sub nl2br {
    my $str = shift;
    $str =~ s/([\r\n]+)/<br \/>$1/gm;
    $str = Text::Xslate::Util::mark_raw($str);
    return $str;
}

1;
