#!/bin/bash
#
# read io pin, and if it failed set it to -100
#
io=$(gpio read 4) || io=-100;
#
# address to one-wire sensor
#
sensor=/sys/bus/w1/devices/28-3c01d6075f4c
#
# check if sensor is there
#
if [ -d ${sensor} ]; then
#
# convert temperature to a decimal number, with three decimals and a preceding zero if needed.
#
temperature=$(echo "scale=3; $(cat $sensor/temperature)/1000" | bc -l | awk '{printf "%.3f\n", $0}')
#
echo "{\"date\":\"$(date)\", \"temperature\": $temperature, \"fan\": $io, \"name\":\"matbod\" }"
#
else
#
echo "{\"date\":\"$(date)\", \"temperature\": -100, \"fan\": $io, \"name\":\"matbod\" }"
#
fi