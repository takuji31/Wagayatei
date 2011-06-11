package  Wagayatei::Validator::User;
use strict;
use warnings;
use parent 'Wagayatei::Validator';

sub register {
    my $class = shift;

    $class->check(
        nick_name => ['NOT_NULL'],
        "name" => ['NOT_NULL'],
        "profile" => ['NOT_NULL'],
    );
}

1;
