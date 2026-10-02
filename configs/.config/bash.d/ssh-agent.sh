# Select the desktop SSH agent when no valid inherited agent is available.
# Source: https://github.com/maruel/bin_pub

if [[ -z ${SSH_AUTH_SOCK:-} || ! -S $SSH_AUTH_SOCK ]]; then
  if [[ ${UNAME:-} == Darwin ]]; then
    POSSIBLE_SOCKETS=(/private/tmp/com.apple.launchd.*/Listeners)
    if [[ ${#POSSIBLE_SOCKETS[@]} -gt 1 ]]; then
      echo "Found multiple possible ssh-agent sockets; you should probably investigate this." >&2
    fi
    for POSSIBLE_SOCKET in "${POSSIBLE_SOCKETS[@]}"; do
      if [[ -S $POSSIBLE_SOCKET ]]; then
        export SSH_AUTH_SOCK="$POSSIBLE_SOCKET"
        break
      fi
    done
    unset POSSIBLE_SOCKET POSSIBLE_SOCKETS
  elif [[ ${UNAME:-} == Linux ]]; then
    desktop_agent_socket="${XDG_RUNTIME_DIR:-/run/user/$UID}/keyring/ssh"
    if [[ -S $desktop_agent_socket ]]; then
      export SSH_AUTH_SOCK="$desktop_agent_socket"
      unset SSH_AGENT_PID
    else
      unset SSH_AUTH_SOCK SSH_AGENT_PID
    fi
    unset desktop_agent_socket
  fi
fi
