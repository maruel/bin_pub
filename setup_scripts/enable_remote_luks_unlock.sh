#!/bin/sh
#Copyright 2016 (c) Marc-Antoine Ruel. All rights reserved.
# If you are seeing this file, I screwed up.

# Assumes very minimal Ubuntu desktop/server 16.04 or later, or Raspbian Jessie
# Lite installation.

set -eu
cd "$(dirname $0)"

if [ "$USER" != "root" ]; then
  echo "This script does heavy system modification and must be run as root"
  exit 1
fi

# Doing this before dropbear will make it not complain.
echo "- Copy authorized_keys to initram-fs"
mkdir -p /etc/initramfs-tools/root/.ssh
cp .ssh/authorized_keys /etc/initramfs-tools/root/.ssh/

echo "- Install dropbear"
apt-get install -y dropbear

echo "- Enable dropbear in initramfs"
sed -i 's/#DROPBEAR=y/DROPBEAR=y/' /etc/initramfs-tools/conf-hooks.d/dropbear

echo "- Copy host key to initramfs so SSH clients are not confused"
/usr/lib/dropbear/dropbearconvert openssh dropbear /etc/ssh/ssh_host_dsa_key /etc/initramfs-tools/etc/dropbear/dropbear_dss_host_key
/usr/lib/dropbear/dropbearconvert openssh dropbear /etc/ssh/ssh_host_ecdsa_key /etc/initramfs-tools/etc/dropbear/dropbear_ecdsa_host_key
/usr/lib/dropbear/dropbearconvert openssh dropbear /etc/ssh/ssh_host_rsa_key /etc/initramfs-tools/etc/dropbear/dropbear_rsa_host_key

echo "- Enable motd"
echo 'To unlock root-partition run "unlock"' >> /etc/initramfs-tools/etc/motd

echo "- Create the unlock script"
cat > /etc/initramfs-tools/sbin/unlock << 'EOF'
#!/bin/sh
if PATH=/lib/unlock:/bin:/sbin /scripts/local-top/cryptroot; then
  kill `ps | grep cryptroot | grep -v "grep" | awk '{print \$1}'`
  # following line kill the remote shell right after the passphrase has
  # been entered.
  kill -9 `ps | grep "\-sh" | grep -v "grep" | awk '{print \$1}'`
  exit 0
fi
exit 1
EOF
chmod +x /etc/initramfs-tools/sbin/unlock
mkdir -p /etc/initramfs-tools/lib/unlock
cat > /etc/initramfs-tools/lib/unlock/plymouth << 'EOF'
#!/bin/sh
[ "\$1" == "--ping" ] && exit 1
/bin/plymouth "\$@"
EOF
chmod +x /etc/initramfs-tools/lib/unlock/plymouth

echo "- Update the initramfs boot partition"
update-initramfs -u
