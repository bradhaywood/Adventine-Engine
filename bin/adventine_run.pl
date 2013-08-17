#!/usr/bin/perl -I lib/

use warnings;
use strict;
use 5.010;

use Adventine::Engine;

if (@ARGV) {
    my $adv = Adventine::Engine->new;
    $adv->run($ARGV[0]);
}
else {
    say "Usage: $0 <world plugin>";
    say "ie: $0 ExampleWorld";
    exit 1;
}
