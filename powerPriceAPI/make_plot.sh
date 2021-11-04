#!/bin/bash
#
cat plotdata-$(date -I).in | sort -n -k2 | head -1 > extremes
cat plotdata-$(date -I).in | sort -n -k2 | tail -1 >> extremes
#
gnuplot -c plot_today.gp plotdata-$(date -I).in extremes 
