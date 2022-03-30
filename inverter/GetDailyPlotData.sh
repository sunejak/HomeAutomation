#!/bin/bash
#
# to make a daily data for plot
#
grep -e $(date -I) /var/www/html/all_inverter.json | jq -r '.Body.Data.PAC.Value , .Head.Timestamp ' | paste - - -d' '
