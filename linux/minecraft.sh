#!/bin/bash
# Copyright 2022 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Install Minecraft server.
# https://github.com/itzg/docker-minecraft-server/blob/master/README.md

set -eu

if ! which podman &> /dev/null; then
  echo "sudo apt install podman"
  exit 1
fi

podman pull docker.io/itzg/minecraft-server

cd ~/.config/systemd/user/
# -e ENFORCE_WHITELIST=TRUE
# -e WHITELIST_FILE=foo
# -e OPS_FILE=foo
#podman run -d --name minecraft -p 25565:25565 -e EULA=TRUE -e MAX_PLAYERS=50 -e DIFFICULTY=normal docker.io/itzg/minecraft-server
podman generate systemd --name minecraft --files --new docker.io/itzg/minecraft-server
systemctl --user daemon-reload
systemctl --user enable container-minecraft.service

echo "Edit with: -p 25565:25565 -e EULA=TRUE"
echo "vim ~/.config/systemd/user/container-minecraft.service"
echo "systemctl --user daemon-reload"
echo "systemctl --user restart container-minecraft.service"
echo "systemctl --user status container-minecraft.service"
echo "podman ps"

# Auto-start at boot?
# loginctl enable-linger
