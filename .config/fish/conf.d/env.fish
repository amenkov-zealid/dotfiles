# ------------------------------------------------------------------------------
# SHELL
# ------------------------------------------------------------------------------
# set -gx SHELL "fish"
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx HOMEBREW_NO_AUTO_UPDATE 1

# ------------------------------------------------------------------------------
# PATH
# ------------------------------------------------------------------------------
# fish_add_path /opt/homebrew/bin
# fish_add_path /opt/homebrew/opt/openjdk/bin
# fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin

# ------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# ------------------------------------------------------------------------------
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR "zed --wait"
set -gx EDITOR_NO_WAIT "zed"
set -gx VISUAL "zed --wait"
set -gx PAGER "bat --paging=always"
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

set -gx HOMEBREW_CASK_OPTS "--appdir=~/Applications/"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx K9S_CONFIG_DIR "$HOME/.config/k9s"

set -gx JIRA_URL "https://zealid.atlassian.net/"
set -gx AWS_PROFILE "eks-dev"
set -gx AWS_CLUSTER_NAME "dev1-eks-cluster"
set -gx KUBECONFIG "$HOME/.kube/config"

# Disable fish greeting
# set -U fish_greeting

# Load secrets
# macOS: load from Keychain
set -gx OPENAI_API_KEY (security find-generic-password -s openai-api-key -w 2>/dev/null)
# SSH terminal color (pink background for remote sessions)
if set -q SSH_CONNECTION
    printf "\033]11;#FF00FF\007"
end
