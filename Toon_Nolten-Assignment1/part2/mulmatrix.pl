#!/usr/bin/perl
use strict;
use warnings;

# param 1: file name 
# param 2-N: different block sizes

open my $gnuplot_data, '>', './mat_mul.data';
print $gnuplot_data "n\tnaive\t" . join("\t", @ARGV[1..$#ARGV]) . "\n";

open my $fh, '<', $ARGV[0] or die "Cannot read '$ARGV[0]': $!\n";

while (my $problem = <$fh>) {
    chomp $problem;
    my @timings;
    my @args = split(' ', $problem);
    my $result = `./matrix_multiplication naive $args[0] $args[1] $args[2]`;
    $result =~ /time: (\d+\.?\d*)/;
    $timings[0] = $1;
    foreach my $block_size (@ARGV[1..$#ARGV]) {
        my $result =
            `./matrix_multiplication blocked $args[0] $args[1] $args[2] $block_size`;
        $result =~ /time: (\d+\.?\d*)/;
        push @timings, $1;
    }
    my $data = $args[0] . "\t" . join("\t", @timings) . "\n";
    print $gnuplot_data $data;
}

close $gnuplot_data;
close $fh;

`gnuplot mat_mul.gnuplot`;
