package  Wagayatei::Web::C::Character;
use strict;
use warnings;

use parent qw/ Wagayatei::Web::Controller /;
use Wagayatei::Container;

sub do_index {
    my ( $class, $c ) = @_;
}

sub do_skill_list {
    my ( $class, $c ) = @_;
    my $genres = $c->db->search('genre',{},{order_by => {id => 'asc'}});
    $c->stash->{genres} = $genres->all;
}

1;

