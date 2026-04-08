#!/bin/bash
# Copyright 2026 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -euo pipefail

# --- Configuration ---
ALT_NAME="tailscale-alt"
PLIST_LABEL="com.maruel.tailscale-alt"
PLIST_PATH="/Library/LaunchDaemons/${PLIST_LABEL}.plist"
SOCKET="/var/run/${ALT_NAME}.sock"

BREW_PREFIX=$(brew --prefix)
STATE_DIR="${BREW_PREFIX}/var/${ALT_NAME}"
TAILSCALED="${BREW_PREFIX}/bin/tailscaled"
TAILSCALE="${BREW_PREFIX}/bin/tailscale"

is_running() {
    pgrep -f "socket=$SOCKET" > /dev/null 2>&1
}

case "${1:-}" in
    install)
        echo "Installing secondary Tailscale as a system daemon..."
        if is_running; then
            echo "Stopping existing process..."
            sudo pkill -f "socket=$SOCKET" || true
        fi
        sudo mkdir -p "$STATE_DIR"
        cat <<EOF | sudo tee "$PLIST_PATH" > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$PLIST_LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>$TAILSCALED</string>
        <string>--tun=userspace-networking</string>
        <string>--socket=$SOCKET</string>
        <string>--statedir=$STATE_DIR</string>
        <string>--port=41642</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/tailscale-alt.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/tailscale-alt.log</string>
</dict>
</plist>
EOF

        sudo chown root:wheel "$PLIST_PATH"
        sudo chmod 644 "$PLIST_PATH"
        sudo launchctl load -w "$PLIST_PATH"
        echo "Successfully installed as $PLIST_LABEL."
        ;;

    uninstall)
        echo "Removing secondary Tailscale daemon..."
        if [ -f "$PLIST_PATH" ]; then
            sudo launchctl unload -w "$PLIST_PATH" || true
            sudo rm "$PLIST_PATH"
        fi
        if is_running; then
            sudo pkill -f "socket=$SOCKET" || true
        fi
        sudo rm -f "$SOCKET"
        echo "Uninstalled."
        ;;

    up)
        echo "Bringing up Tailscale with SSH enabled..."
        sudo "$TAILSCALE" --socket="$SOCKET" up --ssh "${@:2}"
        ;;

    start)
        if is_running; then
            echo "Already running."
            exit 0
        fi
        sudo mkdir -p "$STATE_DIR"
        echo "Starting (manual mode)..."
        sudo "$TAILSCALED" --tun=userspace-networking --socket="$SOCKET" --statedir="$STATE_DIR" --port=41642 > /tmp/tailscaled-alt.log 2>&1 &
        ;;

    stop)
        if [ -f "$PLIST_PATH" ]; then
            echo "Managed by launchd. Use '$0 uninstall' or 'launchctl unload'."
            exit 1
        fi
        sudo pkill -f "socket=$SOCKET" || true
        sudo rm -f "$SOCKET"
        echo "Stopped."
        ;;

    *)
        if [ -z "${1:-}" ]; then
            echo "Usage: $0 {install|uninstall|up|start|stop|status|serve|funnel|...}"
            exit 1
        fi
        if ! is_running; then
            echo "Error: Secondary tailscaled is not running."
            exit 1
        fi
        sudo "$TAILSCALE" --socket="$SOCKET" "$@"
        ;;
esac
