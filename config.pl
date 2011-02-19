use Chiffon::Core;
use Wagayatei::Container;

my $home = container('home');
return +{
    common => {
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
            master => +{
                dsn => 'dbi:mysql:wagayatei_dev;user=root',
            },
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
    },
    dev => {
        datasource => +{ 
            master => +{
                dsn => 'dbi:mysql:wagayatei_dev;user=root',
            },
        },
    },
    production => {
        datasource => +{
            master => +{
                dsn => 'dbi:mysql:wagayatei;user=root',
            },
        },
    },
};

