package  Wagayatei::Container;
use strict;
use warnings;

use Chiffon::Container;

use Wagayatei;

register 'validator' => sub {
    my $self = shift;

    load_class('Wagayatei::ValidatorLoader');

    Wagayatei::ValidatorLoader->new(
        constraints => $self->get('conf')->{validator_message},
    );
};

register 'label' => sub {
    my $self = shift;
    do $self->get('home')->file('assets/label.pl')->stringify;
};

register 'local_navi' => sub {
    my $self = shift;
    do $self->get('home')->file('assets/local_navi.pl')->stringify;
};

register 'conf' => sub {
    Wagayatei->config;
};

register 'home' => sub {
    Wagayatei->base_dir;
};

1;

