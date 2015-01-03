CURR_DIR=`dirname $0`
DATE_NOW=`date '+%Y%m%d-%H%M%S'`
RTMP_URL=rtmp://fms-base2.mitene.ad.jp/agqr/aandg22
cd $CURR_DIR
rtmpdump --live --stop=$2 \
  -r ${RTMP_URL} \
  -o ${DATE_NOW}-agqr-$1.flv \
  >> agqr.log 2>> agqr_error.log
