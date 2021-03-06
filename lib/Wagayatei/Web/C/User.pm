package  Wagayatei::Web::C::User;
use strict;
use warnings;
use parent qw/ Wagayatei::Web::Controller /;
use Wagayatei::Container;
use Wagayatei::DB;
use Time::Piece;

__PACKAGE__->add_trigger(
    before_action => sub {
        my ($class, $c) = @_;
        my $user = $c->user;
        $c->redirect('/') unless $user;
        my $action = $c->action;
        return if $action eq 'logout';
        my $authenticated =  $user->status eq 'authenticated';
        my $register      =  grep /^$action$/, qw(register register_do confirm);
        if ( ( $authenticated && !$register ) || ( !$authenticated && !$register ) ) {
            $c->redirect('/');
        }
    }
);

sub do_index {
    my ( $class, $c ) = @_;
}

sub do_register {
    my ( $class, $c ) = @_;
    if( $c->req->is_post_request ) {
        my $validator = $c->validator("User");
        $validator->register;
        if( $validator->has_error ) {
            $c->stash->{validator} = $validator;
        } else {
            my $data = $validator->valid_data;
            $c->user->update({status => 'created', name => delete $data->{nick_name}});
            $c->db->insert(
                'pc' => {
                    uuid => $class->create_uuid,
                    user_id => $c->user->id,
                    main_fg => 'yes',
                    status => 'public',
                    %$data,
                }
            );
            $c->redirect('/character/my');
        }
    }
}

sub do_logout {
    my ( $class, $c ) = @_;
    $c->session->remove('user_id');
    my $back_to = $c->req->param('back_to') || "http://@{$c->req->uri->host}/";
    my $uri = URI->new($back_to);
    my $redirect_uri = $uri->host eq $c->req->uri->host ? $uri->as_string : "http://@{$c->req->uri->host}/";
    $c->redirect($redirect_uri);
}

1;

