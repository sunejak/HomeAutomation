#!/bin/bash
#
# Fan control script
#
# using pin 4 for relay
#
if [ -z "$1" ]; then
   echo "Provide a temperature "
   exit 1
fi
if [ -z "$2" ]; then
   echo "Provide a start time (hh:mm)"
   exit 1
fi
if [ -z "$3" ]; then
   echo "Provide a stop time (hh:mm)"
   exit 1
fi
limit=$1;
startTime=$2;
stopTime=$3;
#
# assuming one wire sensor
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
temperature=$(echo "scale=3; $(cat "$sensorDir"/"$sensorName"/temperature)/1000" | bc -l | awk '{printf "%.2f\n", $0}');
echo Current temperature is: $temperature
#
fi



