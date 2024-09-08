# Copyright 2024 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Source: https://github.com/maruel/bin_pub

# cygwin specific because git-prompt can't be used there, it's too slow on the
# chromium tree.
if [ "$OS" = "Windows_NT" ]; then
  # - "\[\e]0;\w\a\]": Set window title to current working directory, with $HOME
  #   replaced with ~.
  # - "\[\e[33m]\w\[\e[0m\]": Current directory as brown.
  # - " \$": Trailing $
  PS1="\[\e]0;\w\a\]\[\e[33m\]\w\[\e[0m\] \$ "
else
  # Adapt the prompt based on the machine I'm ssh'ed into.
  #_CHAR="☁ "
  if [ "$UNAME" = "Darwin" ]; then
    # macOS
    _CHAR=""
  elif [ "$USER" = "pi" ]; then
    # Raspberry Pi
    _CHAR="🍓"
  elif [ "$HOSTNAME" = "quick" ]; then
    # Personal workstation:
    _CHAR="🐟"
  elif [ "$HOSTNAME" = "web-nuc" ]; then
    # Personal server:
    _CHAR="☢ "
  elif [ "$HOSTNAME" = "penguin" ]; then
    # ChromeOS
    _CHAR="💻"
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

  # This is using the form 3b) as described in bin_pub/git-prompt.sh.
  # - '__git_ps1 "': Enable git prompt
  # - '\[\e]0;\W\a\]': Set current directory as window title. Requires tmux
  #   >=2.6 to work. See ./.tmux.conf for my tmux configuration.
  # - '\[\e[0m\]': Reset color
  # - '\$(_V=\$?; if [ \$_V != 0 ]; then echo -e -n \"\\[\\e[31m\\]\$_V\\[\\e[0m\\]\" ; fi)':
  #   Display non-zero exit code as red
  # - '"\[\e[33m\]\w\[\e[0m\]': Current directory with $HOME elided as ~.
  # - '$_CHAR': prompt character as selected above.
  function __my_ps1 {
    if [[ -z $(git config prompt.ignore) ]]; then
      __git_ps1 \
        "\[\e]0;\W\a\]\[\e[0m\]\$(_V=\$?; if [ \$_V != 0 ]; then echo -e -n \"\\[\\e[31m\\]\$_V\\[\\e[0m\\]\" ; fi)" \
        "\[\e[33m\]\w\[\e[0m\]$_CHAR"
    else
      echo "\[\e]0;\W\a\]\[\e[0m\]\$(_V=\$?; if [ \$_V != 0 ]; then echo -e -n \"\\[\\e[31m\\]\$_V\\[\\e[0m\\]\" ; fi)" \
        "\[\e[33m\]\w\[\e[0m\]$_CHAR"
    fi
  }
  PROMPT_COMMAND=__my_ps1
  PROMPT_COMMAND='__git_ps1 \
    "\[\e]0;\W\a\]\[\e[0m\]\$(_V=\$?; if [ \$_V != 0 ]; then echo -e -n \"\\[\\e[31m\\]\$_V\\[\\e[0m\\]\" ; fi)" \
    "\[\e[33m\]\w\[\e[0m\]$_CHAR"'

  # Fallback:
  #PS1="\[\e]0;\w\a\]\[\e[33m\]\w\[\e[0m\]$_CHAR"
fi

