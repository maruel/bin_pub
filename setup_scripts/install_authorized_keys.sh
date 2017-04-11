#!/bin/sh
# Copyright 2017 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Run as:
#   curl -sSL https://raw.githubusercontent.com/maruel/bin_pub/master/setup_scripts/install_authorized_keys.sh
#   | bash
#   curl -sSL https://goo.gl/cWtNmx | bash
#
# Setup maruel's public key.

set -eu

# TODO(maruel): Disallow running as root.

if [ ! -d $HOME/.ssh ]; then
  mkdir -p $HOME/.ssh
fi
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPuXx13VbQQGbYEPAw5UIAbKmoMs45/HD/bsjXDR6WtQ Agent Jean' >> $HOME/.ssh/authorized_keys
