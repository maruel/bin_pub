#!/bin/sh
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Background
#
# If you don't want to be owned, you probably already set
# "PasswordAuthentication no" in your /etc/ssh/sshd_config. But then ecryptfs
# encrypted home directory can't reach your .ssh/authorized_keys unless you were
# already logged in, which is annoying. This script enables this functionality
# back.
#
# Some background first so you understand what you are doing: when a user has an
# ecryptfs'ed home directory, he has in fact 3 personal directories:
#
# - /home/$USER: The real directory, which is **not** accessible as soon as the
#   ecrypted directory is mounted. This directory should always be mode 500,
#   e.g. read-only by its user only.
# - /home/$USER: The virtual decrypted directory, which is mapped automatically
#   on X login or with the command *ecryptfs-mount-private* in Ubuntu.
# - /home/.ecryptfs/$USER: The datastore for the virtual /home/$USER directory.
#   The content is located at /home/.ecryptfs/$USER/.Private. This directory is
#   accessible by the user all the time, unlike the two directories above.
#   We'll use this as a gateway to store files that must be accessible at all
#   times. Each files in the virtual home directory are stored encrypted with
#   /home/.ecryptfs/maruel/.ecryptfs/wrapped-passphrase and the filenames are
#   encrypted too.
#
# Goals
#
# 1. Create a *.ssh/authorized_keys* that is always accessible. Then make sure
#    that */home/$USER/.ssh/authorized_keys* points to it, independent of the
#    fact your encrypted home directory is mounted or not. We'll use symlinks
#    for that.
# 2. Create a *.profile* and in your real */home/$USER* directory that
#    automatically decrypt your virtual home directory on first login through
#    ssh and umount on your last login. Note that keeping a screen session
#    active or an X session active will keep your virtual home directory
#    mounted.
#
# Notes
#
# - ecryptfs has side channel leakage, the filenames do not have independent IV,
#   so you easily can deduce the approximate filename length. Oh well.
# - The commands above assume
#   - Ubuntu
#   - bash
#   - Your home directory lives in /home/$USER

set -eu

cd "$HOME"

if [ ! -f /usr/bin/ecryptfs-umount-private ]; then
  sudo apt install ecryptfs-utils
fi

echo "Preparation work: make .ssh/authorized_keys always accessible"
mkdir -p /home/.ecryptfs/$USER/.ssh
chmod 0700 /home/.ecryptfs/$USER/.ssh
if [ -L .ssh/authorized_keys ]; then
  echo ".ssh/authorized_keys is already a symlink, oops"
  exit 1
fi
if [ ! -f .ssh/authorized_keys ]; then
  echo ".ssh/authorized_keys must be present"
  exit 1
fi
mv .ssh/authorized_keys /home/.ecryptfs/$USER/.ssh/authorized_keys
chmod 400 /home/.ecryptfs/$USER/.ssh/authorized_keys
chmod 500 /home/.ecryptfs/$USER/.ssh
ln -s /home/.ecryptfs/$USER/.ssh/authorized_keys $HOME/.ssh/authorized_keys

echo "Unmount the encrypted home directory to see the real unencrypted home directory"
ecryptfs-umount-private
echo "Jump to the real /home/$USER"
# It's mostly empty except with 2 symlinks. Add the necessary .ssh/ file.
cd $HOME
chmod 700 .
mkdir -p .ssh
ln -s /home/.ecryptfs/$USER/.ssh/authorized_keys $HOME/.ssh/authorized_keys
chmod 500 .ssh

echo "Create the auto-mount script"
# So you can easily mount your encrypted home directory via ssh. Note that this
# script is *not* accessible when ecryptfs is mounted.
cat << EOF > .profile
/usr/bin/ecryptfs-mount-private
cd
source ~/.bashrc
EOF
chmod 400 .profile

echo "Secure the real /home/$USER back"
chmod 500 .
echo "Reboot and try to ssh with public key authentication without logging in first via X/tty"
