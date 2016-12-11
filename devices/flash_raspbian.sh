#!/bin/bash
# Copyright 2016 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# Fetches Raspbian Jessie Lite and flash it to an SDCard.
# Then it updates the SDCard so it automatically self-initializes on
# first boot.

set -eu
cd "$(dirname $0)"

if [ "$#" -ne 2 ]; then
  echo "Flashes a customized version of Raspbian that automatically"
  echo "sets itself up."
  echo ""
  echo "usage: ./flash.sh /dev/<sdcard_path> <ssid>"
  exit 1
fi

SDCARD=$1
SSID="$2"

echo "Warning! This will blow up everything in $SDCARD"
echo ""
echo "This script has minimal use of 'sudo' for 'dd' and modifying the partitions"
echo ""

echo "- Unmounting"
./prep/umount.sh $SDCARD &>/dev/null


# TODO(maruel): Figure the name automatically.
IMGNAME=2016-11-25-raspbian-jessie-lite.img
if [ ! -f $IMGNAME ]; then
  echo "- Fetching Raspbian Jessie Lite latest"
  curl -L -o raspbian_lite_latest.zip https://downloads.raspberrypi.org/raspbian_lite_latest
  unzip raspbian_lite_latest.zip
fi


echo "- Flashing (takes 2 minutes)"
sudo /bin/bash -c "time dd bs=4M if=$IMGNAME of=$SDCARD"
echo "- Flushing I/O cache"
# This is important otherwise the mount afterward may 'see' the old partition
# table.
time sync


echo "- Reloading partition table"
# Wait a bit to try to workaround "Error looking up object for device" when
# immediately using "/usr/bin/udisksctl mount" after this script.
sudo partprobe $SDCARD
sync
sleep 1
# Needs 'p' for /dev/mmcblkN but not for /dev/sdX
while [ ! -b ${SDCARD}*2 ]; do
  echo " (still waiting for partition to show up)"
  sleep 1
done


echo "- Mounting"
./prep/umount.sh $SDCARD  &>/dev/null
# Needs 'p' for /dev/mmcblkN but not for /dev/sdX
BOOT=$(LANG=C /usr/bin/udisksctl mount -b ${SDCARD}*1 | sed 's/.\+ at \(.\+\)\+\./\1/')
echo "- /boot mounted as $BOOT"
ROOT=$(LANG=C /usr/bin/udisksctl mount -b ${SDCARD}*2 | sed 's/.\+ at \(.\+\)\+\./\1/')
echo "- / mounted as $ROOT"


# https://www.raspberrypi.org/documentation/remote-access/ssh/
sudo touch $BOOT/ssh


# Skip this if you don't use a small display.
# Strictly speaking, you won't need a monitor at all since ssh will be up and
# running and the device will connect to the SSID provided.
# Search for [5 Inch 800x480], found one at 23$USD with free shipping on
# aliexpress.
echo "- Enabling 5\" display support (optional)"
sudo tee --append $BOOT/config.txt > /dev/null <<EOF

# Enable support for 800x480 display:
hdmi_group=2
hdmi_mode=87
hdmi_cvt 800 480 60 6 0 0 0

# Enable touchscreen:
# Not necessary on Jessie Lite since it boots in console mode. :)
# Some displays use 22, others 25.
# Enabling this means the SPI bus cannot be used anymore.
#dtoverlay=ads7846,penirq=22,penirq_pull=2,speed=10000,xohms=150

EOF


echo "- First boot setup script"
sudo cp ./setup.sh $ROOT/root/firstboot.sh
sudo chmod +x $ROOT/root/firstboot.sh
# Skip this step to debug firstboot.sh. Then login at the console and run the
# script manually.
sudo mv $ROOT/etc/rc.local $ROOT/etc/rc.local.old
sudo tee $ROOT/etc/rc.local > /dev/null <<'EOF'
#!/bin/sh -e
# Copyright 2016 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# As part of https://github.com/maruel/bin_pub

LOG_FILE=/var/log/firstboot.log
if [ ! -f $LOG_FILE ]; then
  /root/firstboot.sh 2>&1 | tee $LOG_FILE
fi
exit 0
EOF
sudo chmod +x $ROOT/etc/rc.local


echo "- SSH keys"
# This assumes you have properly set your own ssh keys and plan to use them.
sudo mkdir $ROOT/home/pi/.ssh
sudo cp $HOME/.ssh/authorized_keys $ROOT/home/pi/.ssh/authorized_keys
# pi(1000).
sudo chown -R 1000:1000 $ROOT/home/pi/.ssh
# Force key based authentication since the password is known.
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' $ROOT/etc/ssh/sshd_config


echo "- Wifi"
# TODO(maruel): Get the data from /etc/NetworkManager/system-connections/*
SSID="$2"
# TODO(maruel): When not found, ask the user for the password. It's annoying to
# test since the file is only readable by root.
# TODO(maruel): Ensure it works with SSID with whitespace/emoji in their name.
if [ ! -f "/etc/NetworkManager/system-connections/$SSID" ]; then
  read -r -p "Password for SSID $SSID: " WIFI_PWD
else
  WIFI_PWD="$(sudo grep -oP '(?<=psk=).+' /etc/NetworkManager/system-connections/$SSID)"
fi
sudo tee --append $ROOT/etc/wpa_supplicant/wpa_supplicant.conf > /dev/null <<EOF

network={
  ssid="$SSID"
  psk="$WIFI_PWD"
}
EOF


echo "- Unmounting"
sync
./prep/umount.sh $SDCARD

echo ""
echo "You can now remove the SDCard safely and boot your Raspberry Pi"
echo "Then connect with:"
echo "  ssh -o StrictHostKeyChecking=no pi@raspberrypi"
echo ""
echo "You can follow the update process by either connecting a monitor"
echo "to the HDMI port or by ssh'ing into the Pi and running:"
echo "  tail -f /var/log/firstboot.log"
