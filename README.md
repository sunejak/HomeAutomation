HomeAutomation
==============

This is the top level for miscellaneous Raspberry PI projects for home automation.

* Heating controller based on current electric price
* Windowmaster controller
* Outdoor light controller based on sunrise and sunset times.

Some controller configurations need temporary storage, so to create a RAM disk, proceed as follows:

Create a mount point:

* sudo mkdir /mnt/ramdisk

Add it into /etc/fstab, so that a RAM disk is automatically generated upon startup:

* sudo vi /etc/fstab

tmpfs /mnt/ramdisk tmpfs nodev,nosuid,size=2M 0 0

To enable one wire interface

* sudo raspi-config
* cat /boot/config.txt 
* sudo modprobe w1-gpio
* sudo modprobe w1-therm
* cat /sys/bus/w1/devices/28-3c01d607f0b0/temperature 

