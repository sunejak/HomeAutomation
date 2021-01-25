HomeAutomation
==============

This is the top level for miscanellious Raspberry PI projects for home automation.

* Heating controller based on current electric price
* Windowmaster controller
* Outdoor light controller based on sunrise and sunset times.

To create a RAM disk, proceed as follows:

Create a mount point:

* sudo mkdir /mnt/ramdisk

Add it into /etc/fstab, so that a RAM disk is automatically generated upon startup:

* sudo vi /etc/fstab

tmpfs /mnt/ramdisk tmpfs nodev,nosuid,size=2M 0 0

