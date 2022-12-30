#!/bin/bash
#
# echo "Total number of arguments passed are: $#"
# $* is used to show the command line arguments
# echo "The arguments are: $*"
#
if [ -z "$1" ]; then
  echo "Provide a deviceName and a device Type"
  exit 1
fi
deviceName=$1
shift
if [ -z "$1" ]; then
  echo "Provide a device Type (1Wire, I2C, dummy)"
  exit 1
fi
deviceType=$1
shift
# find own IP address
ipaddress=$(hostname -I | cut -f1 -d ' ');
dateString=$(date);

#
if [[ $deviceType == "1Wire" ]]; then

  # The rest of the arguments are now pairs of pin names.
  #
  # use jq .io += [{"pin": 0}] to add array entries
  #
  # They are converted to a JSON array.
  #
  if [ -z "$1" ]; then
    echo "Provide a gpio pin number for pin A"
    exit 1
  fi
  pinA=$1
  stateA=$(gpio read $pinA);
  if [ -z "$2" ]; then
    echo "Provide a gpio pin name for pin A"
    exit 1
  fi
  labelA=$2
  if [ -z "$3" ]; then
    echo "Provide a gpio pin number for pin B"
    exit 1
  fi
  pinB=$3
  stateB=$(gpio read $pinB);
  if [ -z "$4" ]; then
    echo "Provide a gpio pin name for pin B"
    exit 1
  fi
  labelB=$4
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
  temperature=$(echo "scale=3; $(cat "$sensorDir"/"$sensorName"/temperature)/1000" | /usr/bin/bc -l | awk '{printf "%.2f\n", $0}');
else
  temperature=-100
fi
#
    jq -c --null-input --arg ip "$ipaddress" --arg date "$dateString" \
     --arg type "$deviceType" --arg name "$deviceName" --arg tmp "$temperature"\
     --arg ma "$stateA" --arg mb "$stateB" \
     '{"name": $name, "IP": $ip, "date": $date, "temperature": $tmp, "io": [{ "xyzA": $ma }, { "xyzB": $mb }], "type": $type }' \
     | sed "s/xyzA/$labelA/g" | sed "s/xyzB/$labelB/g"
#

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
  temperature=$(echo "scale=3; ($adjTmp * 0.1250) - $tmpNeg" | /usr/bin/bc | awk '{printf "%.2f\n", $0}')
  prev_temperature=$(tail -1 /mnt/ramdisk/last.json | jq -r .temperature)
  diff_temp=$(echo "scale=3; $temperature - $prev_temperature" | /usr/bin/bc | awk '{printf "%.2f\n", $0}')
    jq -c --null-input --arg ip "$ipaddress" --arg date "$dateString" \
     --arg type "$deviceType" --arg name "$deviceName" --arg tmp "$temperature" --arg prevtmp "$prev_temperature" \
     --arg difftmp "$diff_temp" \
     '{"name": $name, "IP": $ip, "date": $date, "temperature": $tmp, "prev": $prevtmp, "diff": $difftmp,"type": $type }'
exit 0

elif [[ $deviceType == "dummy" ]]; then
  jq -c --null-input --arg ip "$ipaddress" --arg date "$dateString" \
   --arg type "$deviceType" --arg name "$deviceName" \
   '{"name": $name, "IP": $ip, "date": $date, "type": $type}'
exit 0
fi

  jq -c --null-input --arg ip "$ipaddress" --arg date "$dateString" \
   --arg type "$deviceType" --arg name "$deviceName" \
   '{"name": $name, "IP": $ip, "date": $date, "type": $type, "error": "unknown device type"}'
exit 1
