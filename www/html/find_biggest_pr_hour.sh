#!/bin/bash
#
#
location=driveway/02_Feb_2022/22/cam0_2022_Feb_22
#
echo "<!DOCTYPE html>"
echo "<html><body>"
echo "<h1>$location</h1>"

for j in {00..23}
do

for i in $(ls -S $location_$j* | head | sort);
do
  echo "<img src=\""$i"\" width=\"350\" height=\"350\">" ;

done
  echo "<p>$j</p>" ;
done

echo "</body></html>"