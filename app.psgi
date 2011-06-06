use Wagayatei::Web;
use Wagayatei::Container;
use Plack::Builder;
use Plack::Session::Store::Cache::KyotoTycoon;

my $home = container('home');
builder {
    enable 'ReverseProxy';
    enable 'StackTrace';
    enable 'Scope::Container';
    enable 'Session',
        store => Plack::Session::Store::Cache::KyotoTycoon->new;
    Wagayatei::Web->app;
};

