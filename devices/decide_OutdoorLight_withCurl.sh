#!/bin/bash
#
# ./decide_OutdoorLights_withCurl.sh http://192.168.1.26/suntime.json "15:00 today" "01:00 tomorrow"
#
# 00:00 -> on until 1:00 -> off until 5:00 -> on until sunrise -> off until sunset -> on until 23:59
#
if [ -z "$1" ]; then
  echo "Provide a URL for sunset data"
  exit 1
fi
URL=$1
#
if [ -z "$2" ]; then
  echo "Provide a begin time, when lights can turn on"
  exit 1
fi
offNightTime=$(date --date="$2" "+%s") # 1:00
#
if [ -z "$3" ]; then
  echo "Provide an end time, when lights must turn off"
  exit 1
fi
onMorningTime=$(date --date="$3" "+%s") # 5:00
#
# fetch sunrise and sunset times, use RAM disk on pi.
#
response=$(curl -s ${URL})
if [ $? -ne 0 ]; then
  echo "Could not access: ${URL}"
  exit 1
fi
#
today=$(echo $response | tr ' ' '\n' | grep $(date -I) | tail -1 )
if [ $? -ne 0 ]; then
  echo "Could not find data for today"
  exit 1
fi

echo $today

sunsetTime=$(date -d $(echo $today | jq -r .Sunset) "+%s")
sunriseTime=$(date -d $(echo $today | jq -r .Sunrise) "+%s")
#
now=$(date "+%s")
#
gpio mode 5 output
turnOn=0

# keep light on from midnight until given time
if [ $now -lt $offNightTime ]; then
  #  echo before 1:00
  turnOn=1
fi
# turn on light in the morning until sunrise
if [ $now -gt $onMorningTime ] && [ $now -lt $sunriseTime ]; then
  turnOn=1
  #  echo after 5:00 before sunrise
fi
# turn on light at sunset
if [ $now -gt $sunsetTime ]; then
  turnOn=1
  #  echo after sunset
fi

if [ $turnOn -eq 1 ]; then
  echo Lights on $(date --date=@$now) : $(date --date=@$offNightTime) , $(date --date=@$onMorningTime) , The Sun: $(date --date=@$sunriseTime) , $(date --date=@$sunsetTime)
  gpio write 5 1
else
  echo Lights off $(date --date=@$now) : $(date --date=@$offNightTime) , $(date --date=@$onMorningTime) , The Sun: $(date --date=@$sunriseTime) , $(date --date=@$sunsetTime)
  gpio write 5 0
fi
