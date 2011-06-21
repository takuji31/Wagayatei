package  Wagayatei::Web::C::Skill;
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
        return unless grep /^$action$/, qw(edit show);

        $c->redirect('/character/') unless $uuid;
        my $pc = $c->db->single(pc => {uuid => $uuid});
        $c->redirect('/character/') unless $pc;
        #他人のスキルは編集できんよ
        $c->redirect('/character/') if $pc->user_id ne $c->user->id && $action eq 'edit';
        $c->stash->{pc} = $pc;
        $c->stash->{genres} = [$c->db->search(genre => {},{order_by => {id => 'asc'}})->all];
        my $pc_skill_ranks = {};
        my $pc_skills = [$c->db->search(pc_skill => {pc_id => $pc->id},{order_by => {id => 'asc'}})->all];
        for my $pc_skill ( @$pc_skills ) {
            $pc_skill_ranks->{$pc_skill->skill->uuid} = $pc_skill->rank;
        }
        $c->stash->{pc_skills} = $pc_skills;
        $c->stash->{pc_skill_ranks} = $pc_skill_ranks;
    },
);

sub do_show {
    my ($class, $c, $uuid) = @_;
}

sub do_edit {
    my ($class, $c, $uuid) = @_;
    if( $c->req->is_post_request ) {
        my $pc = $c->stash->{pc};
        my $type = $pc->type;
        my $skills = $c->db->search(skill => {type_data => [{like => "%$type%"}, '[]']});
        my $pc_skills = $c->stash->{pc_skills};
        my $pc_skill_ranks = $c->stash->{pc_skill_ranks};
        my $update_skills = {};

        for my $pc_skill ( @$pc_skills ) {
            my $uuid = $pc_skill->skill->uuid;
            my $val = $c->req->param($uuid);
            if( defined $val && $val ne '' && $pc_skill->rank != $val ) {
                $pc_skill->update({rank => $val});
                $pc_skill_ranks->{$uuid} = $val;
            } else {
                $pc_skill->delete;
            }
            $update_skills->{$uuid} = 1;
        }

        my @records;
        for my $skill ( @{$skills->all} ) {
            my $uuid = $skill->uuid;
            my $val = $c->req->param($uuid);
            next if $update_skills->{$uuid};
            if( defined $val && $val ne '' ) {
                push @records,{
                    pc_id    => $pc->id,
                    skill_id => $skill->id,
                    rank     => $val,
                };
                $pc_skill_ranks->{$uuid} = $val;
            }
        }
        if ( @records ) {
            $c->db->bulk_insert(pc_skill => \@records);
        }
        $c->stash->{done} = 1;
    }

}

1;

