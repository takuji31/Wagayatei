package  Wagayatei::Web::C::Root;
use Chiffon::Core;
use Chiffon::Web::Controller;
use Wagayatei::Container;

sub do_index {
    my ( $class, $c ) = @_;
    $c->stash->{body} = "Hello Chiffon World!";
}

1;

