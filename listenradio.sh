#!/bin/bash

# ./listenradio.sh name station duration
# name:     prefix for mp4 filename
# station:  station id for ffmpeg
#           ekoe=20095
# duration: duration (seconds) of program

source `dirname $0`/.env

CURR_DIR=${CONTENTS_DIR:-`dirname $0`}
DATE_NOW=`env LANG=en_US.UTF-8 date '+%Y%m%d-%H%M-%a'`
FILENAME=${DATE_NOW}-listenradio-$1
RTMP_ID=$2
DURATION=$3

cd $CURR_DIR

#rtmpdump --live --stop=$2 \
#  -r "rtmp://mtist.as.smartstream.ne.jp/#{RTMP_ID}/livestream" \
#  --app ${RTMP_ID} \
#  --swfVfy "http://listenradio.jp/Content/player/ListenRadio.swf" \
#  -o ${FILENAME}.flv \
#  >> listenradio.log 2>> listenradio_error.log
#ffmpeg -i ${FILENAME}.flv \
#  -strict -2 \
#  -vcodec copy -acodec copy \
#  ${FILENAME}.mp4
#rm ${FILENAME}.flv

ffmpeg -i "http://mtist.as.smartstream.ne.jp/${RTMP_ID}/livestream/playlist.m3u8" \
  -t ${DURATION} \
  -strict -2 \
  -absf aac_adtstoasc \
  -vcodec copy -acodec copy \
  ${FILENAME}.mp4
