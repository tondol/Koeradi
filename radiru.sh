#!/bin/bash

# ./radiru.sh name station duration(secs)
# name:     prefix for m4a filename
# station:  station id of radiru
#           
# duration: duration (seconds) of program

# オリジナルスクリプト
# https://gist.github.com/riocampos/5656450

source `dirname $0`/.env

CURR_DIR=${CONTENTS_DIR:-`dirname $0`}
DATE_NOW=`env LANG=en_US.UTF-8 date '+%Y%m%d-%H%M-%a'`
FILENAME=${DATE_NOW}-radiru-$1
STATION=$2
DURATION=$3

cd $CURR_DIR

echo $CURR_DIR/$FILENAME.m4a

case $STATION in
  "NHK1")
  PLAYPATH="NetRadio_R1_flash@63346"
  URL="rtmpe://netradio-r1-flash.nhk.jp"
  ;;
  "NHK2")
  PLAYPATH="NetRadio_R2_flash@63342"
  URL="rtmpe://netradio-r2-flash.nhk.jp"
  ;;
  "FM")
  PLAYPATH="NetRadio_FM_flash@63343"
  URL="rtmpe://netradio-fm-flash.nhk.jp"
  ;;
  *)
  exit
  ;;
esac

rtmpdump --rtmp "${URL}" \
         --playpath "${PLAYPATH}" \
         --app "live" \
         --swfVfy http://www3.nhk.or.jp/netradio/files/swf/rtmpe_ver2015.swf \
         --live \
         --stop ${DURATION} \
         -o /tmp/${FILENAME}.flv
ffmpeg -i /tmp/${FILENAME}.flv \
       -acodec copy \
       ${FILENAME}.m4a
rm /tmp/${FILENAME}.flv
