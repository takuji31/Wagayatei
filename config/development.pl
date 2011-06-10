use strict;
use warnings;
use utf8;

use Wagayatei::Container;

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
            name             => '名前',
            password         => 'パスワード',
            password_confirm => 'パスワード（確認）',
            login_id         => 'ログインID',
            email            => 'メールアドレス',
            email_confirm    => 'メールアドレス（確認）',
        },
        message => {},
    },
};

