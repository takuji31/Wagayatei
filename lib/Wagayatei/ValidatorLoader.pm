package Wagayatei::ValidatorLoader;
use strict;
use warnings;
use utf8;

use Class::Load qw/load_class/;
use Smart::Args;

sub new {
    my $class => 'ClassName',
    my $base_class => { isa => 'Str', default => 'Wagayatei' },
    my $constraints => { isa => 'ArrayRef' };
    return bless {
        base_class => $base_class,
        constraints => $constraints,
    }, $pkg;
}

sub get {
    my ( $self, $class_name, $params ) = @_;

    $class_name = $self->{base_class} . "::$class_name";
    load_class( $class_name ) or die "Validation Class $class_name not found";
    my $validator = $class_name->new($request);
    $validator->load_constraints( @{ $self->{constraints} } );
    $validator->set_param_message( %{$self->{message}->{param}} );
    $validator->validator->load_function_message('ja');
    return $validator;
}

1;

