#!/bin/sh
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.
#
# - For C.H.I.P.:
#   - Flash with http://flash.getchip.com : Choose the Headless image.
#   - Connect with screen /dev/ttyACM0
#   - Make sure you the C.H.I.P. has network access. This simplest is:
#     nmcli device wifi list
#     sudo nmcli device wifi connect '<ssid>' password '<pwd>' ifname wlan0
#   - Run as:
#     curl -sSL https://raw.githubusercontent.com/maruel/bin_pub/master/devices/setup.sh | bash
# - For rasbian:
#   - Flash with ./flash_rasbian.sh

set -eu

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


# Raspbian
if [ "$(grep 'ID=' /etc/os-release)" == "ID=raspbian" ]; then
  sudo apt-get -y remove triggerhappy
  sudo apt-get install -y ntpdate
  # https://github.com/RPi-Distro/raspi-config/blob/master/raspi-config
  # 0 means enabled.
  raspi-config nonint do_spi 0
  raspi-config nonint do_i2c 0

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
  systemctl daemon-reload
  systemctl enable disable_hdmi.service

  # Use the us keyboard layout.
  sed -i 's/XKBLAYOUT="gb"/XKBLAYOUT="us"/' /etc/default/keyboard
  # Fix Wifi country settings for Canada.
  raspi-config nonint do_wifi_country CA

  # Switch to en_US.
  sed -i 's/en_GB/en_US/' /etc/locale.gen
  dpkg-reconfigure --frontend=noninteractive locales
  update-locale LANG=en_US.UTF-8
fi

# Obviously don't use that on your own C.H.I.P.; that's my keys. :)
KEYS='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKLhs80AouVRKus3NySEpRDwljUDC0V9dyNwhBuo4p6 maruel'

if [ "${USER:=root}" != "root" ]; then
  USERNAME="$USER"
  mkdir -p bin .ssh; git clone --recurse https://github.com/maruel/bin_pub bin/bin_pub; ./bin/bin_pub/setup_scripts/update_config.py
  echo "$KEYS" >>.ssh/authorized_keys
else
  # This needs to run as user:
  if [ -d /home/pi ]; then
    USERNAME=pi
  elif [ -d /home/chip ]; then
    USERNAME=chip
  else
    echo 'Unknown setup, aborting.'
    exit 1
  fi
  cd /home/$USERNAME
  sudo -n -u $USERNAME -s 'mkdir -p bin .ssh; git clone --recurse https://github.com/maruel/bin_pub bin/bin_pub; ./bin/bin_pub/setup_scripts/update_config.py'
  echo "$KEYS" >>/home/$USERNAME/.ssh/authorized_keys
  chown $USERNAME:$USERNAME /home/$USERNAME/.ssh/authorized_keys
fi

# Do not run on C.H.I.P. Pro because of lack of space.
/home/$USERNAME/bin/bin_pub/setup_scripts/install_golang.py --system
# Temporary until Go 1.8.
cat >> /home/$USERNAME/.profile <<'EOF'
export GOPATH=$HOME/go
EOF
chown $USERNAME:$USERNAME /home/$USERNAME/.profile

sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' $ROOT_PATH/etc/ssh/sshd_config
