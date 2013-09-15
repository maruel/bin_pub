# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

PLATFORM=$(uname)

# Write .bash_history on each new line.
PROMPT_COMMAND="history -a;"

# <3 perforce.
export P4CONFIG=.p4config
#export P4DIFF=vimdiff
#export P4MERGE=vimmerge
export P4DIFF=autodiff
export P4MERGE=automerge
export P4EDITOR=vim
export EDITOR=vim
# Do not enable that by default since it forces the user to press 'q' to quit
# even if there is not a screenful of data.
# export LESS=-R
alias cd..='cd ..'
alias s='screen -x '
# Want color and / or @ at end of directory/symlink.
if [ "$PLATFORM" = "Darwin" ]; then
    alias ls='ls -F'
    export CLICOLOR=1
else
    alias ls='ls -F --color=tty'
fi
# Not on mac and cygwin by default.
alias ll='ls -la'
export HISTCONTROL="ignoredups"
# cygwin specific
if [ "$OS" = "Windows_NT" ]; then
    PS1="\[\e]0;\w\a\]\[\e[33m\]\w\[\e[0m\] \$ "
fi


# TODO(maruel): Find a way to not add it if it's already in there!
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
if [ ! "$PYTHONPATH" = "" ]; then
    export PYTHONPATH=$PYTHONPATH:$HOME/bin
else
    export PYTHONPATH=$HOME/bin
fi

# The private copy will fetch the public one as bin/bin_pub
if [ -d $HOME/bin/bin_pub ]; then
    export PATH=$HOME/bin/bin_pub/git_utils:$HOME/bin/bin_pub:$PATH
    export PYTHONPATH=$HOME/bin/bin_pub:$PYTHONPATH
fi

if [ -e /usr/share/autojump/autojump.sh ]; then
  source /usr/share/autojump/autojump.sh
fi

# Enable 2 finger scroll.
if [ $(grep "ROLE=laptop" /etc/lsb-release 2>/dev/null) ]; then
    # Only for laptop.
    if [ ! "$DISPLAY" = "" ]; then
        synclient VertTwoFingerScroll=1
        synclient HorizTwoFingerScroll=1
        synclient EmulateTwoFingerMinW=5
        synclient EmulateTwoFingerMinZ=48
    fi
fi


# git-prompt; it is too slow on cygwin.
if [ ! "$OS" = "Windows_NT" ]; then
    if [ -f ~/bin/bin_pub/git-prompt/git-prompt.sh ]; then
        . ~/bin/bin_pub/git-prompt/git-prompt.sh
    fi
fi


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
if which keychain &>/dev/null; then
    # This call costs one second.
    keychain --quiet -Q --inherit any identity
    [[ -f $HOME/.keychain/$HOSTNAME-sh ]] && source $HOME/.keychain/$HOSTNAME-sh
    [[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ]] && source $HOME/.keychain/$HOSTNAME-sh-gpg
    rm -f $HOME/.keychain/$HOSTNAME-csh
    rm -f $HOME/.keychain/$HOSTNAME-fish
fi


# Ami Fischman is a god.
function update-display-env() {
    # There is 3 supported scenarios:
    # - Running on local display
    # - Running on remote display (with or without a local display active)
    # - Running in a ssh prompt without a display

    local WORK_DISPLAY_IDLE_TIME=$(DISPLAY=:0 xprintidle 2>/dev/null)
    if [ "$WORK_DISPLAY_IDLE_TIME" = "" ]; then
        DISPLAY=
    # Check if DISPLAY has been idle for more than 15 minutes.
    elif [ $WORK_DISPLAY_IDLE_TIME -gt 900000 ]; then
        # I just don't understand this sed regexp but it works under NX.
        DISPLAY=$(ps axuwww|sed -n -e '/maruel/s/.* \(:[0-9][0-9]*\)\( .*\|\)$/\1/p')
        if [ "$DISPLAY" = "" ]; then
            DISPLAY=
        fi
    else
        DISPLAY=:0.0
    fi
}

# I disabled it for now since if X hangs, bash hangs too.
## Only install the DISPLAY auto-fixer if xprintidle is available.
#if [ $(which xprintidle) ]; then
#  PROMPT_COMMAND="$PROMPT_COMMAND; update-display-env; "
#fi

# End of public configuration.
