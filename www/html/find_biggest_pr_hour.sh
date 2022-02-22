#!/bin/bash
#
#
location="driveway/02_Feb_2022/22/cam0_2022_Feb_22"
#
echo "<!DOCTYPE html>"
echo "<html><body>"
echo "<h1>$location</h1>"

for j in {00..23}
do
 echo "<p>Hour: $j</p>"
 for i in $(ls -S ${location}_$j* | head | sort);
   do
     echo "<img src=\""$i"\" width=\"350\" height=\"350\">"
   done
done
echo "</body></html>"