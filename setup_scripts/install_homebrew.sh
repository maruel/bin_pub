#!/bin/sh
# Copyright 2014 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Install homebrew locally, not system wide. Homebrew shouldn't mess with
# /usr/local, seriously.
#
# .bash_aliases adds $HOME/bin/homebrew/bin to PATH.

set -e

cd ~/bin
mkdir homebrew
curl -sL https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C homebrew

echo 'Then do:'
echo '  brew update'
echo '    (and fiddle with XCode)'
echo '  brew install bash'
echo '  brew install bash-completion'
