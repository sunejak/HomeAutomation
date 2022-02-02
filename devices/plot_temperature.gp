set xdata time
set timefmt "%H:%M:%S"
set xtics format "%H:%M"
set title "Fireplace"
set ylabel 'Celsius'
set grid
set terminal png size 500,400
set output '/var/www/html/fireplace.png'
plot "plot.data" using 1:2 lw 2 lc 'blue' with lines
quit
