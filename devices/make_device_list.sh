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
cat /var/log/nginx/access.log | jq -Rn 'reduce (inputs | capture("^(?<ip>\\S+).*device=(?<name>[^ &?\"]+)")) as $item ( {}; .[$item.ip] = $item ) | [.[]]'
