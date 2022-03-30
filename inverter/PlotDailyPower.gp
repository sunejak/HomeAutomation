
set xdata time
set timefmt "%Y-%m-%dT%H:%M:%S"
set xtics format "%H:%M"
set title "Solar panel power"
set ylabel 'Watt'
set grid
set terminal png size 500,400
set output '/var/www/html/power.png'
plot "plot.data" using 1:2 lw 2 lc 'blue' with lines
quit