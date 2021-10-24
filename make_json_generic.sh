#!/bin/bash
#
if [ -z "$1" ]; then
  echo "Provide a device name"
  exit 1
fi
if [ -z "$2" ]; then
  echo "Provide a device type"
  exit 1
fi
#
name=$1
device=$2

if [ "$device" == "1Wire" ]; then
#
# read io pin, and if it failed set it to -100
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
if [ -d "$sensorDir"/"${sensorName}" ] && [ "$sensorError" -eq 0 ]; then
#
# convert temperature to a decimal number, with three decimals and a preceding zero if needed.
#
temperature=$(echo "scale=3; $(cat "$sensorDir"/"$sensorName"/temperature)/1000" | bc -l | awk '{printf "%.2f\n", $0}')
#
echo "{\"date\":\"$(date)\", \"type\":\"$device\", \"sensor\":\"$sensorName\", \"temperature\": $temperature, \"motorA\": $(gpio read 28), \"motorB\": $(gpio read 29), \"name\":\"$name\" }"
#
else
#
echo "{\"date\":\"$(date)\", \"temperature\": -100, \"motorA\": $(gpio read 28), \"motorB\": $(gpio read 29), \"name\":\"$name\" }"
#
fi
exit 0
fi

if [ "$device" == "I2C" ]; then
  readonly I2CAddress=0x48 # Slave address with A0, A1, and A2 set to 0v (ground).
  # for AT30TSE754A added precision is available by setting the precision bits
  # i2cset -y 1 $I2CAddress 0x01 0x0060 w
  tmp_raw=$(i2cget -y 1 $I2CAddress 0x00 w) # test values 0x200A and 0xE0F5
  # do som bit shuffling, swap lower byte with upper byte
  adj_neg=0
  adj_tmp=$(($(($tmp_raw >> 8)) | $(($tmp_raw << 8))))
  adj_tmp=$(($adj_tmp & 0xffff))

  echo $adj_tmp

  # Check if the MSB (of the word) is set to indicate a negative value
  if [[ $(($adj_tmp & 0x8000)) -eq 0x8000 ]]
  then
     adj_neg=256
  fi
  adj_tmp=$(($adj_tmp >> 5))
  temperature=$(echo "scale=4; ($adj_tmp * 0.1250) - $adj_neg" | bc )
  echo "{\"date\":\"$(date)\", \"type\":\"$device\", \"temperature\": $temperature, \"name\":\"$name\" }"
exit 0
fi


if [ "$device" == "dummy" ]; then
  echo dummy
exit 0
fi

echo "Unknown device " "$device"
exit 1
