#!/bin/bash

source `dirname $0`/.env

export ACD_CLI_CACHE_PATH

for path in $CONTENTS_DIR/*.{mp4,m4a,flv}; do
  if [ ! -f $path -o ! -s $path ]; then
    continue
  fi

  acd_cli upload -o $path $ACD_CLI_CONTENTS_DIR
  rm $path
  touch $path
done
