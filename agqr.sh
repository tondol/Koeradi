CURR_DIR=`dirname $0`
DATE_NOW=`date '+%Y%m%d-%H%M-%a'`
FILENAME=${DATE_NOW}-agqr-$1
RTMP_URL=rtmp://fms-base2.mitene.ad.jp/agqr/aandg22
cd $CURR_DIR
rtmpdump --live --stop=$2 \
  -r ${RTMP_URL} \
  -o ${FILENAME}.flv \
  >> agqr.log 2>> agqr_error.log
#ffmpeg -i ${FILENAME}.flv \
#  -acodec copy ${FILENAME}.m4a
#rm ${FILENAME}.flv