#!/bin/sh
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.
#
# - Flash with https://flash.getchip.com
# - Connect with screen /dev/ttyACM0
# - Make sure you the C.H.I.P. has network access. This simplest is:
#     nmcli device wifi list
#     sudo nmcli device wifi connect '<ssid>' password '<pwd>' ifname wlan0
# - Run as:
#   curl -sSL https://raw.githubusercontent.com/maruel/bin_pub/master/devices/chip.sh | bash

set -eu

sudo apt-get update
sudo apt-get upgrade -y
# If you are space constrained, here's the approximative size:
# git:  17.7MB
# python: 18MB
# ssh:   130kB
# tmux:  670kB
sudo apt-get install -y git tmux vim python ssh
mkdir -p bin .ssh
git clone --recurse https://github.com/maruel/bin_pub bin/bin_pub
./bin/bin_pub/setup_scripts/update_config.py

# Do not run on C.H.I.P. Pro because of lack of space.
sudo ./bin/bin_pub/setup/install_golang.py --system
# Temporary until Go 1.8.
cat >> .profile <<'EOF'
export GOPATH=$HOME/go
EOF

# Obviously don't use that on your own C.H.I.P.; that's my keys. :)
cat > .ssh/authorized_keys <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKLhs80AouVRKus3NySEpRDwljUDC0V9dyNwhBuo4p6 maruel
EOF
