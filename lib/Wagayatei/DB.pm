package  Wagayatei::DB;
use strict;
use warnings;


use parent qw(Teng);

use Class::Method::Modifiers::Fast;
use Scope::Container;
use Scope::Container::DBI;
use Teng::Schema::Loader;
use Time::Piece;
use Data::GUID;

use Wagayatei;

__PACKAGE__->load_plugin('Pager');
__PACKAGE__->load_plugin('BulkInsert');

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

before 'insert', 'fast_insert' => sub {
    my ($self, $table_name, $row_data) = @_;
    my $table = $self->schema->get_table($table_name);
    if ( $table ) {
        my $columns = $table->columns;
        my $now = localtime;
        for my $column (qw(created_at updated_at)) {
            if( grep /^$column$/, @$columns ) {
                $row_data->{$column} = $now;
            }
        }
        if( grep /^uuid$/, @$columns ) {
            $row_data->{uuid} = Data::GUID->guid_hex;
        }
    }
};

before bulk_insert => sub {
    my ($self, $table_name, $row_data) = @_;
    my $table = $self->schema->get_table($table_name);
    if ( $table ) {
        my $columns = $table->columns;
        my $now = localtime;
        for my $column (qw(created_at updated_at)) {
            if( grep /^$column$/, @$columns ) {
                for my $row ( @$row_data ) {
                    $row->{$column} = $now;
                }
            }
        }
        if( grep /^uuid$/, @$columns ) {
            for my $row ( @$row_data ) {
                $row->{uuid} = Data::GUID->guid_hex;
            }
        }
    }
};
before 'update' => sub {
    my ($self, $table_name, $row_data) = @_;
    my $table = $self->schema->get_table($table_name);
    if ( $table ) {
        my $columns = $table->columns;
        my $now = localtime;
        if( grep /^updated_at$/, @$columns ) {
            $row_data->{updated_at} = $now;
        }
    }
};

1;
