set terminal png
set output "mat_mul.png"
set title "Blocked Matrix Multiplication"

set xlabel "Matrix Dimension"
set ylabel "Multiplication Time"
N=`awk 'NR==2 {print NF}' mat_mul.data`
plot for [i=2:N] "mat_mul.data" using 1:i with lines title columnheader
