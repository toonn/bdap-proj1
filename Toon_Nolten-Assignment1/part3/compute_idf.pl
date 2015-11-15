#! /usr/bin/env perl
use strict;
use warnings;

use File::Basename;

my @paths = @ARGV[0..$#ARGV-1];
my $idf_file = $ARGV[$#ARGV];

sub term_occurrence {
  my ($doc) = @_;
  my %term_occur;

  open my $fh_doc, '<', $doc or die "Couldn't open $doc: $!";
  while (my $line = <$fh_doc>) {
    chomp $line;
    $line = lc $line;
    $line =~ tr/a-z //dc;
    my @terms = split(' ', $line); # ' ' has special meaning: all whitespace
    foreach my $term (@terms) {
      $term_occur{$term} = ();
    }
  }
  close $fh_doc;

  return \%term_occur;
}

sub term_idf {
  my ($term_occurrence_hashes_ref) = @_;
  my %term_idf;

  foreach my $hash (values %$term_occurrence_hashes_ref) {
    foreach my $term (keys %$hash) {
      $term_idf{$term} += 1;
    }
  }

  my $N = scalar keys %$term_occurrence_hashes_ref;
  foreach my $term (keys %term_idf) {
    $term_idf{$term} = log($N / $term_idf{$term}) / log(2);
  }

  return \%term_idf;
}

my $term_occurrence_train_ref = {};
my $term_idf_ref = {};

print 'Calculate term occurrence for training set' . "\n";
foreach my $path (@paths) {
  foreach my $doc (<$path/*>) {
    $term_occurrence_train_ref->{basename $doc} = term_occurrence $doc;
  }
}
print 'Calculate idf' . "\n";
$term_idf_ref = term_idf $term_occurrence_train_ref;

print 'Write idf' . "\n";
open my $fh_idf, '>', $idf_file;
foreach my $term (sort keys %$term_idf_ref) {
  print $fh_idf $term . ', ' . $term_idf_ref->{$term} . "\n";
}
close $fh_idf;
