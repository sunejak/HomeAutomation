#!/bin/bash
#
# to fetch data to make a daily for plot current power
#
resp=$(curl -s "http://192.168.1.23/all_inverter.json" )
if [ $? -ne 0 ] ; then
  echo "{ \"Error\" : \"Could not get data\" }"
  exit 1;
fi
#
echo "$resp" | grep -e "$(date -I)" | jq -r '.Body.Data.PAC.Value , .Head.Timestamp ' | paste - - -d' '
