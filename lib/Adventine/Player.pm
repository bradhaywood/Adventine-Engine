package Adventine::Player;

use 5.010;
use Moo;

has data => ( is => 'rw' );

# Latitude and Longitude, for navigation
has lat => ( is => 'rw', default => sub { 0 } );
has lon => ( is => 'rw', default => sub { 0 } );

# Player stats and name
has name        => ( is => 'rw', default => sub { "Anonymous" } );
has inventory   => ( is => 'rw', default => sub { [] } );

sub _get_room_info {
    my $self = shift;

    my $room_coords = $self->lat . "," . $self->lon;
    my $room = $self->data->{rooms}->{$room_coords};
    return (
        $room,
        map { $_ } keys %{$room->{can_see}},
    );
}

=head1 PLAYER COMMANDS

Each subroutine represents a player command

  Player Name> look
  Player Name> look a brown box

=cut

sub look {
    my ($self, $at) = @_;
    my ($room, @can_see) = $self->_get_room_info();
    
    # look at something, or around you if 
    # at is null
    if ($at) {
        # found it
        if (grep { $_ eq $at } @can_see) {
            say $room->{can_see}->{$at}->{look};
        }
        else {
            say "You look, but can't find '$at'";
        }
    }
    else {
        say "You are in " . $room->{title};
        say "You can see: " . join(',', @can_see);
    }
}

sub read {
    my ($self, $at) = @_;
    my ($room, @can_see) = $self->_get_room_info();
    
    if ($at) {
        if (grep { $_ eq $at } @can_see) {
            say $room->{can_see}->{$at}->{read};
        }
        else {
            say "You can't read something that isn't there.";
        }
    }
    else {
        say "What are you trying to read?";
    }
}

1;

