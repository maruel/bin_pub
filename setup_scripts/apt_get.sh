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

sudo apt remove -y apport cups deja-dup evince evolution-data-server \
  'libreoffice*' shotwell \
  'thunderbird*' unity-scope-gdrive unity-scope-yelp \
  zeitgeist-core

sudo apt autoremove -y
