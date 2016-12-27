#!/bin/bash
# Copyright 2016 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# Generate a hostname based on the serial number of the CPU with leading zeros
# trimmed off, it is a constant yet unique value.
#
# Set a short motd.

set -eu

# Get the CPU serial number, otherwise the systemd machine ID.
SERIAL="$(cat /proc/cpuinfo | grep Serial | cut -d ':' -f 2 | sed 's/^[ 0]\+//')"
if [ "$SERIAL" == "" ]; then
  SERIAL="$(hostnamectl status | grep 'Machine ID' | cut -d ':' -f 2 | cut -c 2- | cut -c -8)"
fi

# Usually "raspberrypi" or "chip". Keep it.
OLD="$(hostname)"

HOST="$OLD-$SERIAL"
echo "- New hostname is: $HOST"
if [ "$(grep 'ID=' /etc/os-release)" == "ID=raspbian" ]; then
  sudo raspi-config nonint do_hostname $HOST
else
  # It hangs on the CHIP (?)
  sudo sed -i "s/$OLD/$HOST/" /etc/hostname
  sudo sed -i "s/$OLD/$HOST/" /etc/hosts
  #sudo hostnamectl set-hostname $HOST
fi

echo "- Changing MOTD"
echo "Welcome to $HOST" | sudo tee /etc/motd