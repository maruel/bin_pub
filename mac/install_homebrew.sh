#!/bin/sh
# Copyright 2014 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Install homebrew locally, not system wide. Homebrew shouldn't mess with
# /usr/local, seriously.
#
# .bash_aliases adds $HOME/bin/homebrew/bin to PATH.

set -eu

#BREWDIR=$HOME/bin/homebrew
BREWDIR=/opt/homebrew

if [ ! -f ~/bin/homebrew/bin/brew ]; then
  #mkdir $BREWDIR
  #cd $(dirname $BREWDIR)
  #curl -sL https://github.com/Homebrew/brew/archive/refs/tags/4.2.6.tar.gz | tar xz --strip 1 -C homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo 'Updating homebrew'
$BREWDIR/bin/brew update

echo 'Installing recent bash'
$BREWDIR/bin/brew install bash

echo 'Installing bash completion'
$BREWDIR/bin/brew install bash-completion

echo 'Adding bash to allowed shells'
echo $BREWDIR/bin/bash | sudo tee -a /etc/shells

echo 'Changing bash to default shell'
chsh -s $BREWDIR/bin/bash

echo 'Install tmux'
$BREWDIR/bin/brew install tmux

# https://tailscale.com/docs/concepts/macos-variants
echo 'Install tailscale (but doesn\'t enable)'
$BREWDIR/bin/brew install tailscale
