#!/bin/sh
# Copyright 2012 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -eu

if true; then
  # Installing from sources.
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
else
  # Install globally from pre-built binaries.
  sudo rm -rf /usr/local/go
  VERSION=1.7.3
  OS=linux
  ARCH=amd64
  FILE=go$VERSION.$OS-$ARCH.tar.gz
  wget https://storage.googleapis.com/golang/$FILE
  sudo tar -C /usr/local -xzf $FILE
  rm $FILE
  # YOLO version:
  # sudo curl https://storage.googleapis.com/golang/$FILE | tax -C /usr/local -xvz
  echo 'export PATH="$PATH:/usr/local/go/bin"' | sudo tee /etc/profile.d/golang.sh
  sudo chmod 0555 /etc/profile.d/golang.sh
fi


# Start getting useful projects right away.
go get -v \
  golang.org/x/tools/cmd/godoc \
  golang.org/x/tools/cmd/goimports \
  golang.org/x/tools/cmd/stringer \
  github.com/maruel/panicparse/cmd/pp
