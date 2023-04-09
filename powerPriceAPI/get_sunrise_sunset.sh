#!/bin/bash
#
# Get celestialEvents for some days at Frosta church
#
# https://www.yr.no/api/v0/locations/1-218408/celestialevents?

if [ -z "$1" ]; then
  echo "Provide a URL"
  exit 1
fi
#
celestialEvents=$(curl -fsS  --header 'Accept: application/json' "$1")
if [ $? -ne 0 ] ; then
  echo "Could not access URL at $1"
  exit 1;
fi
# check number of entries
#
count=$(echo $celestialEvents | jq '.events | length')
# echo $count
#
counter=0
mySunrise=0
mySunset=0

while [ $counter -lt $count ]
do
  type=$(echo $celestialEvents | jq -r .events[$counter].type )
  body=$(echo $celestialEvents | jq -r .events[$counter].body )
#  echo $type
  if [ $type == "Set" ] && [ $body == "Sun" ];
  then
    sunset=$(echo $celestialEvents | jq -r .events[$counter].time )
    mySunset=$(date -d $sunset '+%s')
  fi

  if [ $type == "Rise" ] && [ $body == "Sun" ];
  then
    sunrise=$(echo $celestialEvents | jq -r .events[$counter].time )
    mySunrise=$(date -d $sunrise '+%s')
  fi

  if [ $mySunset -ne 0 ] && [ $mySunrise -ne 0 ] ;
  then
    jq -c --null-input --arg mYrise "$mySunrise" --arg rise "$sunrise" --arg mYset "$mySunset" --arg set "$sunset" \
    '{"Rise": $mYrise, "Sunrise": $rise, "Set": $mYset, "Sunset": $set}'
    mySunset=0
    mySunrise=0
  fi
((counter ++))
done
