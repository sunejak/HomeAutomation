#!/bin/bash
#
# WindowMaster control script
#
# using pin 28 and pin 29 for relays and pin 26 and pin 27 as input, where 0 is a switch pressed.
#
# if [ -z "$1" ]; then
#   echo "Provide a URL "
#   exit 1
# fi
#
# set pins for input and output
#
gpio mode 26 in
gpio mode 27 in
gpio mode 28 out
gpio mode 29 out
#
# initialize
#
gpio write 28 0
gpio write 29 0
#
echo Valid commands are: open close loop run reset
# 
while true
do
read variable
case $variable in
open)
  gpio write 28 1
  gpio write 29 0
;;
close)
  gpio write 28 0
  gpio write 29 1
;;
reset)
  gpio write 28 0
  gpio write 29 0
;;
run)
  while (true) do
  if [ $(gpio read 26) -eq 0 ] ; then gpio write 28 1; else gpio write 28 0; fi
  if [ $(gpio read 27) -eq 0 ] ; then gpio write 29 1; else gpio write 29 0; fi
  done
;;
loop)
  while (true) do
  echo $(gpio read 26) $(gpio read 27);
  done
;;
*)
  exit 0;
;;
esac
done
