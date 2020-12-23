#!/bin/bash
# Copyright 2020 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Enable unlocking the LVM LUKS based FDE via TPM2.
#
# LVM = Logical Volume Management
# FDE = Full Disk Encryption
# LUKS = Linux Unified Key Setup
# TPM2 = Trusted Platform Module v2
#
# http://manpages.ubuntu.com/manpages/focal/en/man1/clevis.1.html
# http://manpages.ubuntu.com/manpages/focal/man7/clevis-luks-unlockers.7.html
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/security_hardening/configuring-automated-unlocking-of-encrypted-volumes-using-policy-based-decryption_security-hardening
# https://kowalski7cc.xyz/blog/luks2-tpm2-clevis-fedora31

set -eu

sudo apt install clevis
sudo clevis luks bind -d /dev/nvme0n1p3 tpm2 '{"pcr_ids":"0,1,2,3,4,5,6,7"}'
sudo update-initramfs -u -k 'all'
