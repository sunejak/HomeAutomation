#!/bin/bash
#
# get data from fireplace, and format for gnuplot
#
fireplaceData=$(curl  -s 192.168.1.148/all_temperature.json )
if [ $? -ne 0 ] ; then
  echo "Could not access fireplace"
  exit 1;
fi

# readingTimes=$(echo $fireplaceData | jq .date  | cut -d' ' -f4)
# readingTemperature=$(echo $fireplaceData | jq  -r .temperature)

declare -a arrayTimes=($(echo $fireplaceData | jq .date  | cut -d' ' -f4))
declare -a arrayTemperature=($(echo $fireplaceData | jq  -r .temperature))
arrayLength=${#arrayTimes[@]}

rm plot.data

for (( i=0; i<${arrayLength}; i++ ));
do
  echo ${arrayTimes[$i]} ${arrayTemperature[$i]} >> plot.data
done
#
# create the plot
#
gnuplot -c plot_temperature.gp
#
echo Done at $(date)
