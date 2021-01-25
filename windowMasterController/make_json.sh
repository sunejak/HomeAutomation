#!/bin/bash
#
# convert temperature to a 3 decimal number
#
temperature=$(echo "scale=3; $(cat /sys/bus/w1/devices/28-3c01d607bdc0/temperature)/1000" | bc -l | awk '{printf "%.3f\n", $0}')
#
echo "{\"date\":\"$(date)\", \"temperature\": $temperature, \"motorA\": $(gpio read 28), \"motorB\": $(gpio read 29), \"name\":\"rp4\" }" 

