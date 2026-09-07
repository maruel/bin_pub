#!/usr/bin/env bash
# Copyright 2026 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -euo pipefail
cd "$(dirname $0)"
cd ..

NVM_DIR="${NVM_DIR:-$HOME/.local/share/nvm}"

# Detect target shell profile
if [ -n "${ZSH_VERSION:-}" ] || [ -n "${ZDOTDIR:-}" ] || [ "$SHELL" = "*/zsh" ]; then
  PROFILE_FILE="$HOME/.zshrc"
else
  PROFILE_FILE="$HOME/.bashrc"
fi

# 2. Clone repository if not already present
if [ ! -d "$NVM_DIR/.git" ]; then
  echo "==> Cloning nvm repository..."
  git clone https://github.com/nvm-sh/nvm "$NVM_DIR"
else
  echo "==> Existing git repository found in $NVM_DIR. Fetching tags..."
  git -C "$NVM_DIR" fetch --tags origin
fi

# 3. Resolve and checkout the latest stable tag
cd "$NVM_DIR"
LATEST_TAG=$(git describe --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
echo "==> Checking out latest release: $LATEST_TAG"
git checkout --quiet "$LATEST_TAG"

# 4. Idempotently append shell loader snippet to profile
# Represent $NVM_DIR using $HOME if it lives under the home directory
NVM_DIR_EXPORT="${NVM_DIR/#$HOME/\$HOME}"

SNIPPET=$(cat << EOF
export NVM_DIR="$NVM_DIR_EXPORT"
[ -s "\$NVM_DIR/nvm.sh" ] && \\. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \\. "\$NVM_DIR/bash_completion"
EOF
)

if ! grep -q 'NVM_DIR/nvm.sh' "$PROFILE_FILE" 2>/dev/null; then
  echo "==> Adding nvm loader snippet to $PROFILE_FILE"
  printf "\n# NVM configuration\n%s\n" "$SNIPPET" >> "$PROFILE_FILE"
else
  echo "==> Loader snippet already present in $PROFILE_FILE. Skipping append."
fi

# 5. Activate in the current subshell to verify
# shellcheck disable=SC1090
\. "$NVM_DIR/nvm.sh"

echo "==> Installation complete! Verified nvm version: $(nvm --version)"
echo "==> Run 'source $PROFILE_FILE' or restart your terminal to begin using nvm."
