# Copyright 2024 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Source: https://github.com/maruel/bin_pub

# ssh-agent
if [ -z "${SSH_AUTH_SOCK+xxx}" ]; then
  # If not inherited from the environment.
  if [ -S "${XDG_RUNTIME_DIR+xxx}/ssh-agent.socket" ]; then
    # Automatically leverage systemd based ssh-agent in
    # https://github.com/maruel/bin_pub/blob/main/configs/.config/systemd/user/ssh-agent.service.
    # Enable with:
    #   systemctl --user enable ssh-agent
    #   systemctl --user start ssh-agent
    export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
  elif [ "$UNAME" = "Darwin" ]; then
    # macOS
    POSSIBLE_SOCKETS=(/private/tmp/com.apple.launchd.*/Listeners)
    if [[ ${#POSSIBLE_SOCKETS[@]} -gt 1 ]]; then
      echo "Found multiple possible ssh-agent sockets; you should probably investigate this." >&2
    fi
    for POSSIBLE_SOCKET in "${POSSIBLE_SOCKETS[@]}"; do
      if [[ -e "$POSSIBLE_SOCKET" ]]; then
        export SSH_AUTH_SOCK="$POSSIBLE_SOCKET"
        break
      fi
    done
  elif which keychain &> /dev/null; then
    # sudo apt-get install keychain
    # This call costs one second.
    keychain --quiet -Q --inherit any identity
    [[ -f $HOME/.keychain/$HOSTNAME-sh ]] && source $HOME/.keychain/$HOSTNAME-sh
    [[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ]] && source $HOME/.keychain/$HOSTNAME-sh-gpg
  fi
fi
