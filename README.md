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

* Add: "tmpfs /mnt/ramdisk tmpfs nodev,nosuid,size=2M 0 0" at the end of the file.

To enable one wire interface

* sudo raspi-config   (Interface Options -> enable 1Wire)
* cat /boot/config.txt   
* sudo modprobe w1-gpio
* sudo modprobe w1-therm
* cat /sys/bus/w1/devices/28-3c01d607f0b0/temperature  (check that your 1Wire device shows)

For RPi4 you need to do this in order to access the IO pins:

* cd /tmp
* wget https://project-downloads.drogon.net/wiringpi-latest.deb
* sudo dpkg -i wiringpi-latest.deb

Then install a webserver, so that you can read the values over HTTP

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

* sudo apt install jq   (needed for the scipts)

* cd /mnt/ramdisk ;  /home/pi/2024/HomeAutomation/devices/make_json_generic.sh garage 1Wire 4 relayA 5 relayB > temperature.json
    
Add a link for the webserver in the /var/www/html directory, you also need to fix some permissions.

* sudo ln -s /mnt/ramdisk/temperature.json

If you have issues with crontab, try adding a 2>&1 maybe PATH or access is the issue.

    # For more information see the manual pages of crontab(5) and cron(8)
    # 
    # m h  dom mon dow   command
    */5 * * * * 	cd /home/pi/2022/HomeAutomation/devices; ./decide_onORoffList_withCurl.sh http://192.168.1.26/electric.json 4 >> stdout.log
    */5 * * * * 	cd /home/pi/2022/HomeAutomation/devices; ./decide_daylight_withCurl.sh http://192.168.1.26/suntime.json >> stdout.log
    */5 * * * * 	cd /home/pi/2022/HomeAutomation/devices; ./decide_OutdoorLight_withCurl.sh  http://192.168.1.26/suntime.json "00:20" "05:50" >> stdout.log
    * * * * *	    cd /home/pi/2022/HomeAutomation/devices; ./make_json_generic.sh garage 1Wire 4 relayA 5 relayB > /mnt/ramdisk/temperature.json
    0 * * * *	    curl http://192.168.1.23/dummy.txt?device=garage
    @reboot		    gpio mode 2 output; gpio mode 3 output; gpio mode 4 output; gpio mode 5 output; gpio write 2 1; gpio write 3 1; gpio write 4 1; gpio write 5 1;
