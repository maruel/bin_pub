#!/bin/bash
# Copyright 2016 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# Generate a hostname based on the serial number of the CPU with leading zeros
# trimmed off, it is a constant yet unique value.
#
# Set a short motd.

set -eu

# Automatic detection.
DIST="$(grep '^ID=' /etc/os-release | cut -c 4-)"
BOARD=unknown
if [ -f /etc/dogtag ]; then
  BOARD=beaglebone
fi
if [ -f /etc/chip_build_info.txt ]; then
  BOARD=chip
fi
if [ $DIST==raspbian ]; then
  BOARD=raspberrypi
fi

# Get the CPU serial number, otherwise the systemd machine ID.
SERIAL="$(cat /proc/cpuinfo | grep Serial | cut -d ':' -f 2 | sed 's/^[ 0]\+//')"
if [ "$SERIAL" == "" ]; then
  SERIAL="$(hostnamectl status | grep 'Machine ID' | cut -d ':' -f 2 | cut -c 2-)"
fi
# On ODROID, Serial is 1b00000000000000.
if [ "$SERIAL" == "1b00000000000000" ]; then
  SERIAL="$(hostnamectl status | grep 'Machine ID' | cut -d ':' -f 2 | cut -c 2-)"
fi

# Cut to keep the last 4 characters. Otherwise this quickly becomes unwieldy.
# The first characters cannot be used because they matches when buying multiple
# devices at once. 4 characters of hex encoded digits gives 65535 combinations.
# Taking in account there will be at most 255 devices on the network subnet, it
# should be "good enough". Increase to 5 if needed.
SERIAL="$(echo $SERIAL | sed 's/.*\(....\)/\1/')"

HOST="$BOARD-$SERIAL"
echo "- New hostname is: $HOST"
if [ $BOARD=raspberrypi ]; then
  sudo raspi-config nonint do_hostname $HOST
else
  # It hangs on the CHIP (?)
  sudo sed -i "s/$OLD/$HOST/" /etc/hostname
  sudo sed -i "s/$OLD/$HOST/" /etc/hosts
  #sudo hostnamectl set-hostname $HOST
fi

echo "- Changing MOTD"
echo "Welcome to $HOST" | sudo tee /etc/motd
