# Copyright 2024 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Source: https://github.com/maruel/bin_pub

export PYTHONDONTWRITEBYTECODE=x

# pip install virtualenvwrapper
# https://virtualenvwrapper.readthedocs.io/
if [ -f $HOME/.local/bin/virtualenvwrapper.sh ]; then
  source $HOME/.local/bin/virtualenvwrapper.sh
  export WORKON_HOME=$HOME/.cache/virtualenvwrapper
  # Usage:
  #   mkvirtualenv <name>
fi
