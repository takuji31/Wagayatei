package  Wagayatei::Model;
use strict;
use warnings;
use parent 'Teng::Row';
use Wagayatei::DB;
use Chiffon;

sub db { Wagayatei::DB->get_db }
sub context { Chiffon->context }

sub config { shift->context->config; }

1;
