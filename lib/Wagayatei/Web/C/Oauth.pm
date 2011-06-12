package  Wagayatei::Web::C::Oauth;
use strict;
use warnings;

use parent qw/ Wagayatei::Web::Controller /;

use Config::Pit;
use JSON::XS;
use OAuth::Lite::Consumer;
use Time::Piece::MySQL;
use URI;

use Wagayatei::Container;
use Wagayatei::DB;

sub get_consumer {
    my ( $class, $c ) = @_;
    my $callback = URI->new(join '','http://',$c->req->uri->host,'/oauth/callback');
    if ( $c->action eq 'index' ) {
        my $back_to = $c->req->param('back_to') || "http://$c->req->uri->host/";
        my $uri = URI->new($back_to);
        my $redirect_uri = $uri->host eq $c->req->uri->host ? $uri->as_string : "http://$c->req->uri->host/";
        $callback->query_form(back_to => $redirect_uri);
    }
    my $consumer = OAuth::Lite::Consumer->new(
        %{pit_get('wagayatei', require => { consumer_key => 'Twitter consumer key', consumer_secret => 'Twitter consumer secret' })},
        request_token_path => 'http://twitter.com/oauth/request_token',
        access_token_path  => 'http://twitter.com/oauth/access_token',
        authorize_path     => 'http://twitter.com/oauth/authenticate',
        callback_url => $callback->as_string,
    );
    return $consumer;
}

sub do_index {
    my ( $class, $c ) = @_;

    my $consumer = $class->get_consumer($c);
    my $request_token = $consumer->get_request_token();

    my $uri = URI->new($consumer->{authorize_path});
    $uri->query(
        $consumer->gen_auth_query("GET", 'http://twitter.com', $request_token)
    );

    $c->redirect($uri->as_string);
}

sub do_callback {
   my ( $class, $c ) = @_;

    my $consumer = $class->get_consumer($c);
    my $oauth_token    = $c->req->param('oauth_token');
    my $oauth_verifier = $c->req->param('oauth_verifier');
    my $back_to = $c->req->param('back_to') || "http://$c->req->uri->host/";

    my $db = Wagayatei::DB->get_db;

    my $access_token = $consumer->get_access_token(
        token    => $oauth_token,
        verifier => $oauth_verifier,
    );
    unless ($access_token) {
        $c->redirect('/oauth/failure');
    }
    my $res = $consumer->request(
        method => 'GET',
        url    => 'http://api.twitter.com/1/account/verify_credentials.json',
        token  => $access_token,
        params => {
            token => $access_token,
        },
    );
    unless ($res->is_success) {
        $c->redirect('/oauth/failure');
    }
    my $content = $res->decoded_content;
    my $json = decode_json($content);

    my $id = $json->{id};
    Carp::croak("Can't get Twitter id!") unless defined $id;
    my $user = $db->single('user', {twitter_id => $id});
    unless ( $user ) {
        my $now = localtime;
        $user = $db->insert(
            'user',
            {
                twitter_id => $id,
                uuid       => $class->create_uuid,
                created_at => $now,
                updated_at => $now,
            }
        );
        $user->refetch;
    }
    $c->session->set('user_id',$user->id);
    my $token = $access_token->token;
    my $token_secret = $access_token->secret;
    my $now = localtime;
    $user->update(
        {
            screen_name  => $json->{screen_name},
            token        => $token,
            token_secret => $token_secret,
            updated_at   => $now,
        }
    );

    if ( $user->status eq 'authenticated' ) {
        $c->redirect('/user/register');
    }
    $c->redirect($back_to);
}

1;

