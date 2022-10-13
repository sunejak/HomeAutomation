#!/bin/bash
#
if [ -z "$1" ]; then
  echo "Provide a URL and a number og hours"
  exit 1
fi
URL=$1
if [ -z "$2" ]; then
  echo "Provide how many hours to use"
  exit 1
fi
hours=$2
# create the request string
search="curl -s ${URL} | jq 'select(.date==\"$(date -I)\")'"
# make the call to fetch the data
response=$(eval $search )
if [ $? -ne 0 ] ; then
  echo "Could not access: ${URL}"
  exit 1;
fi
# pick out the hours to be used
sortedHours=$(echo $response | jq -r .sortedHour[0:"$hours"] | tr -d ',' | tr -d ']' | tr -d '[')
#
echo Hours to skip: $sortedHours
# iterate over them
n=0
for val in $sortedHours; do
  if [[ $val -eq $(date +%H) ]]
  then
    (( n++ ))
  fi
done
#
gpio mode 3 output
#
if [ $n -gt 0 ]; then
    echo Inside window $(date)
    gpio write 3 1
  else
    echo Outside window $(date)
    gpio write 3 0
fi
