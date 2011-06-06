package  Wagayatei::Web;
use strict;
use warnings;

use parent qw/ Wagayatei Chiffon::Web /;

use Chiffon::Plugin::Web::Session;

__PACKAGE__->set_use_modules(
    request  => 'Wagayatei::Web::Request',
    response => 'Wagayatei::Web::Response',
    router   => 'Wagayatei::Web::Router',
);

sub user {shift->stash->{user}}

1;

