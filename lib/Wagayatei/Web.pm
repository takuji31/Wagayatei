package  Wagayatei::Web;
use Chiffon::Core;
use Chiffon::View::Xslate;
use Wagayatei::Web::Context;
use Wagayatei::Web::Request;
use Wagayatei::Web::Response;
use Wagayatei::Web::Dispatcher;
use Wagayatei::Container;
use parent qw/ Chiffon::Web /;

__PACKAGE__->used_modules({
    container  => 'Wagayatei::Container',
    context    => 'Wagayatei::Web::Context',
    request    => 'Wagayatei::Web::Request',
    response   => 'Wagayatei::Web::Response',
    dispatcher => 'Wagayatei::Web::Dispatcher',
    view       => 'Chiffon::View::Xslate',
});

1;

