use strict;
use warnings;

my $topk        = 10;
my %counts      = ();
my $total       = 0;
my $last_update = time();
my $no_progress = 1;

sub showTopk {
    my @sorted = sort { $counts{$b} <=> $counts{$a} } keys %counts;
    foreach my $key ( splice @sorted, 0, $topk ) {
        print "$key: $counts{$key}\n";
    }
}

sub clear_console {
    print "\033[2J";
}

sub up {
    print "\e[${topk}A";
}

while (<STDIN>) {
    chomp;
    $total++;
    $counts{$_}++;

    if ( !$no_progress && time() - $last_update > 0.5 ) {
        $last_update = time();

        &clear_console();
        &up();
        &showTopk();
    }
}

if ( !$no_progress ) {
    &clear_console();
}
&showTopk();
