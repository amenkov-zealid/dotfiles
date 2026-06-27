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
autoload -Uz compinit
# Only do the full security check once a day; otherwise load cached dump.
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
  compinit -d "${ZDOTDIR}/.zcompdump"
else
  compinit -C -d "${ZDOTDIR}/.zcompdump"
fi

# ------------------------------------------------------------------------------
# COMPLETION STYLING
# ------------------------------------------------------------------------------
# Case-insensitive, partial-word, and hyphen/underscore-insensitive matching
zstyle ':completion:*' matcher-list '' \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# Colorize matches using LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Group results under labeled headers + descriptions
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' verbose yes

# Completion cache (dir already exists)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${ZDOTDIR}/.zcompcache"

# Complete . and .. ; nicer process completion for kill
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

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
# PLUGINS (znap)
# ------------------------------------------------------------------------------
# Bootstrap znap (https://github.com/marlonrichert/zsh-snap)
source ~/.config/zsh/plugins/zsh-snap/znap.zsh

# fzf-tab: replaces the completion menu with a fuzzy fzf popup.
# Must load after compinit, before autosuggestions / syntax-highlighting.
znap source Aloxaf/fzf-tab

# fzf-tab behavior
zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border
zstyle ':fzf-tab:*' switch-group ',' '.'   # cycle groups with , / .
# Preview directory contents when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath 2>/dev/null'
# Preview file/branch context for git
zstyle ':fzf-tab:complete:git-(add|diff|restore|checkout):*' fzf-preview \
  'git diff --color=always -- $word 2>/dev/null | head -200'

# Smarter autosuggestions: also draw from completion, accept one word with Alt-Right.
# Ctrl-Right is reserved by the window manager, so Alt-Right is used instead.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^[[1;3C' forward-word

# autosuggestions first; fast-syntax-highlighting must be sourced last
znap source zsh-users/zsh-autosuggestions
znap source zdharma-continuum/fast-syntax-highlighting

# ------------------------------------------------------------------------------
# TOOLS (cached via `znap eval`)
# ------------------------------------------------------------------------------
[[ -o zle && -t 0 && -t 1 ]] && command -v fzf >/dev/null && znap eval fzf 'fzf --zsh'

command -v zoxide >/dev/null && znap eval zoxide 'zoxide init zsh'
command -v mise   >/dev/null && znap eval mise   'mise activate zsh'
command -v direnv >/dev/null && znap eval direnv 'direnv hook zsh'

# if [[ -o zle && -t 0 && -t 1 ]] && command -v atuin >/dev/null 2>&1; then
#     eval "$(atuin init zsh --disable-up-arrow)"
# fi

[[ -t 1 ]] && command -v starship >/dev/null && znap eval starship 'starship init zsh'
