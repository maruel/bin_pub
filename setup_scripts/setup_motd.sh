#!/bin/sh
# Copyright 2020 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Remove some of the junk printed on motd.
#
# Specific for Ubuntu.

set -eu

sudo chmod -x /etc/update-motd.d/00-header
sudo chmod -x /etc/update-motd.d/10-help-text
sudo chmod -x /etc/update-motd.d/50-motd-news
sudo chmod -x /etc/update-motd.d/91-release-upgrade
sudo chmod -x /etc/update-motd.d/95-hwe-eol

# Apologies for the swearing. This is an inside joke.
cat << 'EOF' | sudo tee /etc/update-motd.d/20-fuck-yeah
#!/bin/sh
# Created by github.com/maruel/bin_pub
echo "$(hostname) - fuck yeah!"
EOF
sudo chmod +x /etc/update-motd.d/20-fuck-yeah
