#!/bin/bash
# Copyright 2024 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Understand linux boot duration.

set -eu

systemd-analyze plot > plot.svg
systemd-analyze blame
echo "Open plot.svg"
