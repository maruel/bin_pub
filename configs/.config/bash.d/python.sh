# Copyright 2024 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Source: https://github.com/maruel/bin_pub

# pip install virtualenvwrapper
# https://virtualenvwrapper.readthedocs.io/
if [ -f $HOME/.local/bin/virtualenvwrapper.sh ]; then
  export WORKON_HOME=$HOME/.cache/virtualenvwrapper
  source $HOME/.local/bin/virtualenvwrapper.sh
  # Usage:
  #   mkvirtualenv <name>
# Fix eventually.
#elif [ -f $HOME/bin/homebrew/bin/virtualenvwrapper.sh ]; then
#  export WORKON_HOME=$HOME/.cache/virtualenvwrapper
#  export VIRTUALENVWRAPPER_PYTHON=$HOME/bin/homebrew/bin/python3
#  export VIRTUALENVWRAPPER_VIRTUALENV=$HOME/bin/homebrew/bin/virtualenv
#  source $HOME/bin/homebrew/bin/virtualenvwrapper.sh
#  # Usage:
#  #   mkvirtualenv <name>
fi
