#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw/min/;

my $k                = 10;
my $show_progress    = 1;
my $reflesh_interval = 0.5;
my $clear_console    = "\e[2J";
my $last_refleshed   = 0;
my %counts;

foreach my $arg (@ARGV) {
    if ( $arg =~ /^-(\d+)$/ ) {
        $k             = $1;
        $show_progress = $k > 0;
        next;
    }
}

sub create_progress_report {
    my $n      = @_ == 1 ? $_[0] : keys %counts;
    my @sorted = sort { $counts{$b} <=> $counts{$a} } keys %counts;
    my $result;
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
        my $n = min( ( $k, scalar keys %counts ) );
        print STDERR $clear_console . &create_progress_report($n);
    }
}

if ($show_progress) {
    print STDERR $clear_console;
}
print STDOUT &create_progress_report;
