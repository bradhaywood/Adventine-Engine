package Adventine::World::ExampleWorld;

use Moo;
extends 'Adventine::Base';
extends 'Adventine::Sprite';

sub data {
    my $self = shift;
    my $sprite = Adventine::Sprite->new;
    return {
        intro => $self->_intro(),
        rooms => {
            '0,0' => {
                title   => "Starting Room",
                can_see => {
                    'A brown box' => $self->sprite(
                        title  => "A brown box",
                        look   => "Looks like an ordinary box to me.",
                        grab   => "It's a bit big for your backpack unfortunately..",
                        attack => "You leave the poor defenseless box alone.",
                        talk   => "People might think you're crazy.. you know, talking to boxes and all",
                        read   => "There appears to be some scrawlings on the side: \"Perl is great\". Hmm, enlightening.",
                    ),
                    'sign'     => $self->sprite(
                        title  => "sign",
                        look   => "Yep, it's definitely a sign.. perhaps you should read it *HINT HINT*",
                        grab   => "It won't budge.",
                        attack => "You punch the sign with your fists. Pfft, vandal. Won't your parents be proud.",
                        talk   => "Are you sure you want to talk to a sign..?",
                        read   => $self->sign($self->_first_sign()),
                    ),
                },
            },
            '1,0' => {
                title => "First North Room",
                can_see => {},
            },
            '0,1' => {
                title => "First East Room",
                can_see => {
                    'a window' => $self->sprite(
                        title  => 'a window',
                        look   => 'You look through the window and see a meadow outside.',
                        grab   => "You can't really grab a window, can you?",
                        attack => "The window doesn't smash. It appears you lack the upper-body strength.",
                        talk   => "You have a very one-sided conversation with a window",
                        read   => "There's no words on the window to read",
                    ),
                },
            },
            '-1,1' => {
                title => "South-East Room",
                can_see => {},
            }
        },
    };
}

sub _intro {
    return q{
        Welcome to ExampleWorld. This is just a sample of the worlds you can create
        in Adventine. It doesn't do a lot, but shows you how to create your own using nothing 
        but Perl!. Enjoy your stay here :-)
    };
}

sub _first_sign {
    return q{
        Congratulations, you just read your first sign!
        Signs are automagically asciified into a box for you so you just 
        have to worry about the text. Just wrap your string in $self->sign 
        which is extended from Adventine::Sprite
    };
}

1;
