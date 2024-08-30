# Copyright 2024 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Source: https://github.com/maruel/bin_pub

# Exports this so it is always quickly accessible. This is leveraged in
# .tmux.conf to save time. This variable is used in scripts in
# ~/.config/bash/*.sh.
export UNAME=$(uname)

# Insert an item in front of PATH only if the directory exists and not already
# present.
add_to_PATH() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1:$PATH"
  fi
}

# Source all files:
for f in $HOME/.config/bash.d/*.sh; do source $f; done

# Junk follows. This can only be added by stupid scripts that attempt to modify
# configuration files.

