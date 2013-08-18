package Adventine::Engine;

use 5.010;
use Moo;
use Adventine::Player;

# Player object
has player  => ( is => 'rw', default => sub { Adventine::Player->new } );
has data    => ( is => 'rw' );

## FOR DEBUG
#use Data::Dumper;

sub run {
    my $self  = shift;
    my $world = shift;
    eval "use Adventine::World::$world";
    if ($@) {
        say "Problem loading world $world: $@";
    }

    $world = "Adventine::World::$world";
    my $world_object = $world->new;
    $self->data($world_object->data);
   
    # update player data so they have a copy, too
    $self->player->data($self->data); 
        
    ## FOR DEBUG
    #say Dumper($self->data);

    # print the intro to our game and look around
    say $self->data->{intro};
    $self->player->look;

    $self->_prompt();
}

sub _prompt {
    my $self = shift;
    my @commands = qw/
        look read north south
    /;

    my $p = $self->player->name . "> ";
    print $p;
    while(my $line = <STDIN>) {
        chomp $line;
        my ($cmd, @args) = split ' ', $line;
        if (grep { $_ eq $cmd } @commands) {
            if (@args) {
                $self->player->$cmd(join(' ', @args));
            }
            else {
                $self->player->$cmd;
            }
        }
        else {
            say $self->player->name . ": Uh.. I'm not sure how to do that.";
        }

        print $p;
    } 
}

1;
