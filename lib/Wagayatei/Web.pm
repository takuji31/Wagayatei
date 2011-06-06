package  Wagayatei::Web;
use strict;
use warnings;

use parent qw/ Wagayatei Chiffon::Web /;

use Chiffon::Plugin::Web::Session;
use Wagayatei::Container;
use Wagayatei::DB;


__PACKAGE__->set_use_modules(
    request  => 'Wagayatei::Web::Request',
    response => 'Wagayatei::Web::Response',
    router   => 'Wagayatei::Web::Router',
);

__PACKAGE__->add_trigger(
    before_action => sub{
        my $self = shift;
        $self->stash->{site_title} = container('label')->{guild_name};
        $self->stash->{page_title} = $self->action . " | " . $self->controller;
        my $db = Wagayatei::DB->get_db;
        my $user_id = $self->session->get('user_id');
        if ( defined $user_id ) {
            my $user = $db->single('user',{ id => $user_id });
            $self->stash->{user} = $user;
        }
    }, 

);

sub user {shift->stash->{user}}

1;

