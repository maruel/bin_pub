#!/bin/sh
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Install useful packages I can't live without.
# Assumes very minimal Ubuntu desktop/server 16.04 or later, or Raspbian Jessie
# Lite installation.

set -eu

sudo apt-get install -y \
  git ifstat keychain ntpdate python sysstat tmux wireless-tools vim
