#!/bin/sh
# Copyright 2012 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -eu

echo "Installing Go in $GOROOT"
if [ -d "$GOROOT" ]; then
  cd "$GOROOT"
  git fetch --all
else
  git clone https://go.googlesource.com/go "$GOROOT"
  cd "$GOROOT"
fi

TAG="$(git tag | grep "^go" | egrep -v "beta|rc" | tail -n 1)"
echo "Using $TAG"
git checkout $TAG

echo "Building."
cd src
./make.bash

# Start getting useful projects right away.
go get -v golang.org/x/tools/cmd/goimports golang.org/x/tools/cmd/stringer
