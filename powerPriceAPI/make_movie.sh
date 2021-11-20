#!/bin/bash
#
# run just before midnight...
#
cd /var/www/html/desk-cam/`date +%m`_`LC_TIME="en_US.UTF-8" date +%b`_`date +%Y`/`date +%d`
rm amovie.mp4
#
# make a 6 minutes video using minute pictures, use framerate 4
# make a 3 minutes video using 30 second pictures, use framerate 16
#
cat cam0_*.jpeg | ffmpeg -framerate 16 -f image2pipe -i - -c:v libx264  -pix_fmt yuv420p amovie.mp4
#
echo Done at $(date)

