package Wagayatei::Model::Skill;
use strict;
use warnings;

use parent 'Wagayatei::Model';

sub all_rank {
    my $self = shift;

    my $conf = $self->config->{skill_rank};
    my @rank_list = @$conf[0..$self->max];
    return [@rank_list];
}

sub max_rank {
    my $self = shift;
    $self->config->{skill_max_rank}->[$self->max];
}

sub min_rank {
    my $self = shift;
    $self->config->{skill_rank}->[0];
}

sub type {
    my $self = shift;

    my $label = $self->config->{type_name};
    my @types;
    my $type_data = $self->type_data || [];
    for my $type (@$type_data){
        push @types,$label->{$type};
    }
    return join ' ',@types;

}

sub can_set {
    my ($self, $type) = @_;
    my $type_data = $self->type_data;
    return 1 unless scalar @$type_data;
    return grep /^$type$/, @$type_data;
}

1;
