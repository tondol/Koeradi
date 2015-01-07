CURR_DIR=`dirname $0`
DATE_NOW=`env LANG=en_US.UTF-8 date '+%Y%m%d-%H%M-%a'`
FILENAME=${DATE_NOW}-listenradio-$1
cd $CURR_DIR
case $1 in
  uchiinu) RTMP_ID=20095 ;;
  ekoe) RTMP_ID=20095 ;;
esac
rtmpdump --live --stop=$2 \
  -r "rtmp://mtist.as.smartstream.ne.jp/#{RTMP_ID}/livestream" \
  --app ${RTMP_ID} \
  --swfVfy "http://listenradio.jp/Content/player/ListenRadio.swf" \
  -o ${FILENAME}.flv \
  >> listenradio.log 2>> listenradio_error.log
ffmpeg -i ${FILENAME}.flv \
  -strict -2 \
  -vcodec copy -acodec copy \
  ${FILENAME}.mp4
rm ${FILENAME}.flv
