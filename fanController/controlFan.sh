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
#
# calculate the limit, without decimals.
#
limit=$(echo "$1 * 1000" | bc -l | awk '{printf "%.0f\n", $0}' );
startTime=$(date -d "$2" '+%s');
stopTime=$(date -d "$3" '+%s');
currentTime=$(date '+%s');
#
# Set pin for output mode
#
gpio mode 4 out
#
# check if we are inside the time window
#
if [ "$currentTime" -gt "$startTime" ] && [ "$currentTime" -lt "$stopTime" ]; then
  #
  # assuming one wire sensor
  #
  sensorDir="/sys/bus/w1/devices";
  sensorName=$(ls ${sensorDir} | grep 28);
  #
  # check if sensor is present
  #
  if [ -d "$sensorDir"/"${sensorName}" ]; then
    #
    # get current temperature
    #
    temperature=$(cat "${sensorDir}"/"${sensorName}"/temperature);
    #
    # above limit
    #
    if [ "$temperature" -gt "$limit" ]; then
      gpio write 4 1
    else
      gpio write 4 0
    fi
  else
    gpio write 4 0
  fi
else
  gpio write 4 0
fi


