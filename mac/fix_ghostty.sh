#!/bin/bash
# Copyright 2025 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -eu

if [[ $# -ne 1 ]]; then
  echo "Error: Pass the remote server to copy the ghostty terminal info to." >&2
  echo "Usage: $0 <argument>" >&2
  exit 1
fi

infocmp -x ghostty | ssh $1 -- tic -x -
