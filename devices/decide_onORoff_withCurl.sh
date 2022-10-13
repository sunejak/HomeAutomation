#!/bin/bash
#
if [ -z "$1" ]; then
  echo "Provide a URL and a delta time"
  exit 1
fi
URL=$1
if [ -z "$2" ]; then
  echo "Provide a time delta in hours"
  exit 1
fi
hours=$2
delta=$(echo "scale=0; (${hours} * 3600)/1" | bc )
#
response=$(curl -s ${URL})
if [ $? -ne 0 ] ; then
  echo "Could not access: ${URL}"
  exit 1;
fi
#
today=$(echo $response | sed "s/}/}\n/g" | grep $(date -I) | tail -1 )
if [ -z "$today" ] ; then
  echo "Could not find data for today ( $today )"
  exit 1;
fi
# pick out the maxHour
#
# curl -v http://192.168.1.26/electric.json | jq '. | select(.date=="2022-03-10") | .maxHour '
#
maxHour=$( echo $today | jq -r .maxHour)
#
# calculate when in seconds, compensate for time band
#
peakTime=$(echo "scale=0; ($maxHour * 3600 + 0.5 * 3600)/1" | bc )
now=$(date "+%s")
#
# start of the day in seconds
#
morning=$(date -d $(date -I) "+%s")
#
startTime=$(( morning + peakTime - delta ))
stopTime=$(( morning + peakTime + delta ))
#
# echo Time window from: $(date --date=@$startTime) to:  $(date --date=@$stopTime)
gpio mode 3 output
#
if [ $now -gt $startTime ] && [ $now -lt $stopTime ]; then
  echo Inside window $(date) Time window from: $(date --date=@$startTime) to:  $(date --date=@$stopTime)
  gpio write 3 1
  else
  echo Outside window $(date) Time window from: $(date --date=@$startTime) to:  $(date --date=@$stopTime)
  gpio write 3 0
fi
