#!/bin/bash
# Copyright 2024 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -eu
cd "$(dirname $0)"
cd ..

# https://github.com/neovim/neovim/blob/master/INSTALL.md

# Always start over from scratch.
rm -rf nvim
mkdir -p nvim

curl -sSL -o nvim/nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz
tar -C nvim --strip-components=1 -xzf nvim/nvim.tar.gz
rm nvim/nvim.tar.gz
./nvim/bin/nvim --version

echo "Install ripgrep, necessary for telescope.nvim"
brew install ripgrep

