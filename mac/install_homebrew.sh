#!/bin/sh
# Copyright 2014 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Install homebrew locally, not system wide. Homebrew shouldn't mess with
# /usr/local, seriously.
#
# .bash_aliases adds $HOME/bin/homebrew/bin to PATH.

set -e

if [ ! -f ~/bin/homebrew/bin/brew ]; then
  cd ~/bin
  mkdir homebrew
  curl -sL https://github.com/Homebrew/brew/archive/refs/tags/3.5.9.tar.gz | tar xz --strip 1 -C homebrew
fi

echo 'Updating homebrew'
~/bin/homebrew/bin/brew update

echo 'Installing recent bash'
~/bin/homebrew/bin/brew install bash

echo 'Installing bash completion'
~/bin/homebrew/bin/brew install bash-completion

echo 'Adding bash to allowed shells'
echo $HOME/bin/homebrew/bin/bash | sudo tee -a /etc/shells

echo 'Changing bash to default shell'
chsh -s $HOME/bin/homebrew/bin/bash

echo 'Install tmux'
~/bin/homebrew/bin/brew install tmux
