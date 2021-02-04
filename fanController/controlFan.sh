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
startTime=$(date -d $2 '+%s');
stopTime=$(date -d $3 '+%s');
currentTime=$(date '+%s');
#
# check time window
#
if [ "$currentTime" -gt "$startTime" ] && [ "$currentTime" -lt "$stopTime" ]; then
#
# assuming one wire sensor
#
sensorDir="/sys/bus/w1/devices";
sensorName=$(ls $sensorDir | grep 28);
#
# check if sensor is present
#
if [ -d "$sensorDir"/"${sensorName}" ]; then
#
# get current temperature
#
temperature=$(cat "$sensorDir"/"$sensorName"/temperature);
echo Current temperature is: $temperature
#
fi

fi



