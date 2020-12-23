#!/bin/sh
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -eu

if  [ ! -d ~/.config/autostart ]; then
  mkdir ~/.config/autostart
fi
cat << EOF > ~/.config/autostart/keychain.desktop
[Desktop Entry]
Type=Application
Name=Keychain SSH/GPG Key Agent
Exec=keychain --quiet --agents ssh,gpg
EOF
