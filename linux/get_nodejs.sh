#!/bin/bash
# Copyright 2025 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -eu
cd "$(dirname $0)"
cd ..

NODEJS_VERSION="$(curl -sS https://nodejs.org/dist/latest/ | grep -oP 'node-[^"]+-linux-x64\.tar\.xz' | head -n 1)"
echo "Downloading $NODEJS_VERSION"

# Always start over from scratch.
rm -rf nodejs
mkdir -p nodejs

curl -sSL -o nodejs/nodejs.tar.xz https://nodejs.org/dist/latest/$NODEJS_VERSION
tar -C nodejs --strip-components=1 -xJf nodejs/nodejs.tar.xz
rm nodejs/nodejs.tar.xz
