package Wagayatei::Validator;
use strict;
use warnings;
use parent qw/ FormValidator::Lite /;

use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/ context valid_params /],
);

sub new {
    my ( $class, $req, $context ) = @_;

    my $self = $class->SUPER::new( $req );
    $self->context( $context ) if $context;
    $self->valid_params( {} );
    $self;
}

sub check {
    my $self = shift;

    my %args = @_;

    $self->SUPER::check(@_);
    return if $self->has_error;
    $self->valid_params->{$_} = 1 for ( keys %args );
}

sub valid_data {
    my $self = shift;

    die "invalid request" if $self->has_error;

    return {
        map { $_ => $self->{query}->param($_) }
          grep { defined $self->{query}->param($_) }
          keys %{ $self->valid_params }
    };
}

1;

