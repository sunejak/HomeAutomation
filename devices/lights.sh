#!/bin/bash

if [ -z "$1" ]; then
  echo "Provide a JSON file"
  exit 1
fi
URL=$1

gpio mode 3 out
gpio mode 4 out

  diff=$(jq -r .diff "${URL}")
  diffValue=$(echo "scale=0; ${diff} * 100" | /usr/bin/bc -l | awk '{printf "%.0f\n", $0}')
  echo "$diffValue"

  if [[ $diffValue -gt 0 ]]; then
    gpio write 4 1
    gpio write 3 0
  fi

  if [[ $diffValue -lt 0 ]]; then
    gpio write 3 1
    gpio write 4 0
  fi

  if [[ $diffValue -eq 0 ]]; then
    gpio write 3 0
    gpio write 4 0
  fi
