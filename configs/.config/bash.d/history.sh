# Copyright 2026 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Source: https://stackoverflow.com/questions/1030182
if [[ $- == *i* ]]; then
		# Default up and down arrow to history search.
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
fi
