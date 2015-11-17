#!/bin/bash

# ./agqr.sh name duration
# name:     prefix for mp4 filename
# duration: duration (seconds) of program

source `dirname $0`/.env

CURR_DIR=${CONTENTS_DIR:-`dirname $0`}
DATE_NOW=`env LANG=en_US.UTF-8 date '+%Y%m%d-%H%M-%a'`
FILENAME=${DATE_NOW}-agqr-$1
DURATION=$2
RTMP_URL=rtmp://fms-base2.mitene.ad.jp/agqr/aandg22

cd $CURR_DIR

rtmpdump --live --stop=${DURATION} \
  -r ${RTMP_URL} \
  -o ${FILENAME}.flv
ffmpeg -i ${FILENAME}.flv \
  -strict -2 \
  -vcodec copy -acodec aac -ar 22050 \
  ${FILENAME}.mp4

rm ${FILENAME}.flv
