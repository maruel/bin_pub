# Copyright 2024 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Source: https://github.com/maruel/bin_pub

# The private copy will fetch the public one as bin/bin_pub
add_to_PATH "$HOME/bin"
add_to_PATH "$HOME/bin/bin_pub"
add_to_PATH "$HOME/.local/bin"


# Installed through bin_pub/linux/get_nvim.sh or bin_pub/mac/get_nvim.sh
add_to_PATH "$HOME/bin/bin_pub/nvim/bin"
if which nvim > /dev/null; then
  alias vi=nvim
  alias vim=nvim
fi


# Installed through bin_pub/linux/get_nodejs.sh or bin_pub/mac/get_nodejs.sh
add_to_PATH "$HOME/bin/bin_pub/nodejs/bin"


# For LUA LSP.
add_to_PATH "$HOME/src-oth/lua-language-server/bin"


if [ "$UNAME" = "Darwin" ]; then
  # Homebrew, the best package manager ever. /s
  add_to_PATH "$HOME/bin/homebrew/bin"
  if [ -e "$HOME/bin/homebrew/bin/bash" ]; then
    if ! grep -q -s "^$HOME/bin/homebrew/bin/bash$" /etc/shells; then
      echo "Don't forget to sudo vi /etc/shells to add $HOME/bin/homebrew/bin/bash!"
    fi
    export SHELL="$HOME/bin/homebrew/bin/bash"
  fi
  # Add python3 and the rest to PATH.
  add_to_PATH "$HOME/bin/homebrew/opt/python@3/libexec/bin"
fi


# Go.
add_to_PATH "$HOME/src-oth/golang/bin"
add_to_PATH "$HOME/go/bin"
export GOTRACEBACK=all


# Rust.
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
add_to_PATH "$HOME/sdk/bin"
add_to_PATH "$HOME/.cargo/bin"
