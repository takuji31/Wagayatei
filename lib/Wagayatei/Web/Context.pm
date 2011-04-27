package  Wagayatei::Web::Context;
use Chiffon::Core;
use Wagayatei::Container;
use parent qw/ Chiffon::Web::Context /;

sub user {
    my $self = shift;
    $self->stash->{user};
}

1;

