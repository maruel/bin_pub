#!/bin/sh
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -eu

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
rm get-pip.py
