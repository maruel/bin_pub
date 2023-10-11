#!/bin/bash

# Recompresses a video trying to do the right thing for listening on 
set -eu

# sudo apt install ffmpeg
#ffprobe -hide_banner
abps=$(ffprobe -v error -select_streams a:0 -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 "$1")
width=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 "$1")
vcodec=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$1")

audio_args=""
if [ "$abps" -gt "128000" ]; then
  echo "Recompressing audio from $abps to aac 128k"
  audio_args="-c:a aac -b:a 128k"
fi

video_args=""
if [ "$width" -gt "1280" ]; then
  echo "Resizing video from $width to 2/3"
  video_args="-filter:v scale=trunc(iw/4)*2:trunc(ih/4)*2"
fi

video_codec=""
if [ "$vcodec" != "h264" ]; then
  echo "Recompressing video from $vcodec to h264"
  video_codec="-c:v libx264 -crf 20"
  # Apple prefers hvc1.
  # hevc is not supported everywhere in Chrome yet. :(
  #video_codec="-c:v libx265 -crf 20 -vtag hvc1"
fi

ffmpeg -v warning -hide_banner -i "$1" $audio_args $video_args $video_codec -movflags +faststart "$2"
