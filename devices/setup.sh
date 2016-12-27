#!/bin/sh
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.
#
# - For C.H.I.P.:
#   - User/pwd: chip/chip
#   - Flash with http://flash.getchip.com : Choose the Headless image.
#   - Connect with screen /dev/ttyACM0
#   - Make sure you the C.H.I.P. has network access. This simplest is:
#     nmcli device wifi list
#     sudo nmcli device wifi connect '<ssid>' password '<pwd>' ifname wlan0
#   - Run as:
#     curl -sSL https://raw.githubusercontent.com/maruel/bin_pub/master/devices/setup.sh | bash
# - For rasbian:
#   - User/pwd: pi/raspberry
#   - Flash with ./flash_rasbian.sh
# - For Beaglebone:
#   - User/pwd: debian/temppwd
#   - sudo connmanctl services; sudo connmanctl connect wifi...

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


# Automatic detection
DIST="$(grep '^ID=' /etc/os-release | cut -c 4-)"
BEAGLEBONE=0
if [ -f /etc/dogtag ]; then
  BEAGLEBONE=1
fi

# Raspbian
if [ $DIST==raspbian ]; then
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

if [ $BEAGLEBONE=1 ]; then
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

# Obviously don't use that on your own C.H.I.P.; that's my keys. :)
KEYS='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKLhs80AouVRKus3NySEpRDwljUDC0V9dyNwhBuo4p6 maruel'

if [ "${USER:=root}" != "root" ]; then
  echo "Running as $USER"
  USERNAME="$USER"
  mkdir -p bin .ssh; git clone --recurse https://github.com/maruel/bin_pub bin/bin_pub; ./bin/bin_pub/setup_scripts/update_config.py
  echo "$KEYS" >>.ssh/authorized_keys
else
  # This needs to run as user:
  if [ -d /home/pi ]; then
    # Default on Raspbian.
    USERNAME=pi
  elif [ -d /home/chip ]; then
    # Default on C.H.I.P.
    USERNAME=chip
  elif [ -d /home/debian ]; then
    # Default on Beaglebone and Armbian.
    USERNAME=debian
  else
    echo 'Unknown setup, aborting.'
    exit 1
  fi
  echo "Using /home/$USERNAME"
  cd /home/$USERNAME
  sudo -n -u $USERNAME sh -c 'cd; mkdir -p bin .ssh; git clone --recurse https://github.com/maruel/bin_pub bin/bin_pub; ./bin/bin_pub/setup_scripts/update_config.py'
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

sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
