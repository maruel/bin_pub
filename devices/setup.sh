#!/bin/sh
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Run as:
#   curl -sSL https://raw.githubusercontent.com/maruel/bin_pub/master/devices/setup.sh | bash
#
# - For C.H.I.P.:
#   - User/pwd: chip/chip
#   - Flash with http://flash.getchip.com : Choose the Headless image.
#   - Connect with screen /dev/ttyACM0
#   - Make sure you the C.H.I.P. has network access. This simplest is:
#     nmcli device wifi list
#     sudo nmcli device wifi connect '<ssid>' password '<pwd>' ifname wlan0
# - For rasbian:
#   - User/pwd: pi/raspberry
#   - Flash with ./flash_rasbian.sh
# - For Beaglebone:
#   - User/pwd: debian/temppwd
#   - sudo connmanctl services; sudo connmanctl connect wifi...
# - For ODROID-C1 with Ubuntu 16.04.1 minimal:
#   - adduser odroid
#   - usermod -a -G sudo odroid
#   - apt install curl

set -eu

# Try to work around:
#  WARNING: The following packages cannot be authenticated!
sudo apt-key update
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


# Automatic detection.
DIST="$(grep '^ID=' /etc/os-release | cut -c 4-)"
BOARD=unknown
if [ -f /etc/dogtag ]; then
  BOARD=beaglebone
fi
if [ -f /etc/chip_build_info.txt ]; then
  BOARD=chip
fi
# TODO(maruel): detect odroid.
if [ $DIST==raspbian ]; then
  BOARD=raspberrypi
fi
echo "Detected board: $BOARD"


if [ $BOARD = beaglebone ]; then
  # The Beaglebone comes with a lot of packages, which fills up the small 4Gb
  # eMMC quickly. Make some space as we won't be using these.
  # Use the following to hunt and kill:
  #   dpkg --get-selections | less
  sudo apt-get remove -y \
    'ruby*' \
    apache2 \
    apache2-bin \
    apache2-data \
    apache2-utils \
    bb-bonescript-installer-beta \
    bb-cape-overlays \
    bb-customizations \
    bb-doc-bone101-jekyll \
    bb-node-red-installer \
    c9-core-installer \
    jekyll \
    nodejs \
    x11-common
    # Removing one these causes the ethernet over USB to fail:
    #rcn-ee-archive-keyring \
    #rcnee-access-point \
    #seeed-wificonfig-installer \
  sudo apt-get purge -y apache2 mysql-common x11-common

  echo "Enabling SPI"
  #git clone https://github.com/beagleboard/bb.org-overlays
  cd /opt/source/bb.org-overlays
  ./dtc-overlay.sh
  ./install.sh

  cat >> /boot/uEnv.txt << EOF

# maruel
cape_enable=bone_capemgr.enable_partno=BB-SPIDEV0
EOF

fi


if [ $BOARD = chip ]; then
  echo "TODO: C.H.I.P."
fi


if [ $BOARD = odroid ]; then
  echo "TODO: O-DROID"
fi


if [ $BOARD = raspberrypi ]; then
  sudo apt-get -y remove triggerhappy
  sudo apt-get install -y ntpdate
  # https://github.com/RPi-Distro/raspi-config/blob/master/raspi-config
  # 0 means enabled.
  sudo raspi-config nonint do_spi 0
  sudo raspi-config nonint do_i2c 0

  echo "raspi-config done"
  cat > /etc/systemd/system/hdmi_disable.service << EOF
[Unit]
Description=Disable HDMI output to lower overall power consumption
After=auditd.service

[Service]
Type=oneshot
Restart=no
# It is only present on Raspbian.
ExecStart=/bin/sh -c '[ -f /opt/vc/bin/tvservice ] && /opt/vc/bin/tvservice -o || true'

[Install]
WantedBy=default.target
EOF
  sudo systemctl daemon-reload
  sudo systemctl enable hdmi_disable

  # Use the us keyboard layout.
  sudo sed -i 's/XKBLAYOUT="gb"/XKBLAYOUT="us"/' /etc/default/keyboard
  # Fix Wifi country settings for Canada.
  sudo raspi-config nonint do_wifi_country CA

  # Switch to en_US.
  sudo sed -i 's/en_GB/en_US/' /etc/locale.gen
  sudo dpkg-reconfigure --frontend=noninteractive locales
  sudo update-locale LANG=en_US.UTF-8
fi


# Install ~/bin/bin_pub; optional.
if [ "${USER:=root}" != "root" ]; then
  echo "Running as $USER"
  USERNAME="$USER"
  mkdir -p bin; git clone --recurse https://github.com/maruel/bin_pub bin/bin_pub; ./bin/bin_pub/setup_scripts/update_config.py
else
  # This needs to run as user:
  if [ $BOARD = beaglebone ]; then
    USERNAME=debian
  elif [ $BOARD = chip ]; then
    USERNAME=chip
  elif [ $BOARD = raspberrypi ]; then
    USERNAME=pi
  elif [ $BOARD = odroid ]; then
    # Manually created on ODROID Ubuntu 16.04 minimal.
    USERNAME=odroid
  else
    echo "Unknown board $BOARD, aborting."
    exit 1
  fi
  echo "Using /home/$USERNAME"
  cd /home/$USERNAME
  sudo -n -u $USERNAME sh -c 'cd; mkdir -p bin; git clone --recurse https://github.com/maruel/bin_pub bin/bin_pub; ./bin/bin_pub/setup_scripts/update_config.py'
fi


# Obviously don't use that on your own device; that's my keys. :)
# Uncomment and put your keys if desired. flash.py already handles this.
# KEYS='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKLhs80AouVRKus3NySEpRDwljUDC0V9dyNwhBuo4p6 maruel'
#if [ "${USER:=root}" != "root" ]; then
#  mkdir -p .sshI
#  echo "$KEYS" >>.ssh/authorized_keys
#else
#  mkdir -p /home/$USERNAME/.ssh
#  echo "$KEYS" >>/home/$USERNAME/.ssh/authorized_keys
#  chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
#fi


if [ -f /home/$USERNAME/.ssh/authorized_keys ]; then
  echo "Disabling ssh password authentication support"
  sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
fi


if [ $BOARD=odroid ]; then
  # OMG WTF.
  echo "Disabling root ssh support"
  sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
fi


# TODO(maruel): Do not run on C.H.I.P. Pro because of lack of space.
# This installs tooling as root as binary install.
sudo /home/$USERNAME/bin/bin_pub/setup_scripts/install_golang.py --system
#sudo -n -u $USERNAME sh -c '/home/$USERNAME/bin/bin_pub/setup_scripts/install_golang.py --skip'
