#!/bin/sh
# Copyright 2012 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -e

OUT="$HOME/src/golang"
echo "Installing Go in $OUT"
if [ -d "$OUT" ]; then
  cd "$OUT"
  git fetch --all
else
  git clone https://go.googlesource.com/go "$OUT"
  cd "$OUT"
fi

TAG="$(git tag | grep "^go" | egrep -v "beta|rc" | tail -n 1)"
echo "Using $TAG"
git checkout $TAG

echo "Building."
cd src
./all.bash
