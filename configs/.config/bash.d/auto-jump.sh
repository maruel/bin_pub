# Copyright 2024 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Source: https://github.com/maruel/bin_pub

# So 'j' can be used.

# sudo apt-get install autojump
if [ -e /usr/share/autojump/autojump.sh ]; then
  source /usr/share/autojump/autojump.sh
fi
# brew install autojump
if [ -e "$HOME/bin/homebrew/etc/autojump.sh" ]; then
  source "$HOME/bin/homebrew/etc/autojump.sh"
fi

