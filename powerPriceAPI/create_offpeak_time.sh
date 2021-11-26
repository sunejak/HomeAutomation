#!/bin/bash
#
if [ -z "$1" ]; then
  echo "Provide a data input file"
  exit 1
fi
#
# check if file exist
#
if [ ! -f "$1" ]; then
  echo "File does not exist: $1"
  exit 1
fi
#
# Get the location for data
#
location=$(jq -r .data.Rows[0].Columns[3].Name "$1" )
#
if [ "$location" != "Tr.heim" ]; then
  echo "No data for Trondheim" "$location"
  exit 1
fi
data=$(jq .data "$1");
#
# Get the date for the data
#
today=$(echo $data | jq -r .Rows[0].StartTime | cut -c-10 )
#
# Then pick out the value pr hour and convert NOK/MWh to øre/kWh and add 25% tax
#
rm plotdata-"$today".in
dataset=$(for i in {0..23}; do
  war=$(echo $data | jq -r .Rows[$i].Columns[3].Value  |  tr ',' '.' | tr -d ' ')
  war10=$(echo "scale=2; $war*1.25/10" | bc)
  echo $i $war10 >> plotdata-"$today".in  ;
  done )
#
# find lowest price hour
#
# low_price_hour=$(for i in {0..23}; do echo $(echo $data | jq -r .data.Rows[$i].Columns[3].Value ) $i ; done | sort -n | head -1 | cut -d' '  -f2)
#
# find highest price hour
#
high_price_hour=$(for i in {0..23}; do echo $(echo $data | jq  -r .Rows[$i].Columns[3].Value ) $i ; done | sort -n | tail -1 | cut -d ' '  -f2)
# echo Høy time: $high_price_hour;
high_price=$(echo $data | jq -r .Rows[$high_price_hour].Columns[3].Value  | tr -d ' ')
# echo Høy pris: $high_price;
#
# calculate delta in seconds
#
delta=$((high_price_hour * 3600))
#
# calculate time window  since 1970
#
my_time=$(date -d $today '+%s')
new_time=$(( my_time + delta ))
#
window=$(date -d @$new_time)
#
echo $new_time $window $location $high_price_hour $high_price $today
