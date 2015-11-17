#!/bin/bash

# ./wallop.sh name path duration
# name:     prefix for mp4 filename
# path:     path for rtmpdump
# duration: duration (seconds) of program

source `dirname $0`/.env

CURR_DIR=${CONTENTS_DIR:-`dirname $0`}
DATE_NOW=`env LANG=en_US.UTF-8 date '+%Y%m%d-%H%M-%a'`
FILENAME=${DATE_NOW}-wallop-$1
RTMP_URL=rtmp://wallop-live1.sp1.fmslive.stream.ne.jp/wallop-live1/_definst_/$2
DURATION=$3

cd $CURR_DIR

rtmpdump --live --stop=${DURATION} \
  -r ${RTMP_URL} \
  -o ${FILENAME}.flv
ffmpeg -i ${FILENAME}.flv \
  -strict -2 \
  -vcodec copy -acodec copy \
  ${FILENAME}.mp4
rm ${FILENAME}.flv
