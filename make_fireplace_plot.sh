
#!/bin/bash
#
# get data from fireplace, and format for gnuplot
#
curl  -s 192.168.1.148/all_temperature.json | jq -c 'del(.name) | del(.IP) | del(.type) | del(.prev)' | cut -d'"' -f4,8 | tr '"' ' ' | cut -d' ' -f5,8 > plot.data
#
# create the plot
#
gnuplot -c plot_temperature.gp
#
echo Done at $(date)
