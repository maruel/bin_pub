# Copyright 2025 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Defined in Dockerfile.base
FROM mydevenv.base

ARG ENV_FILE

# Settings from the script. We'll want to eventually just use whatever is the current latest.
ENV GO_VERSION=1.24.4
ENV NVM_VERSION=0.40.3

# Copy the file setting environment variables.
COPY ${ENV_FILE:+$ENV_FILE} ${ENV_FILE:+/home/user/.env}

# Copy the aliases
COPY bash_aliases /home/user/.bash_aliases

# Install latest Neovim (as root)
RUN ARCH=$(uname -m | sed s/aarch64/arm64/) && \
    curl -sSL -o- https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz | tar xz -C /opt --strip-component=1 && \
    ln -s /opt/bin/nvim /usr/local/bin/nvim && \
    ln -s /opt/bin/nvim /usr/local/bin/vim && \
    ln -s /opt/bin/nvim /usr/local/bin/vi

# Install Go (as root)
RUN ARCH=$(uname -m | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
    curl -sSL -o- https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz | tar -C /usr/local -xzf - && \
    echo PATH="/usr/local/go/bin:\${HOME}/go/bin:\${PATH}" >> /etc/profile.d/mydevenv.sh
# Install Go packages (as user)
RUN su user -c '/usr/local/go/bin/go install golang.org/x/tools/cmd/goimports@latest && \
	/usr/local/go/bin/go install golang.org/x/tools/gopls@latest && \
	/usr/local/go/bin/go clean -cache -testcache -modcache'

# Install nvm, node.js, npm, Claude Code and Gemini CLI (as user)
RUN su user -c 'curl -sSL -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash && \
    . ~/.nvm/nvm.sh && \
    nvm install --no-progress node && \
    npm install -g @anthropic-ai/claude-code @google/gemini-cli @openai/codex @qwen-code/qwen-code@latest \
	'
	
# https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/configuration.md'
COPY etc/gemini-cli/settings.json /etc/gemini-cli/settings.json

# Start SSH server
CMD ["/root/start.sh"]
