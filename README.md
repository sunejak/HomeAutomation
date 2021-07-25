HomeAutomation
==============

This is the top level for miscellaneous Raspberry PI projects for home automation.

* A heating controller based on current electric price
* Window master controller
* Outdoor light controller based on sunrise and sunset times.

Some controller configurations need temporary storage, so to create a RAM disk, proceed as follows:

Create a mount point:

* sudo mkdir /mnt/ramdisk

Add it into /etc/fstab, so that a RAM disk is automatically generated upon startup:

* sudo vi /etc/fstab

* tmpfs /mnt/ramdisk tmpfs nodev,nosuid,size=2M 0 0

To enable one wire interface

* sudo raspi-config
* cat /boot/config.txt 
* sudo modprobe w1-gpio
* sudo modprobe w1-therm
* cat /sys/bus/w1/devices/28-3c01d607f0b0/temperature 

For RPi4 you need to do this:

* cd /tmp
* wget https://project-downloads.drogon.net/wiringpi-latest.deb
* sudo dpkg -i wiringpi-latest.deb

Then install a webserver

* sudo apt install nginx

Configure the webserver for local access, by adding this in the nginx configuration "/etc/nginx/sites-available/default" file, inside the "location" directive:

    # Simple requests
    if ($request_method ~* "(GET|POST)") {
      add_header "Access-Control-Allow-Origin"  *;
    }

    # Preflighted requests
    if ($request_method = OPTIONS ) {
      add_header "Access-Control-Allow-Origin"  *;
      add_header "Access-Control-Allow-Methods" "GET, POST, OPTIONS, HEAD";
      add_header "Access-Control-Allow-Headers" "Authorization, Origin, X-Requested-With, Content-Type, Accept";
      return 200;
    }
    
* To restart: "sudo systemctl restart nginx"

Add a crontab to read the temperature as often as needed. "* * * * *" is every minute.

* cd /mnt/ramdisk ;  /home/pi/2021/HomeAutomation/make_json_rp4.sh > temperature.json
    
Add a link for the webserver in the /var/www/html directory, you also need to fix some permissions.

* sudo ln -s /mnt/ramdisk/temperature.json







