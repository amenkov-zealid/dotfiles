# ------------------------------------------------------------------------------
# ENVIRONMENT
# ------------------------------------------------------------------------------
export PAGER="bat --paging=always"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# ------------------------------------------------------------------------------
# HISTORY
# ------------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY

# ------------------------------------------------------------------------------
# INTERACTIVE BEHAVIOR
# ------------------------------------------------------------------------------
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Use the up and down keys to navigate the history
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

# Move to directories without cd
setopt autocd

# Initialize completion
autoload -U compinit; compinit

# ------------------------------------------------------------------------------
# ALIASES
# ------------------------------------------------------------------------------
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsa='ls -lah'

alias oc='opencode'
alias lzd='lazydocker'
alias vim='nvim'

# Git aliases
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcam='git commit -a -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git pull'
alias gp='git push'
alias gst='git status'

alias zshconfig='zed ~/.zshrc'
alias fishconfig='zed ~/.config/fish/config.fish'

# ------------------------------------------------------------------------------
# PLUGINS
# ------------------------------------------------------------------------------
if [[ -o zle && -t 0 && -t 1 ]] && command -v brew >/dev/null 2>&1; then
    brew_prefix="$(brew --prefix)"

    if [[ -r "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
        source "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    fi

    if [[ -r "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
        source "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    fi

    unset brew_prefix
fi

# ------------------------------------------------------------------------------
# TOOLS
# ------------------------------------------------------------------------------
if [[ -o zle && -t 0 && -t 1 ]] && command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

# if [[ -o zle && -t 0 && -t 1 ]] && command -v atuin >/dev/null 2>&1; then
#     eval "$(atuin init zsh --disable-up-arrow)"
# fi

if [[ -t 1 ]] && command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
