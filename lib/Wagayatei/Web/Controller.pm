package  Wagayatei::Web::Controller;
use Chiffon::Core;
use parent qw/ Chiffon::Web::Controller /;
use Wagayatei::Container;


__PACKAGE__->add_trigger(
    before_action => sub{
        my ( $class, $c ) = @_;
        $c->stash->{site_title} = container('label')->{guild_name};
        $c->stash->{page_title} = $c->dispatch_rule->{action} . " | " . $c->dispatch_rule->{controller};
    }, 

);

use Data::GUID;

sub create_uuid {
    Data::GUID->guid_hex;
}
1;

