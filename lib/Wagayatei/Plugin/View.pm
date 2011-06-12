package  Wagayatei::Plugin::View;
use strict;
use warnings;

use Exporter::Lite;
use Text::Xslate::Util;

use Wagayatei;

our @EXPORT = qw(view_functions);

sub nl2br {
    my $str = shift;
    $str =~ s/([\r\n]+)/<br \/>$1/gm;
    $str = Text::Xslate::Util::mark_raw($str);
    return $str;
}

sub type_name {
    my $type = shift;
    return Wagayatei->config->{type_name}->{$type};
}

sub view_functions {
    return {nl2br => \&nl2br, type_name => \&type_name};
}

1;
