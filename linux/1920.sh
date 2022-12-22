#!/bin/sh
# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Don't forget to enable "Utiliser la barre de titre"

set -eu

NAME='Nouvel onglet - Google Chrome'
wmctrl -r "$NAME" -b remove,maximized_vert,maximized_horz,fullscreen
wmctrl -r "$NAME" -e 0,-1,-1,1920,1080

NAME='~'
wmctrl -r "$NAME" -b remove,maximized_vert,maximized_horz,fullscreen
wmctrl -r "$NAME" -e 0,-1,-1,1920,1080

