#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw/min/;

my $topk             = 10;
my $show_progress    = 1;
my $reflesh_interval = 0.5;
my $clear_console    = "\033[2J";
my %counts           = ();
my $last_refleshed   = 0;

foreach my $arg (@ARGV) {
    if ( $arg =~ /^-(\d+)$/ ) {
        $topk          = $1;
        $show_progress = $topk == 0 ? 0 : 1;
        next;
    }
}

sub generate_sorted_result {
    my $n      = $_[0] < 0 ? scalar keys %counts : $_[0];
    my @sorted = sort { $counts{$b} <=> $counts{$a} } keys %counts;
    my $result = "";
    foreach my $key ( splice @sorted, 0, $n ) {
        $result .= "$key: $counts{$key}\n";
    }
    return $result;
}

while (<STDIN>) {
    chomp;
    $counts{$_}++;
    my $current = time();
    if ( $show_progress && $current - $last_refleshed > $reflesh_interval ) {
        $last_refleshed = $current;
        my $n = min( ( $topk, scalar keys %counts ) );
        print STDERR $clear_console;
        print STDERR "\e[${n}A";    # up n lines
        print STDERR &generate_sorted_result($topk);
    }
}

if ($show_progress) {
    print STDERR $clear_console;
}
print STDOUT &generate_sorted_result(-1);
