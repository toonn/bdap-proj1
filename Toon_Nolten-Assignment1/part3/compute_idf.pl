#! /usr/bin/env perl
use strict;
use warnings;

use File::Basename;

my $N = 0;
my %term_count;
foreach my $file (<20news-bydate/20news-bydate-train/*/*>) {
    $N += 1;
    my %term_set;

    open my $fh_count, '<', $file or die "Couldn't open $file: $!";
    while (my $line = <$fh_count>) {
        chomp $line;
        my @terms = split(' ', $line);
        foreach my $term (@terms) {
            $term_set{$term} = ();
        }
    }
    close $fh_count;

    foreach my $term (keys %term_set) {
        $term_count{$term} += 1;
    }
}

my %term_idf;
open my $fh_idf, '>', '20newsgroups.idf';
foreach my $term (sort (keys %term_count)) {
    $term_idf{$term} = log($N/$term_count{$term}) / log(2);
    print $fh_idf $term . ', ' . $term_idf{$term} . "\n";
}
close $fh_idf;

open my $tf_idf, '>', '20newsgroups_train.tf-idf';
print $tf_idf 'name, ' . join(', ', sort (keys %term_idf)) . ', class' . "\n";
foreach my $file (<20news-bydate/20news-bydate-train/*/*>) {
    my %term_freq;
    my $row = basename($file) . ', ';
    
    open my $fh_read, '<', $file or die "Couldn't open $file: $!";
    while (my $line = <$fh_read>) {
        chomp $line;
        my @terms = split(' ', $line);
        foreach my $term (@terms) {
            $term_freq{$term} += 1;
        }
    }
    close $fh_read;

    foreach my $term (sort (keys %term_idf)) {
        $row  = $row . ($term_freq{$term} * $term_idf{$term}) . ', ';
    }

    $row = $row . (index($file, 'graphics') != -1 ? 'graphics' : 'electronics');
    print $tf_idf $row . "\n";
}
close $tf_idf;
