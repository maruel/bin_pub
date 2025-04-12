# Copyright 2024 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Source: https://github.com/maruel/bin_pub

# Aliases

# My Windows roots show through
alias cd..='cd ..'
# I stole this from twitter.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
# This is the command I use the most: "ssh <workstation>" then "s"
alias s='if tmux has; then tmux -2 attach -d; else tmux -2; fi'
# 'll' is not on mac and cygwin by default, and the default time format used
# is an abomination.
if [ "$UNAME" = "Darwin" ]; then
  alias ll='ls -la -D %Y-%m-%d:%H:%M:%S'
else
  alias ll='ls -la --time-style=long-iso'
fi
alias lsd='ll | grep "^d"'
alias lsf='ll | grep -v "^d"'
# git diff implementation is much better than default diff.
alias diff="git diff --no-index --no-ext-diff --no-prefix"
# Create with:
#   wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py --user
#   pip install --user virtualenv
#   mkdir -p $HOME/src/venv
#   virtualenv $HOME/src/venv
alias venv='source $HOME/src/venv/bin/activate'

# See "CSI Ps ; Ps ; Ps t" at
# http://invisible-island.net/xterm/ctlseqs/ctlseqs.html
# Works on gnome-terminal and macOS Terminal.app.
# TODO(maruel): Doesn't work inside tmux, quite a bummer.
alias m='echo -e "\x1b[3;0;0t\x1b[8;500;500t"'

# Want color and / or @ at end of directory/symlink.
if [ "$UNAME" = "Darwin" ]; then
  alias ls='ls -F'
  export CLICOLOR=1
else
  alias ls='ls -F --color=tty'
fi

# Neovim doesn't provide a vimdiff binary, alias it.
alias vimdiff='nvim -d'
