#!/bin/bash
# Install nvm, node.js, npm, Claude Code and Gemini CLI (as user)
set -eu

if ! which nvm &> /dev/null; then
	# TODO: Update from time to time.
	curl -sSL -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
	. ~/.nvm/nvm.sh
fi

if ! which node &> /dev/null; then
	nvm install --no-progress node
fi

# Install or update packages
npm install -g @anthropic-ai/claude-code @google/gemini-cli @openai/codex @qwen-code/qwen-code@latest vscode-langservers-extracted eslint
