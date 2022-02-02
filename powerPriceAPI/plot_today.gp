#!/usr/local/bin/gnuplot --persist

set print "-"
print "script name        : ", ARG0
print "first argument     : ", ARG1
print "second argument    : ", ARG2
print "number of arguments: ", ARGC 

set timefmt "%H"
set xtics format "%H"
set title "Nordpool Prices"
set ylabel "Price"
set xlabel "Hour"
set xrange[0:24]
set grid
set terminal png size 500,400
set output '/var/www/html/plot.png'
set style line 1 lc rgb 'black' pt 5   # square
plot ARG1 u 1:2 with lines title ARG1, ARG2 u 1:2 with points ls 1 title ARG2
quit

