#!/bin/bash

# https://www.erianna.com/adding-an-secondary-encrypted-drive-with-lvm-to-ubuntu-linux/

set -eu

if [ "$EUID" -eq 0 ]; then
  echo "Please do not run as root"
  exit 1
fi

# Change these:
DEV="vdb1REPLACEME"
DST="/mnt/${DEV}"

echo "You have to Setup GPT via gparted / fdisk first"

echo "Formatting LUKS on /dev/${DEV}"
sudo cryptsetup -v luksFormat /dev/${DEV}

echo "Setup the LUKS FDE password"
sudo cryptsetup luksOpen /dev/${DEV} ${DEV}_crypt

# Setup a "physical volume"; seems optional?
#sudo pvcreate /dev/mapper/${DEV}_crypt

echo 'Setup a "volume group"'
sudo vgcreate crypt_${DEV}_vg /dev/mapper/${DEV}_crypt

echo 'Setup a "logical volume"'
sudo lvcreate -l 100%FREE -n data /dev/crypt_${DEV}_vg

echo "Format the logical volume as ext4"
sudo mkfs.ext4 /dev/crypt_${DEV}_vg/data

echo "Create the mount partition if not present"
if [ ! -d ${DST} ]; then
        sudo mkdir ${DST}
fi

echo "Mount the partition"
sudo mount /dev/crypt_${DEV}_vg/data ${DST}

echo "Set the owner to $USER"
sudo chown $USER:$USER ${DST}
