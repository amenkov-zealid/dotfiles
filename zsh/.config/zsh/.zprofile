# ------------------------------------------------------------------------------
# SHELL
# ------------------------------------------------------------------------------
# export SHELL="/bin/zsh"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export HOMEBREW_NO_AUTO_UPDATE=1
export PIPENV_VENV_IN_PROJECT=1

# ------------------------------------------------------------------------------
# PATH
# ------------------------------------------------------------------------------
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

# openjdk must come before Homebrew bin
export PATH="/opt/homebrew/opt/openjdk/bin:$HOME/bin:$HOME/.local/bin:$PATH"

# ------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# ------------------------------------------------------------------------------
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR="env NVIM_APPNAME=nvim-lite nvim"
export VISUAL="$EDITOR"
# export EDITOR_NO_WAIT="zed"
export LESS="-R --mouse --wheel-lines=3 -F -X -i"
export CLAUDE_CODE_NO_FLICKER=1

export HOMEBREW_CASK_OPTS="--appdir=~/Applications/"
export XDG_CONFIG_HOME="$HOME/.config"

export K9S_CONFIG_DIR="$HOME/.config/k9s"

export JIRA_URL=https://zealid.atlassian.net/
export AWS_PROFILE="eks-dev"
export AWS_CLUSTER_NAME="dev1-eks-cluster"
export KUBECONFIG="$HOME/.kube/config"

export OPENAI_API_KEY="$(security find-generic-password -s openai-api-key -w 2>/dev/null)"
