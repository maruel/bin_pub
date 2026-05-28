# Copyright 2024 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Source: https://github.com/maruel/bin_pub

if [ "$UNAME" = "Darwin" ]; then
  # XCode
	if [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ]; then
    source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
	fi
	# brew install bash_completion
	if [ -f $(brew --prefix)/etc/bash_completion ]; then
		source $(brew --prefix)/etc/bash_completion
	fi
elif [ "$OS" = "Windows_NT" ]; then
  if [ -f /etc/bash_completion.d/git ]; then
    # Location for ubuntu and cygwin, but only necessary for cygwin.
    source /etc/bash_completion.d/git
  fi
fi
