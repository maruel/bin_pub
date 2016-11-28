#!/bin/sh
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# This script was inspired by:
# https://github.com/mholt/caddy/blob/master/dist/init/linux-systemd
# with minor tweaks.

set -eu

URL='https://caddyserver.com/download/build?os=linux&arch=amd64&features=cors%2Cexpires%2Cfilemanager%2Cgit%2Chugo%2Cipfilter%2Cjwt%2Clocale%2Cmailout%2Cminify%2Cmultipass%2Cprometheus%2Cratelimit%2Crealip%2Csearch%2Cupload%2Ccloudflare%2Cgooglecloud'

if [ ! -d /etc/ssl/caddy ]; then
  echo "- Creating caddy directories"
  #sudo groupadd -g 33 www-data
  #sudo useradd \
  #  -g www-data --no-user-group --home-dir /var/www --no-create-home \
  #  --shell /usr/sbin/nologin --system --uid 33 www-data
  sudo mkdir -p /etc/caddy
  sudo chown -R root:www-data /etc/caddy
  sudo mkdir -p /etc/ssl/caddy
  sudo chown -R www-data:root /etc/ssl/caddy
  sudo chmod 0770 /etc/ssl/caddy
fi

echo "- Downloading caddy"
curl -o caddy.tar.gz "$URL"
sudo tar -C /usr/local/bin -xvf caddy.tar.gz caddy
rm caddy.tar.gz
echo "- Got:"
caddy -version

if [ ! -f /etc/systemd/system/caddy.service ]; then
  echo "- Installing caddy as systemd"
  sudo /bin/sh -c 'cat << '"'"'EOF'"'"' > /etc/systemd/system/caddy.service
# https://github.com/mholt/caddy/blob/master/dist/init/linux-systemd/caddy.service
# with minor tweaks.
[Unit]
Description=Caddy HTTP/2 web server
Documentation=https://caddyserver.com/docs
After=network-online.target
Wants=network-online.target systemd-networkd-wait-online.service

[Service]
Restart=on-failure

; User and group the process will run as.
User=www-data
Group=www-data

; Letsencrypt-issued certificates will be written to this directory.
Environment=CADDYPATH=/etc/ssl/caddy

; Always set "-root" to something safe in case it gets forgotten in the Caddyfile.
ExecStart=/usr/local/bin/caddy -log stdout -agree=true -conf=/etc/caddy/Caddyfile -root=/var/tmp
ExecReload=/bin/kill -USR1 $MAINPID

; Limit the number of file descriptors; see "man systemd.exec" for more limit settings.
LimitNOFILE=1048576
; Unmodified caddy is not expected to use more than that.
LimitNPROC=64

; Use private /tmp and /var/tmp, which are discarded after caddy stops.
PrivateTmp=true
; Use a minimal /dev
PrivateDevices=true
; Hide /home, /root, and /run/user. Nobody will steal your SSH-keys.
ProtectHome=true
; Make /usr, /boot, /etc and possibly some more folders read-only.
ProtectSystem=full
; … except /etc/ssl/caddy, because we want Letsencrypt-certificates there.
;   This merely retains r/w access rights, it does not add any new. Must still be writable on the host!
ReadWriteDirectories=/etc/ssl/caddy

; The following additional security directives only work with systemd v229 or later.
; They further retrict privileges that can be gained by caddy. Uncomment if you like.
; Note that you may have to add capabilities required by any plugins in use.
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true

[Install]
WantedBy=default.target
EOF'

  sudo systemctl daemon-reload
  sudo systemctl enable caddy.service
fi

echo "- (re)starting caddy"
sudo systemctl restart caddy.service
# sudo journalctl -f -u caddy.service
