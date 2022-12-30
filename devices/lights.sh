#!/bin/bash

gpio mode 3 out
gpio mode 4 out

while true

do


if [[ 'jq -r .diff temperature.json' -gt 0 ]]
then 
gpio write 4 1
gpio write 3 0
fi

if [[ 'jq -r .diff temperature.json' -lt 0 ]]
then
gpio write 3 1
gpio write 4 0
fi

if [[ 'jq -r .diff temperature.json' -eq 0 ]]
then
gpio write 3 0
gpio write 4 0
fi

sleep 10

done

