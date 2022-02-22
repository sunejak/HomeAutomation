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
count=$(echo $celestialEvents | jq '.times | length')
# echo $count
#
counter=0
while [ $counter -lt $count ]
do
  sunrise=$(echo $celestialEvents | jq -r .times[$counter].sun.sunrise )
  sunset=$(echo $celestialEvents | jq -r .times[$counter].sun.sunset )
  mySunrise=$(date -d $sunrise '+%s')
  mySunset=$(date -d $sunset '+%s')

  jq -c --null-input --arg mYrise "$mySunrise" --arg rise "$sunrise" --arg mYset "$mySunset" --arg set "$sunset" \
  '{"Rise": $mYrise, "Sunrise": $rise, "Set": $mYset, "Sunset": $set}'
((counter ++))
done
