#!/bin/bash
# Copyright 2020 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -eu

echo "Formats a disk, create a single partition, encrypts it with LUKS."
echo "Warning: This script is dangerous."

if [ $# != 2 ]; then
  echo "Usage: format_luks.sh <drive> <mountpoint>"
  echo ""
  echo "ex:"
  echo " format_luks.sh sdc /mnt/hdd "
  exit 1
fi

DRIVE=/dev/$1
MNTPOINT=$2
MAPPER=$1_crypt

echo "Drive: ${DRIVE}"
echo "Mount: ${MNTPOINT}"
echo "Mapper: ${MAPPER}"

# TODO(maruel): Disallow already mounted disk.

#echo "-> Query SMART infos"
#sudo smartctl -a ${DRIVE}
#echo "-> Show hierarchy"
#lsblk

if false; then
  echo "-> Clearing disk"
  # Only useful for HDD:
  #sudo dd if=/dev/zero of=${DRIVE} bs=1M status=progress conv=fsync
  #sudo hdparm -I ${DRIVE}
  # This won't work on a Dell, when showing "frozen".
  # Enable the password "p" in the bios with F2, do not unlock it, then skip to
  # --security-erase.
  sudo hdparm --user-master u --security-set-pass p ${DRIVE}
  sudo hdparm --user-master u --security-erase p  ${DRIVE}
fi

echo "-> Creating GPT"
echo "-> Press g, then w"
sudo fdisk ${DRIVE}

echo "-> Creating unformatted partition"
echo "-> Press n, <accept defaults>, w"
sudo fdisk ${DRIVE}

echo "-> Encrypting"
sudo cryptsetup -v -y luksFormat ${DRIVE}1
sudo cryptsetup luksOpen ${DRIVE}1 ${MAPPER}
sudo mkfs.ext4 /dev/mapper/${MAPPER}

echo "-> Setting up mount point"
if [ ! -d $MNTPOINT ]; then
  sudo mkdir $MNTPOINT
fi
sudo mount /dev/mapper/${MAPPER} ${MNTPOINT}
sudo chown -R ${USER}:${USER} $MNTPOINT

if false; then
  echo "-> Mounting"
  sudo cryptsetup luksOpen ${DRIVE}1 ${MAPPER}
  sudo mount /dev/mapper/${MAPPER} ${MNTPOINT}
fi

if false; then
  echo "-> Unmounting"
  #sudo umount ${MNTPOINT}
  sudo umount /dev/mapper/${MAPPER}
  sudo cryptsetup luksClose /dev/mapper/${MAPPER}
fi

if false; then
  # This works seamlessly if you use the same password on all disks.
  echo "-> Setup automatic unlock"
  # TODO(maruel): Doesn't work here, had to use gparted to get the crypted UUID.
  eval `blkid -o export /dev/mapper/${MAPPER}`
  echo "${MAPPER} UUID=${UUID} none luks,discard" | sudo tee --append /etc/crypttab
  echo "/dev/mapper/${MAPPER} ${MNTPOINT} ext4 errors=remount-ro 0 2" | sudo tee --apend /etc/fstab
fi

if false; then
  KEYFILE=${MAPPER}
  echo "-> Create keyfile for automatic mount"
  sudo dd if=/dev/random of=/root/${KEYFILE} bs=1024 count=4
  sudo chmod 0400 /root/${KEYFILE}
  sudo cryptsetup luksAddKey ${DRIVE}1 /root/${KEYFILE}
  # TODO(maruel): Doesn't work here, had to use gparted to get the crypted UUID.
  eval `blkid -o export /dev/mapper/${MAPPER}`
  echo "${MAPPER} UUID=${UUID} /root/${KEYFILE} luks,discard" | sudo tee --append /etc/crypttab
  echo "/dev/mapper/${MAPPER} ${MNTPOINT} ext4 errors=remount-ro 0 2" | sudo tee --apend /etc/fstab
fi
