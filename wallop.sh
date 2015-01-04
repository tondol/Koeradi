CURR_DIR=`dirname $0`
DATE_NOW=`date '+%Y%m%d-%H%M-%a'`
FILENAME=${DATE_NOW}-wallop-$1
cd $CURR_DIR
case $1 in
  koncheki) RTMP_URL=rtmp://wallop-live1.sp1.fmslive.stream.ne.jp/wallop-live1/_definst_/wallop02 ;;
esac
rtmpdump --live --stop=$2 \
  -r ${RTMP_URL} \
  -o ${FILENAME}.flv \
  >> wallop.log 2>> wallop_error.log
#ffmpeg -i ${FILENAME}.flv \
#  -acodec copy ${FILENAME}.m4a
#rm ${FILENAME}.flv
