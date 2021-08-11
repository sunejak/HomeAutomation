#!/bin/bash
#
# WindowMaster control script
cmd=$1
#
# using pin 28 and pin 29 for relays and pin 26 and pin 27 as input, where 0 is a switch pressed.
#
# if [ -z "$1" ]; then
#   echo "Provide a URL "
#   exit 1
# fi
function resetMotors() {
  gpio write 3 0
  gpio write 4 0
  gpio write 5 0
  gpio write 6 0
}
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
count=0
#
# initialize
#
resetMotors
#
echo Valid commands are: open close loop run reset
#
while true; do
  if [ -z "$cmd" ]; then
      variable=$cmd;
      unset "$cmd";
    else
      read -r variable
  fi
  case $variable in
  open)
    while [ $count -le 500 ]; do
      echo $count
      gpio write 3 1
      gpio write 4 0
      gpio write 5 1
      gpio write 6 0
      ((count++))
    done
    resetMotors
    count=0
    ;;
  close)
    while [ $count -le 500 ]; do
      echo $count
      gpio write 3 0
      gpio write 4 1
      gpio write 5 0
      gpio write 6 1
      ((count++))
    done
    resetMotors
    count=0
    ;;
  reset)
    resetMotors
    count=0
    ;;
  run)
    while (true); do
      if [ $(gpio read 26) -eq 0 ]; then gpio write 3 1; else gpio write 3 0; fi
      if [ $(gpio read 27) -eq 0 ]; then gpio write 4 1; else gpio write 4 0; fi
      if [ $(gpio read 28) -eq 0 ]; then gpio write 5 1; else gpio write 5 0; fi
      if [ $(gpio read 29) -eq 0 ]; then gpio write 6 1; else gpio write 6 0; fi
    done
    ;;
  loop)
    while (true); do
      echo $(gpio read 26) $(gpio read 27) $(gpio read 28) $(gpio read 29) $count
    done
    ;;
  exit)
    exit 0
    ;;
  esac
done
