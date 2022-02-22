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
data=$( curl -fsS -w '%{http_code}' ${URL} > /mnt/ramdisk/tmp.tmp )
if [ $? -ne 0 ] ; then
  echo "Could not access: ${URL}"
  exit 1;
fi

today=$(grep $(date -I) /mnt/ramdisk/tmp.tmp)
if [ $? -ne 0 ] ; then
  echo "Could not find data"
  exit 1;
fi

peaktime=$( echo $today | cut -f1 -d ' ')
starttime=$(( peaktime - delta ))
stoptime=$(( peaktime + delta ))
#
now=$(date "+%s")
#
# date --date='@123'
#
# echo Time window from: $(date --date=@$starttime) to:  $(date --date=@$stoptime)
gpio mode 3 output
#
if [ $now -gt $starttime ] && [ $now -lt $stoptime ]; then
  echo Inside window $(date) Time window from: $(date --date=@$starttime) to:  $(date --date=@$stoptime)
  gpio write 3 1
  else
  echo Outside window $(date) Time window from: $(date --date=@$starttime) to:  $(date --date=@$stoptime)
  gpio write 3 0
fi
