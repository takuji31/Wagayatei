package Wagayatei::ValidatorLoader;
use strict;
use warnings;
use utf8;
use 5.10.1;

use Class::Load qw/load_class/;
use Data::Validator;

sub new {
    state $validator = Data::Validator->new(
        base_class  => {
            isa => 'Str',
            default => sub { my $c = __PACKAGE__; $c =~ s/Loader$//; $c } 
        },
        constraints => {
            isa => 'ArrayRef',
            default => sub { my $c = __PACKAGE__; $c =~ s/::ValidatorLoader$//; load_class($c); $c->config->{constraints} || [] }
        },
        message => {
            isa => 'HashRef',
            default => sub { my $c = __PACKAGE__; $c =~ s/::ValidatorLoader$//; load_class($c); $c->config->{validator_message} || {} }
        },
    )->with('Method','AllowExtra');
    my ( $class, $args ) = $validator->validate(@_);
    return bless { %$args }, $class;
}

sub get {
    my ( $self, $class_name, $params ) = @_;

    $class_name = $self->{base_class} . "::$class_name";
    load_class( $class_name );
    my $validator = $class_name->new($params);
    $validator->load_constraints( @{ $self->{constraints} } );
    $validator->set_param_message( %{$self->{message}->{param}} );
    $validator->load_function_message('ja');
    return $validator;
}

1;

