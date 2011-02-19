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

1;

