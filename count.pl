use strict;
use warnings;

my %counts = ();
my $total  = 0;

sub showTopItems {
    my @sorted = sort { $counts{$b} <=> $counts{$a} } keys %counts;
    foreach my $key ( splice @sorted, 0, 10 ) {
        print "$key: $counts{$key}\n";
    }
}

while (<STDIN>) {
    chomp;
    $total++;
    $counts{$_}++;

    if ( $total % 1000000 == 0 ) {
        print "\033[2J";    # clear console
        print "\e[10A";     # up 10
        &showTopItems();
    }
}

&showTopItems();
