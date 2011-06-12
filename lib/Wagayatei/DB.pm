package  Wagayatei::DB;
use strict;
use warnings;


use parent qw(Teng);

use Scope::Container;
use Scope::Container::DBI;
use Teng::Schema::Loader;
use Wagayatei;
__PACKAGE__->load_plugin('Pager');

sub get_db {
    my $class = shift;
    unless ( my $instance = scope_container('db') ) {
        my $connect_info = $class->get_connect_info;
        my $dbi = $class->get_dbi;
        $class->new(
            connect_info => $connect_info,
            dbh          => $dbi,
        );
    }
}

sub get_connect_info { Wagayatei->config->{datasource}->{master} }

sub get_dbi {
    my $connect_info = shift->get_connect_info;
    my $dbi = Scope::Container::DBI->connect(
        @$connect_info,
    );
    return $dbi;
}

1;
