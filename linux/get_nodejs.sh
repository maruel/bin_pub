#!/usr/bin/env bash
# Copyright 2025 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -euo pipefail

: "${NVM_DIR:?NVM_DIR must be set before running this script}"
: "${PNPM_HOME:?PNPM_HOME must be set before running this script}"

if [[ ! -d "$NVM_DIR/.git" ]]; then
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
else
  git -C "$NVM_DIR" fetch --force --tags origin
fi

latest_tag="$(git -C "$NVM_DIR" tag --list 'v[0-9]*' --sort=-version:refname | sed -n '1p')"
if [[ -z "$latest_tag" ]]; then
  printf 'nvm repository at %s has no release tags.\n' "$NVM_DIR" >&2
  exit 1
fi
git -C "$NVM_DIR" checkout --detach "$latest_tag"

# shellcheck disable=SC1091
. "$NVM_DIR/nvm.sh"
nvm install 26
nvm alias default 26

work_dir="$(mktemp -d)"
readonly work_dir
trap 'rm -rf -- "$work_dir"' EXIT

curl --fail --show-error --location https://get.pnpm.io/install.sh \
  --output "$work_dir/install.sh"
# Shell configuration is managed by configs/.config/bash.d/10_path.sh.
# Confine upstream setup's startup-file edits to the temporary directory.
HOME="$work_dir" ENV="$work_dir/.bashrc" PNPM_HOME="$PNPM_HOME" \
  SHELL=/bin/bash sh "$work_dir/install.sh"
