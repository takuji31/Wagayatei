use Chiffon::Core;
use Wagayatei::Container;
use Path::Class;

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
        guild_name        => '憩いの我が家亭',
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
        type_name => [
            H => '人間',
            E => 'エルフ',
            G => 'ジャイアント',
        ],
        skill_genre => [
            {
                key   => 'life',
                value => '生活',
            },
            {
                key   => 'combat',
                value => '戦闘',
            },
            {
                key   => 'magic',
                value => '魔法',
            },
            {
                key   => 'alchemy',
                value => '錬金術',
            },
            {
                key   => 'paladin',
                value => 'パラディン',
            },
            {
                key   => 'darkknight',
                value => 'ダークナイト',
            },
            {
                key   => 'beast',
                value => '野獣化',
            },
            {
                key   => 'god',
                value => '半神化',
            },
        ],
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

