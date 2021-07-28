#!/bin/bash
#
# run just before midnight...
#
cd /var/www/html/desk-cam/`date +%m`_`LC_TIME="en_US.UTF-8" date +%b`_`date +%Y`/`date +%d`
#
# make a 6 minutes video
#
cat cam0_*.jpeg | ffmpeg -framerate 4 -f image2pipe -i - -c:v libx264  -pix_fmt yuv420p amovie.mp4
#
echo Done at $(date)