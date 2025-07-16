# Copyright 2025 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

# Defined in Dockerfile.base
FROM mydevenv.base

# Settings from the script. We'll want to eventually just use whatever is the current latest.
ENV GO_VERSION=1.24.4
ENV NVM_VERSION=0.40.3

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
	npm install -g @google/gemini-cli @anthropic-ai/claude-code && \
	echo "alias gemini=\"\\\\$(which gemini) --yolo\"" >> /home/user/.bashrc'

# Start SSH server
CMD ["/root/start.sh"]
