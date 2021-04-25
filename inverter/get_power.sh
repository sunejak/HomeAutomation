#!/bin/bash
#
#
# 
# The StatusCode Field is only reported as numerical value.
#
# 0 - 6 Startup 
# 7     Running
# 8     Standby 
# 9     Boot loading
# 10    Error 
#
resp=$(curl -s "http://192.168.1.108/solar_api/v1/GetInverterRealtimeData.cgi?scope=Device&DataCollection=CommonInverterData&DeviceId=1" )
#
echo $resp
#
statusCode=$(echo $resp | jq .Body.Data.DeviceStatus.StatusCode)
#
# echo Status is $statusCode
  case "$statusCode" in
    [0-6]) echo "Startup"
      ;;
    7) current=$(echo $resp | jq .Body.Data.PAC );
      echo "Running and producing: " $current
      ;;
    8) echo "Standby"
      ;;
    9) echo "Boot loading"
      ;;
    10) echo "Error"
      ;;
  esac


