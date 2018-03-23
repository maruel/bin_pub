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

# Want color and / or @ at end of directory/symlink.
if [ "$PLATFORM" = "Darwin" ]; then
  alias ls='ls -F'
  export CLICOLOR=1
  alias m='echo -e "\u001b[3;0;0t\u001b[8;500;500t"'
else
  alias ls='ls -F --color=tty'
fi

# cygwin specific because git-prompt can't be used there, it's too slow on the
# chromium tree.
if [ "$OS" = "Windows_NT" ]; then
  PS1="\[\e]0;\w\a\]\[\e[33m\]\w\[\e[0m\] \$ "
else
  PS1="\[\e]0;\w\a\]\[\e[33m\]\w\[\e[0m\]🐰"
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
  add_to_PATH "$HOME/homebrew/bin"
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
#if [ -e "$HOME/homebrew/etc/autojump.sh" ]; then
#  source "$HOME/homebrew/etc/autojump.sh"
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
