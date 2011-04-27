package  Wagayatei::Container;
use Chiffon::Core;
use Chiffon::Container -base;
use Class::Load qw/ load_class /;

register 'validator' => sub {
    my $self = shift;

    load_class( 'Wagayatei::ValidatorLoader' );

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

1;

