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

If you have issues with crontab, try adding a 2>&1 maybe PATH or access is the issue.

# For more information see the manual pages of crontab(5) and cron(8)
# 
# m h  dom mon dow   command
1 14 * * *     	cd /home/ttjsun/2020/nordpool ; ./get_data_from_nordpool.sh
40 14 * * *    	cd /home/ttjsun/2021/HomeAutomation/powerPriceAPI ; ./create_offpeak_time.sh  /home/ttjsun/2020/nordpool/market-$(date -I).json >> /var/www/html/market.log 
0 12 * * 1     	cd /home/ttjsun/2021/HomeAutomation/powerPriceAPI ; ./get_sunrise_sunset.sh https://www.yr.no/api/v0/locations/1-218408/celestialevents >> /var/www/html/suntime.log
5 0 * * *      	cd /home/ttjsun/2021/HomeAutomation/powerPriceAPI ; ./make_plot.sh >> /var/www/html/plot.log
59 23 * * *    	cd /home/ttjsun/2021/HomeAutomation/powerPriceAPI ; ./make_movie.sh >> /var/www/html/movie.log
* * * * *      	cd /home/ttjsun/2021/HomeAutomation/inverter; ./get_power.sh | head -1 > /var/www/html/inverter.json
* * * * *      	cd /home/ttjsun/2021/HomeAutomation; ./make_device_list.sh > /var/www/html/devices.json
* * * * *	cd /home/ttjsun/2021/monitor; ./Cron_api.sh >> logging.txt


# m h  dom mon dow   command
59 23 * * *    	cd /home/ttjsun/2021/HomeAutomation/powerPriceAPI ; ./make_movie.sh >> /mnt/SSD_disk1/movie.log
0 12 * * 1     	cd /home/ttjsun/2021/HomeAutomation/powerPriceAPI ; ./get_sunrise_sunset.sh https://www.yr.no/api/v0/locations/1-218408/celestialevents >> /mnt/SSD_disk1/suntime.json
0 14 * * * 	cd /home/ttjsun/2022/ElectricPrices/src/main/sh; ./crontab.sh >> /mnt/SSD_disk1/electric.json




