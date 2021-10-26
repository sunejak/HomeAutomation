#!/bin/bash
#
if [ -z "$1" ]; then
  echo "Provide a deviceName"
  exit 1
fi
if [ -z "$2" ]; then
  echo "Provide a deviceType (1Wire, I2C, dummy)"
  exit 1
fi
#
deviceName=$1
deviceType=$2

if [ "$deviceType" == "1Wire" ]; then
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
echo "{\"date\":\"$(date)\", \"type\":\"$deviceType\", \"sensor\":\"$sensorName\", \"temperature\": $temperature, \"motorA\": $(gpio read 28), \"motorB\": $(gpio read 29), \"deviceName\":\"$deviceName\" }"
#
else
#
echo "{\"date\":\"$(date)\", \"temperature\": -100, \"motorA\": $(gpio read 28), \"motorB\": $(gpio read 29), \"deviceName\":\"$deviceName\" }"
#
fi
exit 0
fi

if [ "$deviceType" == "I2C" ]; then
  readonly I2CAddress=0x48 # I2C device from "i2cdetect -y 1" command.
  # for AT30TSE754A added precision is available by setting the precision bits
  # i2cset -y 1 $I2CAddress 0x01 0x0060 w
  tmpRaw=$(i2cget -y 1 $I2CAddress 0x00 w) # test values 0x200A and 0xE0F5
  # do some bit shuffling, swap lower byte with upper byte
  tmpNeg=0
  adjTmp=$(($(($tmpRaw >> 8)) | $(($tmpRaw << 8))))
  adjTmp=$(($adjTmp & 0xffff))
  # Check if the MSB (of the word) is set to indicate a negative value
  if [[ $(($adjTmp & 0x8000)) -eq 0x8000 ]]
  then
     tmpNeg=256
  fi
  adjTmp=$(($adjTmp >> 5))
  temperature=$(echo "scale=4; ($adjTmp * 0.1250) - $tmpNeg" | bc )
  echo "{\"date\":\"$(date)\", \"type\":\"$deviceType\", \"temperature\": $temperature, \"deviceName\":\"$deviceName\" }"
exit 0
fi

if [ "$deviceType" == "dummy" ]; then
  echo "{\"date\":\"$(date)\", \"type\":\"$deviceType\", \"deviceName\":\"$deviceName\" }"
exit 0
fi

echo "{\"date\":\"$(date)\", \"type\":\"$deviceType\", \"error\":\"unknown device type\" }"
exit 1
