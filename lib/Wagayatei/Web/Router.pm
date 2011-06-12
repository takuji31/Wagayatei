package  Wagayatei::Web::Router;
use strict;
use warnings;

use Chiffon::Web::Router;

connect(
    '/:controller/:action/:uuid',
    {},
    {
        pass => ['uuid'],
    }
);

1;

