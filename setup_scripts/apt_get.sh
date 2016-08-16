#!/bin/sh
#Copyright 2016 (c) Marc-Antoine Ruel. All rights reserved.
# If you are seeing this file, I screwed up.

# Install useful packages I can't live without.
# Assumes very minimal Ubuntu desktop/server 16.04 or later, or Raspbian Jessie
# Lite installation.

set -eu

sudo apt-get install -y \
  git ifstat ntpdate openssh sysstat tmux wireless-tools vim
