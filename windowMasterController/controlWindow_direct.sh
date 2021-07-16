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
gpio mode 28 in
gpio mode 29 in
gpio mode 3 out
gpio mode 4 out
gpio mode 5 out
gpio mode 6 out
count=0;
#
# initialize
#
gpio write 3 0
gpio write 4 0
gpio write 5 0
gpio write 6 0
#
echo Valid commands are: open close loop run reset
# 
while true
do
read variable
case $variable in
open)
  while [ $count -le 100 ]
  do
    echo $count;
  gpio write 3 1
  gpio write 4 0
  gpio write 5 1
  gpio write 6 0
  ((count++));
  done;
  count=0;
;;
close)
  while [ $count -le 100 ]
  do
    echo $count;
  gpio write 3 0
  gpio write 4 1
  gpio write 5 0
  gpio write 6 1
  ((count++))
  done;
  count=0;
;;
reset)
  gpio write 3 0
  gpio write 4 0
  gpio write 5 0
  gpio write 6 0
  count=0;
;;
run)
  while (true) do
  if [ $(gpio read 26) -eq 0 ] ; then gpio write 3 1; else gpio write 3 0; fi
  if [ $(gpio read 27) -eq 0 ] ; then gpio write 4 1; else gpio write 4 0; fi
  if [ $(gpio read 28) -eq 0 ] ; then gpio write 5 1; else gpio write 5 0; fi
  if [ $(gpio read 29) -eq 0 ] ; then gpio write 6 1; else gpio write 6 0; fi
  done
;;
loop)
  while (true) do
  echo $(gpio read 26) $(gpio read 27) $(gpio read 28) $(gpio read 29) $count;
  done
;;
*)
  exit 0;
;;
esac
done
