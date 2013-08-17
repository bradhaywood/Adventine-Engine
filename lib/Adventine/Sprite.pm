package Adventine::Sprite;

use Moo;
use Adventine::Sprite::Object;

use Text::ASCIITable;

has sprites => ( is => 'rw', default => sub { [] } );

sub sprite {
    my ($self, %args) = @_;
    my @required = qw/title look grab attack talk/;
    for (@required) {
       if (not exists $args{$_}) {
           die "Sprite expects: " . join(", ", @required) . "\n";
       }
   }

   my $spawn = Adventine::Sprite::Object->spawn(\%args);
   push @{$self->sprites}, $spawn; 
   return $spawn;
}

sub sign {
    my ($self, $str) = @_;
    my $table = Text::ASCIITable->new({ headingText => "Sign" });
    $table->setCols('');
    for my $line (split /\r\n|\n/, $str) {
        $table->addRow($line);
    }

    return $table;
}

1;
