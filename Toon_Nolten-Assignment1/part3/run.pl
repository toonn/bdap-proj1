#!/usr/bin/perl

# Your task is to create all the Perl scripts that are executed below (so you should not make changes to this file). 
# Note: it is assumed that the 20newsgroups folder is located in the directory from which the script is executed.


# Computing the idf values for all the terms in the training set.
# param 1: folder of training documents from the graphics class
# param 2: folder of training documents from the electronics class
# param 3: file containing resulting idf values
system("perl compute_idf.pl 20newsgroups/20news-bydate-train/comp.graphics 20newsgroups/20news-bydate-train/sci.electronics idf.txt");

# Constructing the dense term-document matrix. One matrix is constructed for the training set, and one for the test set.
# param 1: folder of training documents from the graphics class
# param 2: folder of training documents from the electronics class
# param 3: file containing the previously computed idf values
# param 4: resulting term-document matrix
system("perl construct_feature_matrix.pl 20newsgroups/20news-bydate-train/comp.graphics 20newsgroups/20news-bydate-train/sci.electronics idf.txt feature_matrix_train.txt");
system("perl construct_feature_matrix.pl 20newsgroups/20news-bydate-test/comp.graphics 20newsgroups/20news-bydate-test/sci.electronics idf.txt feature_matrix_test.txt");

# Converting the dense matrices to the sparse ARFF format. 
# param 1: dense matrix
# param 2: term idfs, you can use the term names to specify the attribute names in the ARFF file header
# param 3: sparse matrix
system("perl dense_to_sparse.pl feature_matrix_train.txt idf.txt feature_matrix_train.arff");
system("perl dense_to_sparse.pl feature_matrix_test.txt idf.txt feature_matrix_test.arff");

# Constructing the classifiers and making predictions.
# param 1: sparse matrix representing training data
# param 2: sparse matrix representing test data
# param 3: predictions of the Naive Bayes classifier
# param 4: predictions of the Support Vector classifier
system("perl predict.pl feature_matrix_train.arff feature_matrix_test.arff predictions_naivebayes.txt predictions_smo.txt");

# Constructing the Precision-Recall curve.
# param 1: predictions of the Naive Bayes classifier
# param 2: predictions of the Support Vector classifier
# param 3: resulting png file
system("perl plot_pr.pl predictions_naivebayes.txt predictions_smo.txt pr.png");

