#!/bin/bash
# Copyright 2025 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -eu

# This installs local and does sane things so it's good enough.
# TEMP_FILE=$(mktemp /tmp/downloaded_script.XXXXX
TEMP_FILE=$(mktemp /tmp/install_cargo.XXXXXX.sh)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o $TEMP_FILE

# To diagnose:
# sh $TEMP_FILE --help

# The first time it downloads tarballs, the second time it is run on a system it'll build.
sh $TEMP_FILE -y --no-modify-path
rm $TEMP_FILE

# Needed for nvim telescope plugin
$HOME/.cargo/bin/cargo install ripgrep
# Testing to see if I like it
$HOME/.cargo/bin/cargo install git-delta

echo "Don't forget to restart your shell so rust and cargo are in PATH!"
