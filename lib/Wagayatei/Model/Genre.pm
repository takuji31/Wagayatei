package  Wagayatei::Model::Genre;
use strict;
use warnings;
use parent 'Wagayatei::Model';

sub skills {
    my ($self, $type) = @_;

    my $cond = {genre_id => $self->id};

    if ( $type ) {
        $cond->{type_data} = [ { like => "%$type%" }, '[]' ];
    }

    return $self->db->search('skill', $cond, {order_by => { id => 'asc' }});
}

1;
