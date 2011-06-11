package  Wagayatei::Web::Controller;
use strict;
use warnings;

use parent qw/ Chiffon::Web::Controller /;
use Data::GUID;
use Wagayatei::DB;

sub create_uuid {
    Data::GUID->guid_hex;
}

1;

