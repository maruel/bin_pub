#!/bin/sh
# Copyright 2012 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.
OUT="$HOME/src/golang"
echo "Installing Go in $OUT"
if [ -d "$OUT" ]; then
  cd "$OUT"
  hg pull
else
  hg clone https://code.google.com/p/go/ "$OUT"
  cd "$OUT"
fi
TAG="$(hg tags | grep go | head -n 1 | cut -f 1 -d ' ')"
echo "Using $TAG"
hg co $TAG
echo "Building."
cd src
./all.bash
