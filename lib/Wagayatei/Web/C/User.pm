package  Wagayatei::Web::C::User;
use Chiffon::Core;
use parent qw/ Wagayatei::Web::Controller /;
use Wagayatei::Container;

__PACKAGE__->add_trigger(
    before_action => sub {
        my ($class, $c) = @_;
        my $user = $c->user;
        $c->redirect('/') unless $user;
        $c->redirect('/') if $user->status ne 'authenticated';
    }
);

sub do_index {
    my ( $class, $c ) = @_;
}

sub do_register {
    my ( $class, $c ) = @_;
}

sub do_logout {
    my ( $class, $c ) = @_;
    $c->session->remove('user_id');
    $c->redirect('/');
}

1;

