#!/bin/bash
#
if [ -z "$1" ]; then
  echo "Provide a URL"
  exit 1
fi
URL=$1
#
data=$( curl -fsS -w '%{http_code}' ${URL} > /mnt/ramdisk/sun.tmp )
if [ $? -ne 0 ] ; then
  echo "Could not access: ${URL}"
  exit 1;
fi

today=$(grep $(date -I) /mnt/ramdisk/sun.tmp)
if [ $? -ne 0 ] ; then
  echo "Could not find data"
  exit 1;
fi

starttime=$(echo $today | cut -d ' ' -f1)
stoptime=$(echo $today | cut -d ' ' -f4)
#
now=$(date "+%s")
#
# date --date='@123'
#
# echo Time window from: $(date --date=@$starttime) to:  $(date --date=@$stoptime)
gpio mode 4 output
#
if [ $now -gt $starttime ] && [ $now -lt $stoptime ]; then
  echo Inside window $(date) Sunrise from: $(date --date=@$starttime) Sunset at:  $(date --date=@$stoptime)
  gpio write 4 1
  else
  echo Outside window $(date) Sunrise from: $(date --date=@$starttime) Sunset at:  $(date --date=@$stoptime)
  gpio write 4 0
fi
