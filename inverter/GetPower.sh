#!/bin/bash
#
# The StatusCode Field is only reported as numerical value.
# Inverter is with fixed IP address at 192.168.1.30
#
# 0 - 6 Startup 
# 7     Running
# 8     Standby 
# 9     Boot loading
# 10    Error 
#
resp=$(curl -s "http://192.168.1.30/solar_api/v1/GetInverterRealtimeData.cgi?scope=Device&DataCollection=CommonInverterData&DeviceId=1" )
if [ $? -ne 0 ] ; then
  echo "{ \"Body\" : { \"Data\" : { \"DAY_ENERGY\" : { \"Unit\" : \"Wh\", \"Value\" : -1.0 }, \"DeviceStatus\" : { \"StatusCode\" : -1 }}}, \"Head\" : {  \"Timestamp\" : \"2021-0-0\" } }"
  exit 1;
fi
#
echo "$resp"
#
statusCode=$(echo "$resp" | jq .Body.Data.DeviceStatus.StatusCode)
#
# echo Status is $statusCode
  case "$statusCode" in
    [0-6]) echo "Startup"
      ;;
    7) current=$(echo "$resp" | jq '.Body.Data.PAC , .Head.Timestamp ');
      echo "Running and producing: " "$current"
      ;;
    8) echo "Standby"
      ;;
    9) echo "Boot loading"
      ;;
    10) echo "Error"
      ;;
  esac


