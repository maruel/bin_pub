#!/bin/sh
# Copyright 2012 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Install homebrew locally, not system wide. Homebrew shouldn't mess with
# /usr/local, seriously.

set -e

cd ~/bin
mkdir homebrew
curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C homebrew
