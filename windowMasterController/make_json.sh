#!/bin/bash
#
name="matbod"
#
# read io pin, and if it failed set it to -100
#
io=$(gpio read 4) || io=-127;
#
# address to one-wire sensor
#
sensorDir="/sys/bus/w1/devices";
sensorName=$(ls $sensorDir | grep 28);
#
# check if sensor is there
#
if [ -d "$sensorDir"/"${sensorName}" ]; then
#
# convert temperature to a decimal number, with three decimals and a preceding zero if needed.
#
temperature=$(echo "scale=3; $(cat "$sensorDir"/"$sensorName"/temperature)/1000" | bc -l | awk '{printf "%.2f\n", $0}')
#
echo "{\"date\":\"$(date)\", \"sensor\":\"$sensorName\", \"temperature\": $temperature, \"fan\": $io, \"name\":\"$name\" }"
#
else
#
echo "{\"date\":\"$(date)\", \"temperature\": -127, \"fan\": $io, \"name\":\"$name\" }"
#
fi