#!/bin/bash
#
# typical usage would be: ./make_json_device roomName 28 29
#
# creates a JSON response with temperature and io pins
#
# {"date":"Sun 25 Jul 2021 07:17:02 PM CEST", "sensor":"28-3c01d0753607", "temperature": 23.69, "pinA": 0, "pinB": 0, "name":"Here" }
#
if [ -z "$1" ]; then
  echo "Provide a device name"
  exit 1
fi
nameDevice=$1
if [ -z "$2" ]; then
  echo "Provide a gpio pin number for pin A"
  exit 1
fi
pinA=$2
if [ -z "$3" ]; then
  echo "Provide a gpio pin number for pin B"
  exit 1
fi
pinB=$3
#
# read io pin, and if it failed set it to -100
#
# io=$(gpio read 4) || io=-127;
#
# address to one-wire sensor
#
sensorDir="/sys/bus/w1/devices";
sensorName=$(ls $sensorDir | grep 28);
sensorError=$?
#
# check if sensor is there
#
if [ -d "$sensorDir"/"${sensorName}" ] && [ "$sensorError" -eq 0 ]; then
#
# convert temperature to a decimal number, with three decimals and a preceding zero if needed.
#
  temperature=$(echo "scale=3; $(cat "$sensorDir"/"$sensorName"/temperature)/1000" | bc -l | awk '{printf "%.2f\n", $0}')
#
  echo "{\"date\":\"$(date)\", \"sensor\":\"$sensorName\", \"temperature\": $temperature, \"pinA\": $(gpio read "$pinA"), \"pinB\": $(gpio read "$pinB"), \"name\":\"$nameDevice\" }"
#
else
#
  echo "{\"date\":\"$(date)\", \"temperature\": -100, \"motorA\": $(gpio read "$pinA"), \"motorB\": $(gpio read "$pinB"), \"name\":\"$nameDevice\" }"
#
fi
