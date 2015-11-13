set terminal png
set output "mat_mul.png"

set xlabel "matrix size"
set ylabel "multiplication time"
N=`awk 'NR==2 {print NF}' mat_mul.data`
plot for [i=2:N] "mat_mul.data" using 1:i with lines title columnheader
