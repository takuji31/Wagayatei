package  Wagayatei::Model::Genre;
use strict;
use warnings;
use parent 'Wagayatei::Model';

sub skills {
    my $self = shift;

    return $self->db->search('skill',{genre_id => $self->id},{order_by => { id => 'asc' }});
}

1;
