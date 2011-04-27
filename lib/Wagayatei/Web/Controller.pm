package  Wagayatei::Web::Controller;
use Chiffon::Core;
use parent qw/ Chiffon::Web::Controller /;
use Wagayatei::Container;
use Wagayatei::DB;


__PACKAGE__->add_trigger(
    before_action => sub{
        my ( $class, $c ) = @_;
        $c->stash->{site_title} = container('label')->{guild_name};
        $c->stash->{page_title} = $c->dispatch_rule->{action} . " | " . $c->dispatch_rule->{controller};
        my $db = Wagayatei::DB->get_db;
        my $user_id = $c->session->get('user_id');
        if ( defined $user_id ) {
            my $user = $db->single('user',{ id => $user_id });
            $c->stash->{user} = $user;
        }
    }, 

);

use Data::GUID;

sub create_uuid {
    Data::GUID->guid_hex;
}
1;

