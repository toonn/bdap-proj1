set title "Precision-Recall Curve"
set terminal png
set output image_path

set xlabel "Recall"
set ylabel "Precision"
set size square
plot [0:1] [0:1] bayes using 1:2 title "Naive Bayes" with lines, \
                 smo using 1:2 title "Support Vector" with lines lw 3
