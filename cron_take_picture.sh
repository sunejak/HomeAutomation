#!/bin/bash
#
# read io pin, and if it failed set it to -100
#
gpio mode 29 out
gpio mode 28 out
gpio mode 27 in
#
sleep $1
#
io=$(gpio read 27) || io=-127;
if [ $io -eq 1 ]; then
   raspistill -n -o /mnt/ramdisk/outdoor_$(date +%Y)_$(date +%b)_$(date +%d)_$(date +%H)$(date +%M)_$(date +%S).jpeg
   echo took picture $(date)
   scp /mnt/ramdisk/outdoor_$(date +%Y)_$(date +%b)_$(date +%d)_$(date +%H)$(date +%M)_$(date +%S).jpeg  ttjsun@192.168.1.23:/var/www/html/outdoor/`date +%m`_`date +%b`_`date +%Y`/`date +%d`/cam0_`date +%Y`_`date +%b`_`date +%d`_`date +%H``date +%M`_${delay}.jpeg
   status=$1
   echo $status
   
   gpio write 29 0
else
   gpio write 29 1
fi
