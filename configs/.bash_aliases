# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

PLATFORM=$(uname)

export EDITOR=vim
export HISTCONTROL="ignoredups"
export PYTHONDONTWRITEBYTECODE=x


# Aliases

# My Windows roots show through
alias cd..='cd ..'
# This is the command I use the most: "ssh <workstation>" then "s"
alias s='if tmux has; then tmux -2 attach -d; else tmux -2; fi'
# 'll' is not on mac and cygwin by default.
alias ll='ls -la'
alias lsd='ll | grep "^d"'
alias lsf='ll | grep -v "^d"'
# Create with:
#   $HOME/bin/bin_pub/setup_scripts/get_pip.sh
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
if [ "$PLATFORM" = "Darwin" ]; then
  alias ls='ls -F'
  export CLICOLOR=1
else
  alias ls='ls -F --color=tty'
fi

# cygwin specific because git-prompt can't be used there, it's too slow on the
# chromium tree.
if [ "$OS" = "Windows_NT" ]; then
  PS1="\[\e]0;\w\a\]\[\e[33m\]\w\[\e[0m\] \$ "
else
  # - Set current directory as window title
  # - Reset color
  # - Display non-zero exit code as red
  # - Current directory
  # For this to work well, this requires a recent version of tmux (2.6)
  if [ "$PLATFORM" = "Darwin" ]; then
    # macOS
    _CHAR=""
  elif [ "$USER" = "pi" ]; then
    # Raspberry Pi
    _CHAR="🍓"
  elif [ "$HOSTNAME" = "ogre" ]; then
    # Main workstation:
    _CHAR="🐟"
  elif [[ $HOSTNAME == *laptop* ]]; then
    # Laptop:
    _CHAR="💻"
  elif grep -q GOOGLE /etc/lsb-release; then
    # VM in the cloud
    _CHAR="☁ "
  else
    # Default:
    _CHAR="$ "
  fi
  PS1="\[\e]0;\W\a\]\[\e[0m\]\$(_V=\$?; if [ \$_V != 0 ]; then echo -e -n \"\\[\\e[31m\\]\$_V \" ; fi)\[\e[33m\]\w\[\e[0m\]$_CHAR"
fi


# PATH

# http://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
add_to_PATH() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    #PATH="${PATH:+"$PATH:"}$1"
    PATH="$1:$PATH"
  fi
}

# The private copy will fetch the public one as bin/bin_pub
add_to_PATH "$HOME/bin"
add_to_PATH "$HOME/bin/bin_pub"
add_to_PATH "$HOME/.local/bin"

if [ "$PLATFORM" = "Darwin" ]; then
  # Homebrew, the best package manager ever.
  add_to_PATH "$HOME/bin/homebrew/bin"
  if [ -e "$HOME/bin/homebrew/bin/bash" ]; then
    if ! grep -q -s "^$HOME/bin/homebrew/bin/bash$" /etc/shells; then
      echo "Don't forget to sudo vi /etc/shells to add $HOME/bin/homebrew/bin/bash!"
    fi
    export SHELL="$HOME/bin/homebrew/bin/bash"
  fi
  # Python local pip.
  add_to_PATH "$HOME/Library/Python/2.7/bin"
fi

# Go.
if [ -d "$HOME/src/golang" ]; then
  export GOROOT="$HOME/src/golang"
  add_to_PATH "$GOROOT/bin"
fi
export GOPATH="$HOME/go"
add_to_PATH "$GOPATH/bin"
export GOTRACEBACK=all

# My python stuff.
export PYTHONPATH="$PYTHONPATH:$HOME/bin:$HOME/bin/bin_pub"

# So 'j' can be used.
# sudo apt-get install autojump
#if [ -e /usr/share/autojump/autojump.sh ]; then
#  source /usr/share/autojump/autojump.sh
#fi
# brew install autojump
#if [ -e "$HOME/bin/homebrew/etc/autojump.sh" ]; then
#  source "$HOME/bin/homebrew/etc/autojump.sh"
#fi

# git-prompt; it is too slow on cygwin.
#if [ ! "$OS" = "Windows_NT" ]; then
#  if [ -f ~/bin/bin_pub/git-prompt/git-prompt.sh ]; then
#    . ~/bin/bin_pub/git-prompt/git-prompt.sh
#  fi
#fi

# git-completion
if [ "$PLATFORM" = "Darwin" ]; then
  # It's not at the same place on MacOSX.
  if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
    source /usr/local/git/contrib/completion/git-completion.bash
  elif [ -f /usr/local/git/current/share/git-core/git-completion.bash ]; then
    # It moved with 1.8?
    source /usr/local/git/current/share/git-core/git-completion.bash
  elif [ -f /usr/share/git-core/git-completion.bash ]; then
    # OSX with XCode's version
    source /usr/share/git-core/git-completion.bash
  fi
elif [ "$OS" = "Windows_NT" ]; then
  if [ -f /etc/bash_completion.d/git ]; then
    # Location for ubuntu and cygwin, but only necessary for cygwin.
    source /etc/bash_completion.d/git
  fi
fi

# Enhanced ssh-agent.
# sudo apt-get install keychain
#if which keychain &>/dev/null; then
#  # This call costs one second.
#  # TODO(maruel): Figure out a way to skip it when unnecessary.
#  keychain --quiet -Q --inherit any identity
#  [[ -f $HOME/.keychain/$HOSTNAME-sh ]] && source $HOME/.keychain/$HOSTNAME-sh
#  [[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ]] && source $HOME/.keychain/$HOSTNAME-sh-gpg
#  rm -f $HOME/.keychain/$HOSTNAME-csh
#  rm -f $HOME/.keychain/$HOSTNAME-fish
#fi


# End of public configuration.
