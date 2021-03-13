#!/bin/bash
#
name="rp4"
#
# read io pin, and if it failed set it to -100
#
gpio mode 29 out
gpio mode 28 out
gpio mode 27 in
#
# address to one-wire sensor
#
while true;
do
 io=$(gpio read 27) || io=-127;
 if [ $io -eq 0 ]; then
   gpio write 29
   fi
done


