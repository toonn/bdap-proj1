#! /usr/bin/env perl
use strict;
use warnings;

my $dense_file = $ARGV[0];
# ARGV[1] is idf file, not needed because first line contains column names.
my $sparse_file = $ARGV[2];

open my $fh_dense, '<', $dense_file or die "Couldn't open $dense_file: $!\n";
open my $fh_sparse, '>', $sparse_file;

print $fh_sparse '@RELATION '."$dense_file\n\n";
my $column_names = <$fh_dense>;
chomp $column_names;
my @columns = split /, /, $column_names;
foreach my $column (@columns[0..$#columns-1]) {
  print $fh_sparse '@ATTRIBUTE '."$column NUMERIC\n";
}
print $fh_sparse '@ATTRIBUTE '."$columns[$#columns] {graphics, electronics}\n";
print $fh_sparse '@DATA'."\n";

while (my $row = <$fh_dense>) {
  chomp $row;
  my @values = split /, /, $row;

  print $fh_sparse '{';
  for my $index (0..$#values-1) {
    if ($values[$index]) {
      print $fh_sparse "$index $values[$index], ";
    }
  }
  print $fh_sparse "$#values $values[$#values]}\n";
}

close $fh_dense;
close $fh_sparse;
