#!/usr/bin/perl

use strict;
use warnings;

my $topk             = 10;
my $show_progress    = 1;
my $reflesh_interval = 0.5;

foreach my $arg (@ARGV) {
    if ( $arg =~ /^-(\d+)$/ ) {
        $topk = $1;
        next;
    }

    if ( $arg =~ /^(?:-np|--no-progress)$/ ) {
        $show_progress = 0;
        next;
    }

    if ( $arg =~ /^-t=(\d(?:\.\d)?)$/ ) {
        $reflesh_interval = $1;
        next;
    }
}

my %counts      = ();
my $total       = 0;
my $last_update = time();

sub print_sorted {
    my $n      = $_[0];
    my $stderr = $_[1];
    if ( $n == -1 ) {
        $n = keys %counts;
    }
    my @sorted = sort { $counts{$b} <=> $counts{$a} } keys %counts;
    foreach my $key ( splice @sorted, 0, $n ) {
        if ($stderr) {
            print STDERR "$key: $counts{$key}\n";
        }
        else {
            print STDOUT "$key: $counts{$key}\n";
        }
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
    $total++;
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
