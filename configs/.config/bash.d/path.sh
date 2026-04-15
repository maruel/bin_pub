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
if which nvim >/dev/null; then
	alias vi=nvim
	alias vim=nvim
fi

# Installed through bin_pub/linux/get_nodejs.sh or bin_pub/mac/get_nodejs.sh
add_to_PATH "$HOME/bin/bin_pub/nodejs/bin"

# For LUA LSP.
add_to_PATH "$HOME/src-oth/lua-language-server/bin"

if [ "$UNAME" = "Darwin" ]; then
	# Homebrew, the best package manager ever. /s
	# Remove /opt/homebrew/bin if injected by path_helper via /etc/paths.d, then
	# re-add at front.
	if [ -d "$HOME/bin/homebrew" ]; then
		BREW_BIN="$HOME/bin/homebrew/bin"
	elif [ -d "/opt/homebrew" ]; then
		BREW_BIN="/opt/homebrew/bin"
	fi
	if [ -n "$BREW_BIN" ]; then
		PATH="${PATH//:$BREW_BIN:/:}"
		PATH="${PATH/#$BREW_BIN:/}"
		PATH="${PATH/%:$BREW_BIN/}"
		add_to_PATH "$BREW_BIN"
		unset BREW_BIN
	fi
	if which brew >/dev/null 2>&1; then
		BREW_PREFIX="$(brew --prefix)"
		if [ -e "$BREW_PREFIX/bin/bash" ]; then
			if ! grep -q -s "^$BREW_PREFIX/bin/bash$" /etc/shells; then
				echo "Don't forget to sudo vi /etc/shells to add $BREW_PREFIX/bin/bash!"
			fi
			export SHELL="$BREW_PREFIX/bin/bash"
		fi
		# Add python3 and the rest to PATH.
		add_to_PATH "$BREW_PREFIX/opt/python@3/libexec/bin"
		unset BREW_PREFIX
	fi
fi

# Go.
add_to_PATH "$HOME/src-oth/golang/bin"
add_to_PATH "$HOME/go/bin"

# Rust.
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
add_to_PATH "$HOME/sdk/bin"
add_to_PATH "$HOME/.cargo/bin"

# Android.
export ANDROID_HOME="$HOME/Android/Sdk"
add_to_PATH "$ANDROID_HOME/cmdline-tools/latest/bin"
add_to_PATH "$ANDROID_HOME/emulator"
add_to_PATH "$ANDROID_HOME/platform-tools"
