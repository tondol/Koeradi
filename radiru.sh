#!/bin/bash

# ./radiru.sh name station duration(secs)
# name:     prefix for m4a filename
# station:  station id of radiru
#           
# duration: duration (seconds) of program

# オリジナルスクリプト
# https://gist.github.com/riocampos/5656450
# https://gist.github.com/riocampos/93739197ab7c765d16004cd4164dca73

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
  URL="https://nhkradioakfm-i.akamaihd.net/hls/live/512290/1-fm/1-fm-01.m3u8"
  ;;
  "NHK2")
  URL="https://nhkradioakr2-i.akamaihd.net/hls/live/511929/1-r2/1-r2-01.m3u8"
  ;;
  "FM")
  URL="https://nhkradioakfm-i.akamaihd.net/hls/live/512290/1-fm/1-fm-01.m3u8"
  ;;
  *)
  exit
  ;;
esac

ffmpeg -i ${URL} -t ${DURATION} -c copy ${FILENAME}.m4a
