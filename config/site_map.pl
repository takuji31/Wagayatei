use strict;
use warnings;
use utf8;

# path => リンク先のパス
# label => リンクにする文字列
# cond_sub => 表示するかどうか判定するためのCodeRef 1で表示、0で非表示
return +{
    Character => [
        {
            path => '/character/',
            label => 'キャラクター一覧',
        },
        {
            path => '/character/add',
            label => 'キャラクター追加',
            cond_sub => sub{ shift->user ? 1:0 },
        },
        {
            path => '/character/my',
            label => '自分のキャラクター一覧',
            cond_sub => sub{ shift->user ? 1:0 },
        },
        {
            path => '/character/skill_list',
            label => 'スキル一覧',
        },
    ],
    Skill => [
        {
            path => '/character/',
            label => 'キャラクター一覧',
        },
        {
            path => '/character/add',
            label => 'キャラクター追加',
            cond_sub => sub{ shift->user ? 1:0 },
        },
        {
            path => '/character/my',
            label => '自分のキャラクター一覧',
            cond_sub => sub{ shift->user ? 1:0 },
        },
        {
            path => '/character/skill_list',
            label => 'スキル一覧',
        },
    ],
};

