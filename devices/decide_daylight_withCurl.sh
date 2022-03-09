#!/bin/bash
#
if [ -z "$1" ]; then
  echo "Provide a URL"
  exit 1
fi
URL=$1
#
response=$(curl -s ${URL})
if [ $? -ne 0 ] ; then
  echo "Could not access: ${URL}"
  exit 1;
fi
#
today=$(echo $response | tr ' ' '\n' | grep $(date -I) )
if [ $? -ne 0 ] ; then
  echo "Could not find data for today"
  exit 1;
fi

startTime=$( date -d $(echo $today | jq -r .Sunrise ) "+%s")
stopTime=$( date -d $(echo $today | jq -r .Sunset ) "+%s")
#
now=$(date "+%s")
#
# date --date='@123'
#
# echo Time window from: $(date --date=@$startTime) to:  $(date --date=@$stopTime)
gpio mode 4 output
#
if [ $now -gt $startTime ] && [ $now -lt $stopTime ]; then
  echo Inside window $(date) Sunrise from: $(date --date=@$startTime) Sunset at:  $(date --date=@$stopTime)
  gpio write 4 1
  else
  echo Outside window $(date) Sunrise from: $(date --date=@$startTime) Sunset at:  $(date --date=@$stopTime)
  gpio write 4 0
fi
