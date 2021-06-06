# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Exports this so it is always quickly accessible. This is leveraged in
# .tmux.conf to save time.
export UNAME=$(uname)

# HOSTNAME is generally defined as a pseudo environment variable. Define it for
# real so it's usable in .tmux.conf.
export HOSTNAME=$HOSTNAME

export EDITOR=vim
export HISTCONTROL="ignoredups"
export PYTHONDONTWRITEBYTECODE=x


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
alias ll='ls -la --time-style=long-iso'
alias lsd='ll | grep "^d"'
alias lsf='ll | grep -v "^d"'
# git diff implementation is much better than default diff.
alias diff="git diff --no-index --no-ext-diff --no-prefix"
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
if [ "$UNAME" = "Darwin" ]; then
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
  # Adapt the prompt based on the machine I'm ssh'ed into.
  if [ "$UNAME" = "Darwin" ]; then
    # macOS
    _CHAR=""
  elif [ "$USER" = "pi" ]; then
    # Raspberry Pi
    _CHAR="🍓"
  elif [ "$HOSTNAME" = "quick" ]; then
    # Personal workstation:
    _CHAR="🐟"
  elif [[ $HOSTNAME == *laptop* ]]; then
    # Laptop:
    _CHAR="💻"
  elif [[ $HOSTNAME == *p920* ]]; then
    # Workstation:
    _CHAR="☢ "
  elif grep -q GOOGLE /etc/lsb-release 2>/dev/null; then
    # VM in the cloud
    _CHAR="☁ "
  else
    # Default:
    _CHAR="$ "
  fi

  # Local copy of
  # https://github.com/git/git/blob/HEAD/contrib/completion/git-prompt.sh
  source ~/bin/bin_pub/git-prompt.sh

  # Flags:
  #  *  unstaged
  #  +  staged
  #  %  untracked
  #  $  stashed
  # Upstream relationship is one of:
  #  <  behind upstream
  #  >  ahead upstream
  #  <> diverged from upstream
  #  =  equals upstream
  GIT_PS1_DESCRIBE_STYLE="tag"
  GIT_PS1_SHOWCOLORHINTS=1
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWSTASHSTATE=1
  GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWUPSTREAM="auto"

  # - Enable git prompt
  # - Set current directory as window title (requires recent tmux >=2.6)
  # - Reset color
  # - Display non-zero exit code as red
  # - Current directory
  PROMPT_COMMAND='__git_ps1 "\[\e]0;\W\a\]\[\e[0m\]\$(_V=\$?; if [ \$_V != 0 ]; then echo -e -n \"\\[\\e[31m\\]\$_V\\[\\e[0m\\]\" ; fi)" "\[\e[33m\]\w\[\e[0m\]$_CHAR"'
fi


add_to_PATH() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1:$PATH"
  fi
}

# The private copy will fetch the public one as bin/bin_pub
add_to_PATH "$HOME/bin"
add_to_PATH "$HOME/bin/bin_pub"
add_to_PATH "$HOME/.local/bin"

if [ "$UNAME" = "Darwin" ]; then
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
add_to_PATH "$HOME/src-oth/golang/bin"
add_to_PATH "$HOME/go/bin"
export GOTRACEBACK=all
# Try always on Go module mode.
export GO111MODULE=on


# Rust.
add_to_PATH "$HOME/sdk/bin"
add_to_PATH "$HOME/.cargo/bin"


# So 'j' can be used.
# sudo apt-get install autojump
if [ -e /usr/share/autojump/autojump.sh ]; then
  source /usr/share/autojump/autojump.sh
fi
# brew install autojump
if [ -e "$HOME/bin/homebrew/etc/autojump.sh" ]; then
  source "$HOME/bin/homebrew/etc/autojump.sh"
fi


# git-completion
if [ "$UNAME" = "Darwin" ]; then
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
if which keychain &>/dev/null; then
  # This call costs one second.
  # TODO(maruel): Figure out a way to skip it when unnecessary.
  keychain --quiet -Q --inherit any identity
  [[ -f $HOME/.keychain/$HOSTNAME-sh ]] && source $HOME/.keychain/$HOSTNAME-sh
  [[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ]] && source $HOME/.keychain/$HOSTNAME-sh-gpg
fi


# Load private configuration if present.
if test -f ~/.config/bash_aliases; then
  source ~/.config/bash_aliases
fi


# Junk follows.

