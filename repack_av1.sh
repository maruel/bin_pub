#!/bin/bash
#
# References:
# - https://github.com/rust-av/Av1an
# - https://hub.docker.com/r/masterofzen/av1an
set -eu

if [ "$#" -lt 1 ]; then
	echo "Usage: $0 <input video>" >&2
	exit 1
fi

# Two steps:
# docker run -v "$(pwd):/videos" --user $(id -u):$(id -g) -it --rm masterofzen/av1an "$@"
# ffmpeg -i blink_aom.mkv -c copy -movflags +faststart blink_aom.mp4

IN="$1"
OUT="${IN%.*}_av1.mp4"
docker run -v "$(pwd):/videos" --user $(id -u):$(id -g) -it --rm masterofzen/av1an \
	-f "-movflags +faststart" -i "$IN" -o "$OUT"
