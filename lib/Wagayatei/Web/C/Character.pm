package  Wagayatei::Web::C::Character;
use strict;
use warnings;

use parent qw/ Wagayatei::Web::Controller /;
use Wagayatei::Container;

our $CHARACTER_ORDER = [
    {
        #マスター、サブマスを優先
        rank => 'desc',
    },
    {
        #メインキャラを優先
        main_fg => 'asc',
    },
    {
        #登録順に表示
        id => 'asc',
    },
];

__PACKAGE__->add_trigger(
    before_action => sub {
        my ($class, $c) = @_;
        my $action = $c->action;
        #特定のアクション以外はスルー
        return unless grep /^$action$/, qw(add my edit delete);

        #ログインしてなかったらリダイレクト
        $c->redirect('/character/') unless $c->user;
        #登録がまだのユーザーはリダイレクト
        #$c->redirect('/character/') if ( $c->user->status eq 'authenticated' || $c->user->status eq 'created' );
        $c->redirect('/character/') if ( $c->user->status eq 'authenticated' );
    },
);

__PACKAGE__->add_trigger(
    before_action => sub {
        my ($class, $c, $uuid) = @_;
        my $action = $c->action;
        #特定のアクション以外はスルー
        return unless grep /^$action$/, qw(edit delete);

        $c->redirect('/character/') unless $uuid;
        my $pc = $c->db->single(pc => {uuid => $uuid, user_id => $c->user->id});
        $c->redirect('/character/') unless $pc;
        $c->stash->{pc} = $pc;
    },
);

sub do_index {
    my ( $class, $c ) = @_;
    my $page = $c->req->param('page') || 1;

    #キャラクター一覧を取ってくる
    my ( $pcs, $pager ) = $c->db->search_with_pager(
        'pc' => {
            status => 'public',
        },
        {
            page => $page,
            rows => 10,
            order_by => $CHARACTER_ORDER,
        }
    );
    $c->stash->{pcs}   = $pcs;
    $c->stash->{pager} = $pager;
}

sub do_my {
    my ( $class, $c ) = @_;

    $c->redirect('/character/') unless $c->user;

    #キャラクター一覧を取ってくる
    #そんないないしページングしなくてもいいよね
    my $pcs = $c->db->search(
        'pc' => {
            status => 'public',
            user_id => $c->user->id
        },
        {
            order_by => $CHARACTER_ORDER,
        },
    );
    $c->stash->{pcs}   = $pcs->all;
}

sub do_show {
    my ($class, $c, $uuid) = @_;
    $c->redirect('/') unless $uuid;
    my $pc = $c->db->single('pc', {uuid => $uuid});
    $c->redirect('/character/') unless $pc;
    $c->stash->{pc} = $pc;
}


sub do_add {
    my ( $class, $c ) = @_;
    if( $c->req->is_post_request ) {
        my $validator = $c->validator("Character");
        $validator->add;
        if( $validator->has_error ) {
            $c->stash->{validator} = $validator;
        } else {
            my $db = Wagayatei::DB->get_db;
            $db->insert(
                'pc' => {
                    %{$validator->valid_data},
                    user_id => $c->user->id,
                    main_fg => 'no',
                    status => 'public',
                }
            );
            $c->redirect('/character/my');
        }
    }

}

sub do_edit {
    my ($class, $c, $uuid) = @_;
    my $pc = $c->stash->{pc};
    if( $c->req->is_post_request ) {
        my $validator = $c->validator("Character");
        $validator->edit;
        if( $validator->has_error ) {
            $c->stash->{validator} = $validator;
        } else {
            $pc->update($validator->valid_data);
            $c->stash->{done} = 1;
        }
    }

}

sub do_delete {
    my ($class, $c, $uuid) = @_;
    my $pc = $c->stash->{pc};
    $c->redirect('/character/my') if $pc->main_fg eq 'yes';
    if( $c->req->is_post_request ) {
        $pc->delete;
        $c->db->delete(pc_skill => {pc_id => $pc->id});
        $c->redirect('/character/my?delete=done');
    }

}

sub do_skill_list {
    my ( $class, $c ) = @_;
    my $genres = $c->db->search('genre',{},{order_by => {id => 'asc'}});
    $c->stash->{genres} = $genres->all;
}

1;

