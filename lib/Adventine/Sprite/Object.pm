package Adventine::Sprite::Object;

use Moo;

has sprite => ( is => 'rw' );

sub spawn {
    my ($self, $args) = @_;
    return bless $args, __PACKAGE__;
}

1;
