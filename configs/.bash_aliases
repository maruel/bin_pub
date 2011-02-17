# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

export P4CONFIG=.p4config
#export P4DIFF=vimdiff
#export P4MERGE=vimmerge
export P4DIFF=autodiff
export P4MERGE=automerge
export P4EDITOR=vim
export EDITOR=vim
export LESS=-R
alias cd..='cd ..'

# TODO(maruel): Find a way to not add it if it's already in there!
export PATH=$HOME/bin:$PATH
if [ ! "$PYTHONPATH"=="" ]; then
    export PYTHONPATH=$PYTHONPATH:$HOME/bin
else
    export PYTHONPATH=$HOME/bin
fi

# The private copy will fetch the public one as bin/bin_pub
if [ -d $HOME/bin/bin_pub ]; then
    export PATH=$HOME/bin/bin_pub:$PATH
    export PYTHONPATH=$HOME/bin/bin_pub:$PYTHONPATH
fi

# Enable 2 finger scroll.
# TODO: only on laptop.
if [ ! "$DISPLAY"=="" ]; then
    synclient VertTwoFingerScroll=1
    synclient HorizTwoFingerScroll=1
    synclient EmulateTwoFingerMinW=5
    synclient EmulateTwoFingerMinZ=48
fi


# git-prompt.
if [ -f ~/bin/bin_pub/git-prompt/git-prompt.sh ]; then
    . ~/bin/bin_pub/git-prompt/git-prompt.sh
fi

# It's not necessary because it's installed by default.
#if [ -f /etc/bash_completion.d/git ]; then
#    # Location for ubuntu.
#    source /etc/bash_completion.d/git
#else
#    # It's not at the same place on MacOSX.
#    if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
#        source /usr/local/git/contrib/completion/git-completion.bash
#    fi
#fi


# Enhanced ssh-agent.
if which keychain &>/dev/null; then
    keychain --quiet -Q --inherit any identity
    [[ -f $HOME/.keychain/$HOSTNAME-sh ]] && source $HOME/.keychain/$HOSTNAME-sh
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
    if [ "$WORK_DISPLAY_IDLE_TIME" == "" ]; then
        DISPLAY=
    # Check if DISPLAY has been idle for more than 15 minutes.
    elif [ $WORK_DISPLAY_IDLE_TIME -gt 900000 ]; then
        # I just don't understand this sed regexp but it works under NX.
        DISPLAY=$(ps axuwww|sed -n -e '/maruel/s/.* \(:[0-9][0-9]*\)\( .*\|\)$/\1/p')
        if [ "$DISPLAY" == "" ]; then
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
