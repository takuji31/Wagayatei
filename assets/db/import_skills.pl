use strict;
use warnings;

use lib '/home/takuji/project/Wagayatei/lib/';
use Wagayatei::DB;
use YAML::Syck;
use Wagayatei;
use Data::Dumper;
use Time::Piece;
use Data::GUID;

my $path = Wagayatei->base_dir->subdir('assets/db');
my $genres = LoadFile($path->file('genre.yaml')->stringify);
my $skills = LoadFile($path->file('skill.yaml')->stringify);

my $db = Wagayatei::DB->get_db;
my $txn = $db->txn_scope;
$db->do('TRUNCATE genre');
$db->do('TRUNCATE skill');
my $now = localtime;
for my $genre ( @$genres ) {
    my $genre_row = $db->insert('genre',$genre);
    for my $skill ( @{$skills->{$genre->{name_en}}} ) {
        $db->insert('skill',{%$skill, uuid => Data::GUID->guid_hex, genre_id => $genre_row->id, created_at => $now, updated_at => $now});
    }
}
$txn->commit;
