#!/bin/bash
if [ -z "$1" ]; then
  echo "Provide a delay time"
  exit 1
fi
delayTime=$1
#
# read io pin, and if it failed set it to -100
#
gpio mode 29 out
gpio mode 28 out
gpio mode 27 in
#
sleep ${delayTime}
fileName=outdoor_$(date +%Y)_$(date +%b)_$(date +%d)_$(date +%H)$(date +%M)_$(date +%S).jpeg
#
io=$(gpio read 27) || io=-127;
if [ $io -eq 1 ]; then
   raspistill -n -ex night -rot 180 -o /mnt/ramdisk/tmp_${delayTime}.jpeg
   echo took picture $(date)
   # jpegtran -rotate 180 -outfile /mnt/ramdisk/tmp_${delayTime} /mnt/ramdisk/rot_${delayTime}
   scp /mnt/ramdisk/tmp_${delayTime}.jpeg ttjsun@192.168.1.26:/var/www/html/outdoor/$(date +%m)_$(date +%b)_$(date +%Y)/$(date +%d)/${fileName}
   status=$1
   echo $status

   gpio write 29 0
else
   gpio write 29 1
fi
