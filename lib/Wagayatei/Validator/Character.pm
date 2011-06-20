package  Wagayatei::Validator::Character;
use strict;
use warnings;
use parent 'Wagayatei::Validator';

sub add {
    my $class = shift;

    $class->check(
        name      => ['NOT_NULL'],
        profile   => ['NOT_NULL'],
        type      => [[CHOICE => qw(H E G)]],
    );
}

1;
