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
nvm install 24
nvm alias default 24

curl --fail --show-error --location https://get.pnpm.io/install.sh | \
  ENV=/dev/null SHELL=/bin/bash sh -
