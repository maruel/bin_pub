# Dockerfile based on mydevenv script
FROM debian:12.11

# Settings from the script
ENV GO_VERSION=1.24.4
ENV NVM_VERSION=0.40.3
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update -q && \
    apt-get install -q -y --no-install-recommends \
		build-essential \
		ca-certificates \
		curl \
		git \
		less \
		openssh-server \
		rsync \
		shared-mime-info && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure SSH
RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config.d/mydevenv.conf && \
    echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config.d/mydevenv.conf && \
    echo 'HostbasedAuthentication yes' >> /etc/ssh/sshd_config.d/mydevenv.conf && \
    echo 'TrustedUserCAKeys /etc/ssh/container_ca.pub' >> /etc/ssh/sshd_config.d/mydevenv.conf
RUN rm -f /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*_key.pub
COPY sketch/container_server_identity /etc/ssh/ssh_host_rsa_key
COPY sketch/container_server_identity.pub /etc/ssh/ssh_host_rsa_key.pub
COPY sketch/container_ca.pub /etc/ssh/
RUN echo 'Welcome to mydevenv!' > /etc/motd
COPY start.sh /root/start.sh

# Configure Bash (for everyone)
RUN curl -sSL -o /opt/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash && \
    echo 'export SHELL' >> /etc/profile.d/mydevenv.sh && \
    echo 'source /opt/git-completion.bash' >> /etc/profile.d/mydevenv.sh && \
    echo 'source /etc/bash_completion.d/git-prompt' >> /etc/profile.d/mydevenv.sh && \
    echo 'GIT_PS1_DESCRIBE_STYLE=tag' >> /etc/profile.d/mydevenv.sh && \
    echo 'GIT_PS1_SHOWCOLORHINTS=1' >> /etc/profile.d/mydevenv.sh && \
    echo 'GIT_PS1_SHOWDIRTYSTATE=1' >> /etc/profile.d/mydevenv.sh && \
    echo 'GIT_PS1_SHOWSTASHSTATE=1' >> /etc/profile.d/mydevenv.sh && \
    echo 'GIT_PS1_SHOWUNTRACKEDFILES=1' >> /etc/profile.d/mydevenv.sh && \
    echo 'GIT_PS1_SHOWUPSTREAM=auto' >> /etc/profile.d/mydevenv.sh && \
    echo 'function __my_ps1 {' >> /etc/profile.d/mydevenv.sh && \
    echo '  __git_ps1 \\' >> /etc/profile.d/mydevenv.sh && \
    echo '    "\\[\\e]0;\\W\\a\\]\\[\\e[0m\\]\\$(_V=\\$\\\?; if [ \\$_V != 0 ]; then echo -e -n \"\\\\[\\\\e[36m\\\\]$_V\\\\[\\\\e[0m\\\\]\" ; fi)" \\' >> /etc/profile.d/mydevenv.sh && \
    echo '    "\\[\\e[36m\\]\\w\\[\\e[0m\\]🐳 "' >> /etc/profile.d/mydevenv.sh && \
    echo '}' >> /etc/profile.d/mydevenv.sh && \
    echo 'PROMPT_COMMAND=__my_ps1' >> /etc/profile.d/mydevenv.sh && \
    echo 'export LS_OPTIONS="--color=auto"' >> /etc/profile.d/mydevenv.sh && \
    echo 'eval "$(dircolors)"' >> /etc/profile.d/mydevenv.sh && \
    echo "alias ls='ls \$LS_OPTIONS'" >> /etc/profile.d/mydevenv.sh && \
    echo "alias ll='ls \$LS_OPTIONS -la'" >> /etc/profile.d/mydevenv.sh

# Install Neovim (as root)
RUN ARCH=$(uname -m | sed s/aarch64/arm64/) && \
    curl -sSL -o- https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz | tar xz -C /opt --strip-component=1 && \
    ln -s /opt/bin/nvim /usr/local/bin/nvim && \
    ln -s /opt/bin/nvim /usr/local/bin/vim && \
    ln -s /opt/bin/nvim /usr/local/bin/vi

# Install Go (as root)
RUN ARCH=$(uname -m | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
    curl -sSL -o- https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz | tar -C /usr/local -xzf - && \
    echo PATH="/usr/local/go/bin:\${HOME}/go/bin:\${PATH}" >> /etc/profile.d/mydevenv.sh

# Create user "user"
RUN adduser --disabled-password user
#RUN useradd -ms /bin/bash user && mkdir -p /app && chown user:user /app
RUN su user -c "mkdir -p /home/user/.ssh /home/user/.config/git"
COPY sketch/container_user_identity.pub /home/user/.ssh/authorized_keys
COPY config/git/config /home/user/.config/git/config
COPY config/git/ignore /home/user/.config/git/ignore
RUN echo "cd /app" >> /etc/profile.d/mydevenv.sh
RUN chown -R user:user /home/user/.ssh /home/user/.config
RUN chmod 0700 /home/user/.ssh
RUN chmod 0400 /home/user/.ssh/authorized_keys

# Install Node.js and npm packages (as user)
RUN su user -c 'curl -sSL -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash && \
    . ~/.nvm/nvm.sh && \
    nvm install --no-progress node && \
	npm install -g @google/gemini-cli @anthropic-ai/claude-code && \
	echo "alias gemini=\"\\\\$(which gemini) --yolo\"" >> /home/user/.bashrc'

# Install Go packages (as user)
RUN su user -c '/usr/local/go/bin/go install golang.org/x/tools/cmd/goimports@latest && \
	/usr/local/go/bin/go install golang.org/x/tools/gopls@latest && \
	/usr/local/go/bin/go clean -cache -testcache -modcache'

# Create app directory (as user)
RUN mkdir /app
RUN chown user:user /app
RUN su user -c "git init /app"

# Start SSH server
CMD ["/root/start.sh"]
