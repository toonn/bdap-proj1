#! /usr/bin/env perl
use strict;
use warnings;

my ($train_file, $test_file, $naivebayes_file, $supportvector_file) = @ARGV;

sub precision_recall {
  my ($classifier, $file) = @_;
  my $pos_count = 0;
  my $pos_classified = 0;
  my @pos_classifieds;

  while ($classifier =~ /(1|2):.*(1|2):/g) {
    
    if ($1 == 1) { # positive example
      $pos_count += 1;
    }
    if ($2 == 1) { # positively classified
      $pos_classified += 1;
    }
    if ($1 == 1 && $2 == 1) { # True positive
      push @pos_classifieds, $pos_classified;
    }
  }

  open my $fh, '>', $file;
  print $fh "recall\tprecision\n";
  my $recall;
  my $precision;
  for my $index (0..$#pos_classifieds) {
    $recall = ($index + 1) / $pos_count;
    $precision = ($index + 1) / $pos_classifieds[$index];
    print $fh "$recall\t$precision\n";
  }
  close $fh;
}

# The weka commands did not work without weka.jar when I tested this on the
# computers in the computer labs.
print "Train and test Naive Bayes model\n";
my $bayes = `java -cp weka.jar weka.classifiers.bayes.NaiveBayes\\
 -K -t $train_file -T $test_file -p 0`;

precision_recall $bayes, $naivebayes_file;

print "Train and test Support Vector model\n";
my $smo = `java -cp weka.jar weka.classifiers.functions.SMO\\
 -t $train_file -T $test_file -p 0 -M`;

precision_recall $smo, $supportvector_file;
