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
    my ($self, $lat_lon) = @_;
    my $room_coords = $lat_lon ?
        $lat_lon : $self->lat . "," . $self->lon;

    my $room = $self->data->{rooms}->{$room_coords};

    return (
        $room,
        map { $_ } keys %{$room->{can_see}},
    ) if $room;
}

sub _get_room_exits {
    my $self = shift;
    my ($lat, $lon) = ($self->lat, $self->lon);
    my $exits = {};
    my @north = $self->_get_room_info(($lat+1) . "," . $lon);
    my @east  = $self->_get_room_info($lat . "," . ($lon+1));
    my @south = $self->_get_room_info(($lat-1) . "," . $lon);
    my @west = $self->_get_room_info($lat . "," . ($lon-1));

    if (defined $north[0]) { $exits->{north} = \@north }
    if (defined $east[0]) { $exits->{east}  = \@east }
    if (defined $south[0]) { $exits->{south}  = \@south }
    if (defined $west[0]) { $exits->{west}  = \@west }

    return $exits
        if keys %$exits > 0;
}

sub _can_see {
    my ($self, $thing, @can_see) = @_;
    for my $ob (@can_see) {
        if ($thing =~ /$ob/i) {
            if (length($thing) == length($ob)) {
                return $ob;
            }
        }
    }
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
        if (my $object = $self->_can_see($at, @can_see)) {
            say $room->{can_see}->{$object}->{look};
        }
        else {
            say "You look, but can't find '$at'";
        }
    }
    else {
        say "You are in " . $room->{title};
        if (@can_see > 0) {
            say "You can see: " . join(',', @can_see);
        }
        else {
            say "There doesn't seem to be anything in this room.";
        }
        if (my $exits = $self->_get_room_exits) {
            print "Obvious exits are: ";
            say join ', ', map { $_ } keys %$exits;
        }
        else {
            say "You see no obvious exits.";
        }
    }
}

sub read {
    my ($self, $at) = @_;
    my ($room, @can_see) = $self->_get_room_info();
    
    if ($at) {
        if (my $object = $self->_can_see($at, @can_see)) {
            say $room->{can_see}->{$object}->{read};
        }
        else {
            say "You can't read something that isn't there.";
        }
    }
    else {
        say "What are you trying to read?";
    }
}

sub north {
    my ($self) = @_;
    $self->lat($self->lat+1);
    $self->look;
}

sub south {
    my ($self) = @_;
    $self->lat($self->lat-1);
    $self->look;
}

sub east {
    my ($self) = @_;
    $self->lon($self->lon+1);
    $self->look;
}

sub west {
    my ($self) = @_;
    $self->lon($self->lon-1);
    $self->look;
}

1;

