#!/bin/bash
#
# Get data for today at Frosta church
#
# https://www.yr.no/api/v0/locations/1-218408/celestialevents?

if [ -z "$1" ]; then
  echo "Provide a URL"
  exit 1
fi
#
data=$(curl -fsS  --header 'Accept: application/json' $1)
if [ $? -ne 0 ] ; then
  echo "Could not access $1"
  exit 1;
fi
count=$(echo $data | jq '.times | length')
# echo $count
#
counter=0
while [ $counter -lt $count ]
do
  sunrise=$(echo $data | jq .times[$counter].sun.sunrise | tr -d '"')
  sunset=$(echo $data | jq .times[$counter].sun.sunset | tr -d '"')
  my_sunrise=$(date -d $sunrise '+%s')
  my_sunset=$(date -d $sunset '+%s')
  echo $my_sunrise Sunrise: $sunrise $my_sunset Sunset: $sunset
((counter ++))
done
