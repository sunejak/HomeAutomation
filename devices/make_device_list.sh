#!/bin/bash
#
# get the registered devices from access log.
#
# each device needs to have this in their crontab
#
# 0 * * * *   curl http://192.168.1.23/dummy.txt?device=name ;
#
# 192.168.1.232 - - [28/Jul/2021:07:00:02 +0200] "GET /dummy.txt?device=garage HTTP/1.1" 200 234 "-" "curl/7.64.0"
# pick out IP address and name
#
device=$(grep dummy /var/log/nginx/access.log | cut -d' ' -f1,4,7 | grep :$(date +%H):00 | cut -d' ' -f1,3 | sed "s#/dummy.txt?device=##" | sort -k 2 );
#
echo '[';
## declare an array variable
declare -a array=($device)
# get length of an array
arrayLength=${#array[@]}
# use for loop to read all values and indexes
for (( i=0; i<${arrayLength}; i=i+2 ));
do
  echo "{\"address\": \"${array[$i]}\" ,\"name\": \"${array[$i+1]}\" }"
  let "n = $i + 2" ;
  if [ ! $n -eq ${arrayLength} ]
    then
      echo ",";
  fi
done
echo "]";

