#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';

my $topk             = 10;
my $show_progress    = 1;
my $reflesh_interval = 0.5;

foreach my $arg (@ARGV) {
    if ( $arg =~ /^-(\d+)$/ ) {
        $topk = $1;
        if ( $topk == 0 ) {
            $show_progress = 0;
        }
        next;
    }

    if ( $arg =~ /^-t=(\d(?:\.\d)?)$/ ) {
        $reflesh_interval = $1;
        next;
    }
}

my %counts      = ();
my $last_update = time();

sub print_sorted {
    my $n      = $_[0];
    my $stderr = $_[1];
    if ( $n == -1 ) {
        $n = keys %counts;
    }

    # NOTE: This line may be inefficient if $n << keys %counts
    my @sorted = sort { $counts{$b} <=> $counts{$a} } keys %counts;

    my $result = "";
    foreach my $key ( splice @sorted, 0, $n ) {
        $result .= "$key: $counts{$key}\n";
    }

    if ($stderr) {
        print STDERR $result;
    }
    else {
        print STDOUT $result;
    }
}

sub clear_console {
    print STDERR "\033[2J";
}

sub up {
    my $n = $_[0];
    print STDERR "\e[${n}A";
}

while (<STDIN>) {
    chomp;
    $counts{$_}++;

    my $current_time = time();
    if ( $show_progress && $current_time - $last_update > $reflesh_interval ) {
        $last_update = $current_time;

        &clear_console();
        my $n           = $topk;
        my $counts_size = keys %counts;
        if ( $counts_size < $n ) {
            $n = $counts_size;
        }
        &up($n);
        &print_sorted( $topk, 1 );
    }
}

if ($show_progress) {
    &clear_console();
}
&print_sorted( -1, 0 );
