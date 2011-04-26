use Wagayatei::Web;
use Wagayatei::Container;
use Plack::Builder;
use Plack::Session::Store::Cache::KyotoTycoon;

my $home = container('home');
builder {
    enable 'ReverseProxy';
    enable 'Static',
        path => qr{^/(img/|js/|css/|favicon\.ico)},
        root => $home->file('assets/htdocs')->stringify;
    enable 'StackTrace';
    enable 'Scope::Container';
    enable 'Session',
        store => Plack::Session::Store::Cache::KyotoTycoon->new;
    Wagayatei::Web->app;
};

