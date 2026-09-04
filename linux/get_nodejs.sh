#!/bin/bash
# Copyright 2025 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -eu
cd "$(dirname $0)"
cd ..

BASE_URL=https://nodejs.org/dist/latest/
BASE_URL=https://nodejs.org/dist/latest-v24.x/
NODEJS_VERSION="$(curl -sS $BASE_URL | grep -oP 'node-[^"]+-linux-x64\.tar\.xz' | head -n 1)"
echo "Downloading $NODEJS_VERSION"

# Always start over from scratch.
rm -rf nodejs
mkdir -p nodejs

curl -sSL -o nodejs/nodejs.tar.xz $BASE_URL/$NODEJS_VERSION
tar -C nodejs --strip-components=1 -xJf nodejs/nodejs.tar.xz
rm nodejs/nodejs.tar.xz

npm install -g tsx vscode-langservers-extracted

npm install -g pnpm
