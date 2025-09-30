# Source: https://github.com/maruel/bin_pub

alias gemini="\$(which gemini) --yolo"
alias qwen="\$(which qwen) --yolo"
alias codex="\$(which codex) --dangerously-bypass-approvals-and-sandbox"

if [ -f $HOME/.env ]; then
    set -a
    source $HOME/.env
    set +a
fi

