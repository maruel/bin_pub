#!/bin/sh
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Install useful packages I can't live without.
# Assumes very minimal Ubuntu desktop/server 16.04 or later, or Raspbian Jessie
# Lite installation.

set -eu

sudo apt install -y \
  git ifstat gparted keychain ntpdate python smartmontools sysstat tmux vim \
  vlc wireless-tools

sudo apt remove -y deja-dup evolution-data-server 'libreoffice*' \
  'thunderbird*' unity-scope-gdrive unity-scope-yelp

sudo apt autoremove -y
