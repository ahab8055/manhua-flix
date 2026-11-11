#!/bin/bash
# usage: render.sh device n
S=/private/tmp/claude-501/-Users-apple-Documents-DyarStudio-manhua-flix/8ffb7dc6-52d6-4b5c-b55d-dc0dc9f15a0b/scratchpad/shots
case $1 in phone) WS=540,960;; tab7) WS=720,1280;; tab10) WS=1280,720;; esac
mkdir -p $S/raw
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files \
 --force-device-scale-factor=2 --window-size=$WS --virtual-time-budget=6000 --user-data-dir=/private/tmp/claude-501/chrome-shots-$1-$2 \
 --screenshot=$S/raw/$1_$2.png "file://$S/shot.html?d=$1&n=$2" >/dev/null 2>&1
