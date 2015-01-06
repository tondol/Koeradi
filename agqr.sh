CURR_DIR=`dirname $0`
DATE_NOW=`env LANG=en_US.UTF-8 date '+%Y%m%d-%H%M-%a'`
FILENAME=${DATE_NOW}-agqr-$1
RTMP_URL=rtmp://fms-base2.mitene.ad.jp/agqr/aandg22
cd $CURR_DIR
rtmpdump --live --stop=$2 \
  -r ${RTMP_URL} \
  -o ${FILENAME}.flv \
  >> agqr.log 2>> agqr_error.log
ffmpeg -i ${FILENAME}.flv \
  -strict -2 \
  -vcodec copy -acodec aac -ar 22050 \
  ${FILENAME}.mp4
rm ${FILENAME}.flv
