#!/bin/bash
#
name="garage"
#
# read io pin, and if it failed set it to -127
#
io=$(gpio read 4) || io=-127;
#
# address to one-wire sensor
#
sensorDir="/sys/bus/w1/devices";
sensorName=$(ls $sensorDir | grep 28);
sensorError=$?
#
# check if sensor is there
#
if [ -d "$sensorDir"/"${sensorName}" ] && [ "$sensorError" -eq 0 ] ; then
  #
  # convert temperature to a decimal number, with three decimals and a preceding zero if needed.
  #
  temperature=$(echo "scale=3; $(cat "$sensorDir"/"$sensorName"/temperature)/1000" | bc -l | awk '{printf "%.2f\n", $0}')
  #
  echo "{\"date\":\"$(date)\", \"sensor\":\"$sensorName\", \"temperature\": $temperature, \"power\": $(gpio read 3), \"daylight\": $(gpio read 4), \"light\": $(gpio read 5), \"name\":\"$name\" }"
  #
else
  #
  echo "{\"date\":\"$(date)\", \"temperature\": -100, \"power\": $(gpio read 3), \"light\": $(gpio read 5), \"name\":\"$name\" }"
  #
fi
