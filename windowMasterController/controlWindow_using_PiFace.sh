#!/bin/bash
#
# WindowMaster control script
#
# gpio -x mcp23s17:100:0:0 mode 100 out
# gpio -x mcp23s17:100:0:0 write 100 1
# gpio -x mcp23s17:100:0:0 mode 108 in
# gpio -x mcp23s17:100:0:0 mode 108 up

# using pin 28 and pin 29
#
# if [ -z "$1" ]; then
#  echo "Provide a URL "
#  exit 1
# fi
#
# initialize the extension board
#
gpio -x mcp23s17:100:0:0 mode 108 in
gpio -x mcp23s17:100:0:0 mode 108 up
gpio -x mcp23s17:100:0:0 mode 109 in
gpio -x mcp23s17:100:0:0 mode 109 up
gpio -x mcp23s17:100:0:0 mode 110 in
gpio -x mcp23s17:100:0:0 mode 110 up
gpio -x mcp23s17:100:0:0 mode 111 in
gpio -x mcp23s17:100:0:0 mode 111 up
gpio -x mcp23s17:100:0:0 mode 100 out
gpio -x mcp23s17:100:0:0 mode 101 out
gpio -x mcp23s17:100:0:0 mode 102 out
gpio -x mcp23s17:100:0:0 mode 103 out
#
# and the two additional relays
#
gpio mode 5 out
gpio mode 6 out
#
echo Legal commands: open close reset read run exit
cnt=$#
cmd=$1
#
while true; do
  if [ "$cnt" -eq 1 ]; then
      variable=$cmd;
      cnt=0;
    else
      read variable
  fi
  case $variable in
  open)
    echo open
    gpio -x mcp23s17:100:0:0 write 100 1
    gpio -x mcp23s17:100:0:0 write 101 0
    ;;
  close)
    echo close
    gpio -x mcp23s17:100:0:0 write 100 0
    gpio -x mcp23s17:100:0:0 write 101 1
    ;;
  reset)
    echo reset
    gpio -x mcp23s17:100:0:0 write 100 0
    gpio -x mcp23s17:100:0:0 write 101 0
    ;;
  read)
    echo SW0: $(gpio -x mcp23s17:100:0:0 read 108)
    echo SW1: $(gpio -x mcp23s17:100:0:0 read 109)
    echo SW2: $(gpio -x mcp23s17:100:0:0 read 110)
    echo SW3: $(gpio -x mcp23s17:100:0:0 read 111)
    ;;
  run)
    while true; do
      sw0=$(gpio -x mcp23s17:100:0:0 read 108)
      gpio -x mcp23s17:100:0:0 write 100 $sw0
      sw1=$(gpio -x mcp23s17:100:0:0 read 109)
      gpio -x mcp23s17:100:0:0 write 101 $sw1
      sw2=$(gpio -x mcp23s17:100:0:0 read 110)
      gpio -x mcp23s17:100:0:0 write 102 $sw2
      gpio write 5 $sw2
      sw3=$(gpio -x mcp23s17:100:0:0 read 111)
      gpio -x mcp23s17:100:0:0 write 103 $sw3
      gpio write 6 $sw3
    done
    ;;
  exit)
    exit 0
    ;;
  esac
done
