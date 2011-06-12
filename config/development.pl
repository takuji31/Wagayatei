use strict;
use warnings;
use utf8;

use Wagayatei::Container;
use Wagayatei::Plugin::View;

my $home = container('home');
return +{
    app_name => 'wagayatei',
    view     => {
        'Chiffon::View::Xslate' => +{
            path      => $home->file('assets/template')->stringify,
            cache     => 1,
            cache_dir => '/tmp/wagayatei',
            syntax    => 'Kolon',
            type      => 'html',
            suffix    => '.html',
            function  => view_functions(),
        },
    },
    datasource => +{
        master => [
            'dbi:mysql:wagayatei_dev',
            'root',
            '',
            { RaiseError => 1, mysql_connect_timeout => 4, mysql_enable_utf8 => 1 },
        ],
    },
    hostname          => +{},
    plugins           => +{},
    validator_message => {
        param => {
            nick_name        => 'ニックネーム',
            name             => '名前',
            profile          => '紹介文',
        },
        message => {},
    },
    skill_max_rank => [
        '未実装', 'F', 'E', 'D', 'C', 'B', 'A', '9', '8', '7', '6',
        '5', '4', '3', '2', '1', '1', '段', '段', '3段'
    ],
    skill_rank => [
        '練習', 'F', 'E', 'D', 'C',      'B',
        'A',      '9', '8', '7', '6',      '5',
        '4',      '3', '2', '1', 'Master', '1段',
        '2段',   '3段'
    ],
    types => [
        {
            key  => 'H',
            name => '人間',
        },
        {
            key  => 'E',
            name => 'エルフ',
        },
        {
            key  => 'G',
            name => 'ジャイアント',
        },
    ],
    type_name => {
        H => '人間',
        E => 'エルフ',
        G => 'ジャイアント',
    },
    rank_name => {
        member => 'メンバー',
        master => 'ギルドマスター',
        sub    => 'サブマスター',
    },
};

