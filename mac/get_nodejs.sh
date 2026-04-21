#!/bin/bash
# Copyright 2025 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -eu
cd "$(dirname $0)"
cd ..

NODEJS_VERSION="$(curl -sS https://nodejs.org/dist/latest/ | grep -oE 'node-[^"]+-darwin-arm64\.tar\.xz' | head -n 1)"
echo "Downloading $NODEJS_VERSION"

# Always start over from scratch.
rm -rf nodejs
mkdir -p nodejs

# TODO: Fetch LTS.
URL=https://nodejs.org/dist/latest/$NODEJS_VERSION
#URL=https://nodejs.org/dist/latest-v24.x/node-v24.15.0-darwin-arm64.tar.xz
curl -sSL -o nodejs/nodejs.tar.xz $URL
tar -C nodejs --strip-components=1 -xJf nodejs/nodejs.tar.xz
rm nodejs/nodejs.tar.xz

npm install -g pnpm
