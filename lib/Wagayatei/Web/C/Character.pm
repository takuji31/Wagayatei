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
        return unless grep /^$action$/, qw(add add_confirm add_do add_done my edit edit_confirm edit_do edit_done delete delete_do delete_done );

        #ログインしてなかったらリダイレクト
        $c->redirect('/character/') unless $c->user;
        #登録がまだのユーザーはリダイレクト
        $c->redirect('/character/') unless ( $c->user->status eq 'authenticated' || $c->user->status eq 'created' );
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

sub do_skill_list {
    my ( $class, $c ) = @_;
    my $genres = $c->db->search('genre',{},{order_by => {id => 'asc'}});
    $c->stash->{genres} = $genres->all;
}

=pod
sub create : Local : Args(0) {
    my ( $self, $c ) = @_;

    my $types      = container('conf')->{types};
    my $type_names = container('conf')->{type_name};
    $c->stash->{types}      = $types;
    $c->stash->{type_names} = $type_names;
    my $type = $c->req->param('type');
    if ($type) {
        $c->stash->{type_name} = $type_names->{$type};
        $c->stash->{type}      = $type;
    }

    if ( $c->req->param('character_create_skill_input') ) {

        #バリデーションしてスキル入力画面へ
        my $validator = container('validator')->get( 'Character', $c->req );
        $validator->create;
        if ( !$validator->has_error ) {
            my $type = $c->req->param('type');
            $c->stash->{type_name} = $type_names->{$type};
            $c->stash->{type}      = $type;
            $c->go('create_skill_input');
        }
        else {
            $c->stash->{validator} = $validator->get_error_messages;
            $c->forward('Mabinogi::View::TT');
            $c->fillform;
        }

    }
    if ( $c->req->param('character_create_confirm') ) {

        #確認画面
        $c->go('create_confirm');
    }
    if ( $c->req->param('character_create_do') ) {
        $c->go('create_do');
    }

}

sub create_skill_input : Private {
    my ( $self, $c ) = @_;

    my $type = $c->stash->{type};

    #スキル一覧を取得
    $type = $c->req->param('type');
    my $skills = model('Skill')->search(
        { type_data => [ { like => "%$type%" }, '[]' ], },
        { order_by => [ { 'genre_id' => 'asc' }, { 'id' => 'asc' } ], }
    );
    if ($skills) {
        $c->stash->{skills} = $skills;
    }
    $c->forward('Mabinogi::View::TT');
    $c->fillform;
}

sub create_confirm : Private {
    my ( $self, $c ) = @_;

    #入力されたスキルの一覧を取得する
    my $skill_keys = $self->get_skill_keys($c);
    $c->stash->{skill_keys} = $skill_keys;

    #スキル一覧を取得
    my $type   = $c->req->param('type');
    my $skills = model('Skill')->search(
        { type_data => [ { like => "%$type%" }, '[]' ], },
        { order_by => [ { 'genre_id' => 'asc' }, { 'id' => 'asc' } ], }
    );
    if ($skills) {
        $c->stash->{skills} = $skills;
    }
    $c->forward('Mabinogi::View::TT');
    $c->fillform;
}

sub create_do : Private {
    my ( $self, $c ) = @_;

    my $data = {
        name   => $c->req->param('name'),
        status => 'public',
    };

    # XXX 一時的にUserIDを入れるなど
    $data->{user_id} = 1;

    model('User')->get_db->txn_scope( $data->{user_id} );
    my $pc          = model('Pc')->create($data);
    my $skill_keys  = $self->get_skill_keys($c);
    my $skill_ranks = $self->get_skill_ranks($c);
    for my $key (@$skill_keys) {
        my $rank = $skill_ranks->{$key};
        ( my $skill_id = $key ) =~ s/rank_//;
        model('PcSkill')->create(
            {   pc_id    => $pc->id,
                skill_id => $skill_id,
                rank     => $rank,
            }
        );
    }
    model('User')->get_db->txn_commit( $data->{user_id} );
    $c->res->redirect('/character');

}

sub get_skill_keys : Private {
    my ( $self, $c ) = @_;
    my $params         = $c->req->params;
    my @param_keys     = keys %$params;
    my @all_skill_keys = grep /^rank_/, @param_keys;
    map { $_ =~ s/^rank_([0-9]+)$/$1/ } @all_skill_keys;
    @all_skill_keys = sort { $a <=> $b } @all_skill_keys;
    map { $_ = 'rank_' . $_ } @all_skill_keys;
    my @skill_keys = ();

    for my $key (@all_skill_keys) {

        #空文字の場合はそのスキルは選択されていない
        if ( $params->{$key} ne '' ) {
            push @skill_keys, $key;
        }
    }
    return \@skill_keys;
}

sub get_skill_ranks : Private {
    my ( $self, $c ) = @_;
    my $skill_keys = $self->get_skill_keys($c);
    my $params     = $c->req->params;
    for my $key (@$skill_keys) {

        #空文字の場合はそのスキルは選択されていない
        if ( $params->{$key} eq '' ) {
            delete $params->{$key};
        }
    }
    return $params;
}

sub my : Local : Args(0) {
    my ( $self, $c ) = @_;

    #XXX 仮にユーザーとってくる
    my $user = model('User')->lookup_by_id(1);
    if ($user) {
        my $pcs = $user->pc;
        $c->stash->{pcs}   = $pcs->iter;
        $c->stash->{pager} = $pcs->pager;
    }

}

sub skill_list : Local : Args(0) {
    my ( $self, $c ) = @_;

    my $genres
        = model('Genre')->search( {}, { order_by => { id => 'asc' }, } );
    if ($genres) {
        $c->stash->{genres} = $genres->iter;
    }

}

sub auto : Private {
    my ( $self, $c ) = @_;
    $c->stash->{display_local_menu} = 1;
    $c->stash->{menu_type}          = 'character';

}
=cut

1;

