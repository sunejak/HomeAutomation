#!/bin/bash
#
# get the registered devices from access log.
#
# 192.168.1.232 - - [28/Jul/2021:07:00:02 +0200] "GET /dummy.txt?device=garage HTTP/1.1" 200 234 "-" "curl/7.64.0"
# pick out IP address and name
#
device=$(grep dummy /var/log/apache2/access.log | cut -d' ' -f1,7 | sort -n | uniq | sed "s#/dummy.txt?device=##");
#
echo '[';
## declare an array variable
declare -a array=($device)
# get length of an array
arrayLength=${#array[@]}
# use for loop to read all values and indexes
for (( i=0; i<${arrayLength}; i=i+2 ));
do
  echo "\"IP\": \"${array[$i]}\" , \"name\": \"${array[$i+1]}\", "
done
#
echo ']';

