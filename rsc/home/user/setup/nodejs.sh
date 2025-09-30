#!/bin/bash
# Install nvm, node.js, npm, typescript, eslint (as user)

set -eu
cd $HOME

if ! which nvm &> /dev/null; then
	# TODO: Update from time to time.
	curl -sSL -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
	. ~/.nvm/nvm.sh
fi

if ! which node &> /dev/null; then
	nvm install --no-progress node
fi

npm install -g eslint typescript typescript-eslint
