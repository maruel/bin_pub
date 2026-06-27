#!/bin/sh
# Copyright 2022 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -eu

echo 'source $HOME/.bash_aliases' >> ~/.bash_profile
# Ugh
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
