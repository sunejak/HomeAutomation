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
resp=$(curl -s "http://192.168.1.140/solar_api/v1/GetInverterRealtimeData.cgi?Scope=Device&DataCollection=CommonInverterData&DeviceId=1" )
if [ $? -ne 0 ] ; then
  echo "{ \"Body\" : { \"Data\" : { \"DAY_ENERGY\" : { \"Unit\" : \"Wh\", \"Value\" : -1.0 }, \"DeviceStatus\" : { \"StatusCode\" : -1 }}}, \"Head\" : {  \"Timestamp\" : \"$(date -I)\" } }"
  exit 1;
fi
#
echo "$resp" | jq -c .
#
exit 0;


