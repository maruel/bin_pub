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

echo "Auto-mount /dev/${DEV} upon boot"

echo "Create a key"
sudo dd if=/dev/urandom of=/root/.${DEV}_keyfile bs=1024 count=4
sudo chmod 0400 /root/.${DEV}_keyfile

echo "Add this key as being valid."
sudo cryptsetup luksAddKey /dev/${DEV} /root/.${DEV}_keyfile

echo "Add it to crypttab"
# blkid /dev/${DEV}
UUID=$(eval `sudo blkid --output=export /dev/${DEV}`; echo $UUID)
echo "${DEV}_crypt UUID=${UUID} /root/.${DEV}_keyfile luks,discard" | sudo tee --append /etc/crypttab

echo "Add it to fstab"
echo "/dev/mapper/${DEV}_crypt  ${DST}   ext4    defaults        0       2" | sudo tee --append /etc/fstab

sudo update-initramfs -u
