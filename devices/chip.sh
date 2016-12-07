#!/bin/sh
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.
#
# - Flash with http://flash.getchip.com
#   - Choose the Headless image.
# - Connect with screen /dev/ttyACM0
# - Make sure you the C.H.I.P. has network access. This simplest is:
#     nmcli device wifi list
#     sudo nmcli device wifi connect '<ssid>' password '<pwd>' ifname wlan0
# - Run as:
#   curl -sSL https://raw.githubusercontent.com/maruel/bin_pub/master/devices/chip.sh | bash

set -eu

# Obviously don't use that on your own C.H.I.P.; that's my keys. :)
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKLhs80AouVRKus3NySEpRDwljUDC0V9dyNwhBuo4p6 maruel' >>.ssh/authorized_keys

sudo apt-get update
sudo apt-get upgrade -y
# If you are space constrained, here's the approximative size:
# git:    17.7MB
# ifstat:  3.3MB
# python:   18MB
# sysstat: 1.3MB
# ssh:     130kB
# tmux:    670kB
# vim:      28MB (!)
sudo apt-get install -y git ifstat python ssh sysstat tmux vim
mkdir -p bin .ssh
git clone --recurse https://github.com/maruel/bin_pub bin/bin_pub
./bin/bin_pub/setup_scripts/update_config.py

# Do not run on C.H.I.P. Pro because of lack of space.
sudo ./bin/bin_pub/setup_scripts/install_golang.py --system
# Temporary until Go 1.8.
cat >> .profile <<'EOF'
export GOPATH=$HOME/go
EOF
