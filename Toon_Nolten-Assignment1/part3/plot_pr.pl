#! /usr/bin/env perl
use strict;
use warnings;

my ($bayes, $smo, $png) = @ARGV;

system("gnuplot -e \"bayes='$bayes'; smo='$smo'; image_path='$png'\" precision_recall.gnuplot");
