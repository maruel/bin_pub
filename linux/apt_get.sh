#!/bin/sh
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Install useful packages I can't live without.
# Assumes minimal Ubuntu desktop/server 20.04.

set -eu

# These are occasionally useful:
#   gparted
#   libvirt
#   qemu-kvm
#   virt-manager
#   vlc
sudo apt install \
  git \
  ifstat \
  net-tools \
  ntpdate \
  python3 \
  smartmontools \
  sysstat \
  tmux \
  vim \
  wireless-tools

# Desktop:
# avahi-daemon
# evolution-data-server
# indicator-messages
sudo apt purge \
  apport \
  evince \
  whoopsie

# Ubuntu Server 20.04:
sudo apt purge \
  cloud-guest-utils \
  cloud-init \
  cloud-initramfs-copymods \
  cloud-initramfs-dyn-netconf \
  landscape-common \
  open-vm-tools \
  snapd \
  sosreport \
  ubuntu-advantage-tools

# On Ubuntu Server:
# sudo timedatectl set-timezone America/Toronto

sudo apt autoremove -y
