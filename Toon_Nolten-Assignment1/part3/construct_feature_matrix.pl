#! /usr/bin/env perl
use strict;
use warnings;

use File::Basename;

my $graphics_path = $ARGV[0];
my $electronics_path = $ARGV[1];
my $idf_file = $ARGV[2];
my $tf_idf_file = $ARGV[3];

sub term_freq {
  my ($doc) = @_;
  my %term_freq;

  open my $fh_doc, '<', $doc or die "Couldn't open $doc: $!";
  while (my $line = <$fh_doc>) {
    chomp $line;
    $line = lc $line;
    $line =~ tr/a-z //dc;
    my @terms = split(' ', $line); # ' ' has special meaning: all whitespace
    foreach my $term (@terms) {
      $term_freq{$term} += 1;
    }
  }
  close $fh_doc;

  return \%term_freq;
}

sub doc_tf_idf {
  my ($term_freq_hashes_ref, $term_idf_ref) = @_;
  my %tf_idf;

  foreach my $doc (keys %$term_freq_hashes_ref) {
    foreach my $term (keys %{$term_freq_hashes_ref->{$doc}}) {
      $tf_idf{$doc}{$term} =
        $term_freq_hashes_ref->{$doc}{$term} * ($term_idf_ref->{$term} // 0);
    }
  }

  return \%tf_idf;
}


my $term_freqs_ref = {};
my %term_idf;
my $tf_idf_ref = {};
my %doc_class;

sub write_tf_idf {
  my ($fh_tf_idf, $tf_idf_ref) = @_;

  print $fh_tf_idf 'Document, ' . join(', ', sort keys %term_idf) . ', Class'
                    . "\n";
  my @ordered_terms = sort keys %term_idf;
  foreach my $doc (keys %$tf_idf_ref) {
    print $fh_tf_idf $doc . ', ';

    foreach my $term (@ordered_terms) {
      print $fh_tf_idf ($tf_idf_ref->{$doc}{$term} // 0) . ', ';
    }

    print $fh_tf_idf $doc_class{$doc} . "\n";
  }
} 

print 'Read idf' . "\n";
open my $fh_idf, '<', $idf_file or die "Couldn't open $idf_file: $!\n";
while (my $line = <$fh_idf>) {
  chomp $line;
  my @keyvalue = split /, /, $line;
  $term_idf{$keyvalue[0]} = $keyvalue[1];
}
close $fh_idf;

print 'Calculate term frequencies' . "\n";
foreach my $doc (<$graphics_path/*>) {
  $doc_class{basename $doc} = 'graphics';
  $term_freqs_ref->{basename $doc} = term_freq $doc;
}
foreach my $doc (<$electronics_path/*>) {
  $doc_class{basename $doc} = 'electronics';
  $term_freqs_ref->{basename $doc} = term_freq $doc;
}
print 'Calculate tf-idf' . "\n";
$tf_idf_ref = doc_tf_idf $term_freqs_ref, \%term_idf;

print 'Write tf-idf' . "\n";
open my $fh_tf_idf, '>', $tf_idf_file;
write_tf_idf $fh_tf_idf, $tf_idf_ref;
close $fh_tf_idf;
