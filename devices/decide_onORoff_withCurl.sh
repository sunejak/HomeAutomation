#!/bin/bash
#
if [ -z "$1" ]; then
  echo "Provide a time delta in hours"
  exit 1
fi
hours=$1
delta=$(echo "scale=0; (${hours} * 3600)/1" | bc )
#
if [ -z "$2" ]; then
  echo "Provide a URL"
  exit 1
fi
URL=$2
#
response=$(curl -s ${URL})
if [ $? -ne 0 ] ; then
  echo "Could not access: ${URL}"
  exit 1;
fi
#
today=$(echo $response | sed "s/}/}\n/g" | grep $(date -I) )
if [ -z "$today" ] ; then
  echo "Could not find data for today ( $today )"
  exit 1;
fi
# pick out the maxHour
#
maxHour=$( echo $today | jq -r .maxHour)
#
# calculate when in seconds, compensate for time band
#
peaktime=$(echo "scale=0; ($maxHour * 3600 + 0.5 * 3600)/1" | bc )
now=$(date "+%s")
#
# start of the day in seconds
#
morning=$(date -d $(date -I) "+%s")
#
starttime=$(( morning + peaktime - delta ))
stoptime=$(( morning + peaktime + delta ))
#
echo Time window from: $(date --date=@$starttime) to:  $(date --date=@$stoptime)
gpio mode 3 output
#
if [ $now -gt $starttime ] && [ $now -lt $stoptime ]; then
  echo Inside window $(date) Time window from: $(date --date=@$starttime) to:  $(date --date=@$stoptime)
  gpio write 3 1
  else
  echo Outside window $(date) Time window from: $(date --date=@$starttime) to:  $(date --date=@$stoptime)
  gpio write 3 0
fi
