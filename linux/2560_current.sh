#!/bin/sh
# Copyright 2022 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Don't forget to enable "Utiliser la barre de titre" in Chrome
# https://linux.die.net/man/1/wmctrl

set -eu

NAME="$(xdotool getwindowfocus getwindowname)"
wmctrl -r "$NAME" -b remove,maximized_vert,maximized_horz,fullscreen
wmctrl -r "$NAME" -e 0,-1,-1,2560,1440
