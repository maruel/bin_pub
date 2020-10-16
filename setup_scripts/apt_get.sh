#!/bin/sh
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Install useful packages I can't live without.
# Assumes minimal Ubuntu desktop/server 20.04.

set -eu

# Recent ssh-agent is finally kinda-working, so keychain isn't necessary
# anymore.
# These are occasionally useful: gparted vlc
sudo apt install \
  git ifstat ntpdate python3 smartmontools sysstat tmux vim \
  wireless-tools

# avahi-daemon
# evolution-data-server
# indicator-messages
sudo apt remove \
  apport \
  evince \
  whoopsie

sudo apt autoremove -y
