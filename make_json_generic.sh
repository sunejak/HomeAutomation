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
# find own IP address
ipaddress=$(hostname -I | cut -f1 -d ' ');
datestring=$(date);

#
if [[ $deviceType == "1Wire" ]]; then

  if [ -z "$3" ]; then
    echo "Provide a gpio pin number for pin A"
    exit 1
  fi
  pinA=$3
  if [ -z "$4" ]; then
    echo "Provide a gpio pin number for pin B"
    exit 1
  fi
  pinB=$4
#
# read io pin, and if it failed set it to -127
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
temperature=$(echo "scale=3; $(cat "$sensorDir"/"$sensorName"/temperature)/1000" | /usr/bin/bc -l | awk '{printf "%.2f\n", $0}')
#
echo "{\"date\":\"$(date)\", \"type\":\"$deviceType\", \"sensor\":\"$sensorName\", \"temperature\": $temperature, \"motorA\": $(gpio read $pinA), \"motorB\": $(gpio read $pinB), \"deviceName\":\"$deviceName\" }"
#
else
#
echo "{\"date\":\"$(date)\", \"temperature\": -100, \"motorA\": $(gpio read $pinA), \"motorB\": $(gpio read $pinB), \"deviceName\":\"$deviceName\" }"
#
fi
exit 0

elif [[ $deviceType == "I2C" ]]; then
  readonly I2CAddress=0x48 # I2C device address from "i2cdetect -y 1" command.
  # for AT30TSE754A added precision is available by setting the precision bits
  /usr/sbin/i2cset -y 1 $I2CAddress 0x01 0x0060 w
  tmpRaw=$(/usr/sbin/i2cget -y 1 $I2CAddress 0x00 w) # test values 0x200A and 0xE0F5
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
  temperature=$(echo "scale=3; ($adjTmp * 0.1250) - $tmpNeg" | /usr/bin/bc )
    jq -c --null-input --arg ip "$ipaddress" --arg date "$datestring" \
     --arg type "$deviceType" --arg name "$deviceName" --arg tmp "$temperature"\
     '{"name": $name, "IP": $ip, "date": $date, "temperature": $tmp, "type": $type}'
exit 0

elif [[ $deviceType == "dummy" ]]; then
  jq -c --null-input --arg ip "$ipaddress" --arg date "$datestring" \
   --arg type "$deviceType" --arg name "$deviceName" \
   '{"name": $name, "IP": $ip, "date": $date, "type": $type}'
exit 0
fi

  jq -c --null-input --arg ip "$ipaddress" --arg date "$datestring" \
   --arg type "$deviceType" --arg name "$deviceName" \
   '{"name": $name, "IP": $ip, "date": $date, "type": $type, "error": "unknown device type"}'
exit 1
