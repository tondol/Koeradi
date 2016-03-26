#!/bin/bash

# ./radiko.sh name station duration(secs) mail password
# name:     prefix for mp4 filename
# station:  station id of radiko
#           tokyo fm=FMT, nack5=NACK5, j-wave=FMJ, fm gunma=FMGUMMA, obc radio=OBC, etc
# duration: duration (seconds) of program
# mail:     radiko id (mail address)
# password: radiko password

# オリジナルスクリプト
# http://kyoshiaki.hatenablog.com/entry/2014/05/04/184748

source `dirname $0`/.env

CURR_DIR=${CONTENTS_DIR:-`dirname $0`}
DATE_NOW=`env LANG=en_US.UTF-8 date '+%Y%m%d-%H%M-%a'`
FILENAME=${DATE_NOW}-radiko-$1
RADIKO_ID=$2
DURATION=$3
MAIL=$4
PASSWORD=$5

cd $CURR_DIR

pid=$$
date=`date '+%Y-%m-%d-%H_%M'`
playerurl=http://radiko.jp/player/swf/player_4.1.0.00.swf
playerfile="/tmp/pre_player.swf"
keyfile="/tmp/pre_authkey.png"
cookiefile="/tmp/pre_cookie_${pid}_${date}.txt"
loginfile="/tmp/pre_login.txt"
checkfile="/tmp/pre_check.txt"
logoutfile="/tmp/pre_logout.txt"

#
# Logout Function
#
Logout () {
   wget -q \
     --header="pragma: no-cache" \
     --header="Cache-Control: no-cache" \
     --header="Expires: Thu, 01 Jan 1970 00:00:00 GMT" \
     --header="Accept-Language: ja-jp" \
     --header="Accept-Encoding: gzip, deflate" \
     --header="Accept: application/json, text/javascript, */*; q=0.01" \
     --header="X-Requested-With: XMLHttpRequest" \
     --no-check-certificate \
     --load-cookies $cookiefile \
     --save-headers \
     -O $logoutfile \
     https://radiko.jp/ap/member/webapi/member/logout

    if [ -f $cookiefile ]; then
        rm -f $cookiefile
    fi
    echo "=== Logout: radiko.jp ==="
}

###
# radiko premium
###
if [ $MAIL ]; then
  wget -q --save-cookie=$cookiefile \
       --keep-session-cookies \
       --post-data="mail=$MAIL&pass=$PASSWORD" \
       -O $loginfile \
       https://radiko.jp/ap/member/login/login

  if [ ! -f $cookiefile ]; then
    echo "failed login"
    exit 1
  fi
fi

#
# check login
#
wget -q \
    --header="pragma: no-cache" \
    --header="Cache-Control: no-cache" \
    --header="Expires: Thu, 01 Jan 1970 00:00:00 GMT" \
    --header="Accept-Language: ja-jp" \
    --header="Accept-Encoding: gzip, deflate" \
    --header="Accept: application/json, text/javascript, */*; q=0.01" \
    --header="X-Requested-With: XMLHttpRequest" \
    --no-check-certificate \
    --load-cookies $cookiefile \
    --save-headers \
    -O $checkfile \
    https://radiko.jp/ap/member/webapi/member/login/check

if [ $? -ne 0 ]; then
  echo "failed login"
  exit 1
fi

#
# get player
#
if [ ! -f $playerfile ]; then
  wget -q -O $playerfile $playerurl

  if [ $? -ne 0 ]; then
    echo "failed get player"
    Logout
    exit 1
  fi
fi

#
# get keydata (need swftool)
#
if [ ! -f $keyfile ]; then
  swfextract -b 14 $playerfile -o $keyfile

  if [ ! -f $keyfile ]; then
    echo "failed get keydata"
    Logout
    exit 1
  fi
fi

if [ -f auth1_fms_${pid} ]; then
  rm -f auth1_fms_${pid}
fi

#
# access auth1_fms
#
wget \
     --header="pragma: no-cache" \
     --header="X-Radiko-App: pc_1" \
     --header="X-Radiko-App-Version: 2.0.1" \
     --header="X-Radiko-Device: pc" \
     --header="X-Radiko-User: test-stream" \
     --header="X-Requested-With: ShockwaveFlash/21.0.0.197" \
     --post-data='\r\n' \
     --no-check-certificate \
     --load-cookies $cookiefile \
     --save-headers \
     -O auth1_fms_${pid} \
     https://radiko.jp/v2/api/auth1_fms

if [ $? -ne 0 ]; then
  echo "failed auth1 process"
  Logout
  exit 1
fi

#
# get partial key
#
authtoken=`ruby -ne 'print $1 if $_ =~ /x-radiko-authtoken: ([\w-]+)/i' auth1_fms_${pid}`
offset=`ruby -ne 'print $1 if $_ =~ /x-radiko-keyoffset: (\d+)/i' auth1_fms_${pid}`
length=`ruby -ne 'print $1 if $_ =~ /x-radiko-keylength: (\d+)/i' auth1_fms_${pid}`

partialkey=`dd if=$keyfile bs=1 skip=${offset} count=${length} 2> /dev/null | base64`

echo "authtoken: ${authtoken}"
echo "offset: ${offset}"
echo "length: ${length}"
echo "partialkey: ${partialkey}"

rm -f auth1_fms_${pid}

if [ -f auth2_fms_${pid} ]; then
  rm -f auth2_fms_${pid}
fi

#
# access auth2_fms
#
wget -q \
     --header="pragma: no-cache" \
     --header="X-Radiko-App: pc_1" \
     --header="X-Radiko-App-Version: 2.0.1" \
     --header="X-Radiko-AuthToken: ${authtoken}" \
     --header="X-Radiko-Device: pc" \
     --header="X-Radiko-PartialKey: ${partialkey}" \
     --header="X-Radiko-User: test-stream" \
     --header="X-Requested-With: ShockwaveFlash/21.0.0.197" \
     --post-data='\r\n' \
     --load-cookies $cookiefile \
     --no-check-certificate \
     -O auth2_fms_${pid} \
     https://radiko.jp/v2/api/auth2_fms

if [ $? -ne 0 -o ! -f auth2_fms_${pid} ]; then
  echo "failed auth2 process"
  Logout
  exit 1
fi

echo "authentication success"

areaid=`ruby -ne 'print $1 if $_ =~ /^([^,]+),/i' auth2_fms_${pid}`
echo "areaid: $areaid"

rm -f auth2_fms_${pid}

#
# get stream-url
#

if [ -f ${RADIKO_ID}.xml ]; then
  rm -f ${RADIKO_ID}.xml
fi

wget -q "http://radiko.jp/v2/station/stream/${RADIKO_ID}.xml"

stream_url=`echo "cat /url/item[1]/text()" | xmllint --shell ${RADIKO_ID}.xml | tail -2 | head -1`
url_parts=(`echo $stream_url | ruby -ne 'print $_.chomp.sub(%r!^(.*)://(.*?)/(.*)/(.*?)$!, %q!\1://\2 \3 \4!)'`)

rm -f ${RADIKO_ID}.xml

#
# rtmpdump
#
rtmpdump -v \
         -r ${url_parts[0]} \
         --app ${url_parts[1]} \
         --playpath ${url_parts[2]} \
         -W $playerurl \
         -C S:"" -C S:"" -C S:"" -C S:$authtoken \
         --live \
         --stop ${DURATION} \
         --flv "/tmp/${FILENAME}"

#
# Logout
#

Logout

ffmpeg -y -i "/tmp/${FILENAME}" -acodec copy "${FILENAME}.m4a"

if [ $? = 0 ]; then
    rm -f "/tmp/${FILENAME}"
fi
