package Wagayatei::Model::PcSkill;
use strict;
use warnings;

use parent 'Wagayatei::Model';

sub skill {
    my $self = shift;
    $self->db->single(skill => {id => $self->skill_id});
}

1;
