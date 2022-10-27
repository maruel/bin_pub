#!/bin/sh
# Copyright 2022 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

set -eu

# Revert with:
#   defaults delete com.apple.dock expose-animation-duration
#
# Query with:
#   defaults read com.apple.dock | less
#
# Other options:
#   defaults write com.apple.finder DisableAllAnimations -bool true
#   defaults write com.apple.dock springboard-show-duration -float .1
#   defaults write com.apple.dock springboard-hide-duration -float .1
#   defaults write com.apple.dock springboard-page-duration -float .1
#
# Enable Zoom:
#   - System Preferences > Accessibility > Zoom.
#     - Enable keyboard shortcut.
#   - System Preferences > Accessibility > Shortcuts.
#     - Disable them all beside Zoom.

defaults write com.apple.dock expose-animation-duration -float 0.1
