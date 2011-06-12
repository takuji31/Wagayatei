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
            $c->action('confirm');
            $class->do_confirm($c);
        }
    }
}

sub do_confirm {
    my ( $class, $c ) = @_;
}

sub do_register_do {
    my ( $class, $c ) = @_;

    if( $c->req->is_post_request ) {
        my $validator = $c->validator("User");
        $validator->register;
        unless( $validator->has_error ) {
            my $now = localtime;
            $c->user->update({status => 'created', name => $c->req->param('nick_name')});
            my $db = Wagayatei::DB->get_db;
            $db->insert(
                'pc' => {
                    uuid => $class->create_uuid,
                    user_id => $c->user->id,
                    name => $c->req->param('name'),
                    type => $c->req->param('type'),
                    profile => $c->req->param('profile'),
                    main_fg => 'yes',
                    status => 'public',
                    created_at => $now,
                    updated_at => $now
                }
            );
        }
    }
    $c->redirect('/');
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

