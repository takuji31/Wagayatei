package Wagayatei::Model::Pc;
use strict;
use warnings;

use parent 'Wagayatei::Model';

sub type_name {
    my $self = shift;
    my $label = $self->config->{type_name};
    return $label->{$self->type};
}

sub rank_name {
    my $self = shift;
    my $label = $self->config->{rank_name};
    return $label->{$self->rank};
}

sub main_char {
    my $self = shift;
    return if $self->main_fg eq 'yes';
    $self->db->single('pc' => {id => {'!=' => $self->id}, main_fg => 'yes'});
}

1;
