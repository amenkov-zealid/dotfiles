# ------------------------------------------------------------------------------
# ENVIRONMENT
# ------------------------------------------------------------------------------
export PAGER="less"
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

# Use the up and down keys to navigate the history (prefix search, cursor at end of line)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "\e[A" up-line-or-beginning-search
bindkey "\e[B" down-line-or-beginning-search

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
# zstyle ':completion:*' matcher-list '' \
#   'm:{a-zA-Z}={A-Za-z}' \
#   'r:|[._-]=* r:|=*' \
#   'l:|=* r:|=*'

# --- fzf-tab recommended defaults -------------------------------------------
# (fzf-tab zstyles themselves live in fzf.zsh, sourced in the plugins section)
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# ----------------------------------------------------------------------------

# zstyle ':completion:*' verbose yes

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
alias v='nvim'
alias ta='tmux attach'
alias tls='tmux ls'

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

# Fuzzy-open a file from ~/.config: `conf` or `conf <query>`
conf() {
  local file
  file=$(fd --type f --hidden --follow \
      --exclude .git --exclude plugins --exclude node_modules --exclude kitty-themes \
      . ~/.config |
    fzf --query="$*") || return
  ${=EDITOR:-nvim} "$file"
}

# Fuzzy-switch between git worktrees for the current repo: `wt`
wt() {
  local dir
  dir=$(git worktree list --porcelain | awk '
    /^worktree /{p=$2}
    /^branch /{b=$2; sub("refs/heads/","",b); print p"\t"b; next}
    /^detached/{print p"\t(detached)"}
  ' | fzf --delimiter='\t' --with-nth=2 \
      --preview 'git -C {1} log --oneline --color=always -n 20' \
      --preview-window down:60% | cut -f1) || return
  [[ -n "$dir" ]] && cd "$dir"
}

# Create (or resume) a worktree for <branch>, init submodules, and cd into it
wta() {
  if [[ -z "$1" ]]; then
    echo "usage: wta <branch>"
    return 1
  fi
  local dir
  dir=$(mise run wt-add "$1") || return 1
  cd "$dir"
}

# Fuzzy-remove a worktree (never lists the main checkout)
wtrm() {
  local sel dir branch
  sel=$(git worktree list --porcelain | awk '
    /^worktree /{p=$2}
    /^branch /{b=$2; sub("refs/heads/","",b); print p"\t"b; next}
    /^detached/{print p"\t(detached)"}
  ' | rg '/worktrees/' | fzf --delimiter='\t' --with-nth=2) || return
  [[ -z "$sel" ]] && return
  dir=$(cut -f1 <<< "$sel")
  branch=$(cut -f2 <<< "$sel")
  mise run wt-rm "$branch"
}

# agterm helpers: `ags <branch>` (worktree + agterm session running claude)
source "${ZDOTDIR}/agterm.zsh"

# ------------------------------------------------------------------------------
# PLUGINS (znap)
# ------------------------------------------------------------------------------
# Bootstrap znap (https://github.com/marlonrichert/zsh-snap)
ZNAP_DIR="${ZDOTDIR}/plugins/zsh-snap"
[[ -f "$ZNAP_DIR/znap.zsh" ]] ||
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$ZNAP_DIR"
source "$ZNAP_DIR/znap.zsh"

# fzf-tab: replaces the completion menu with a fuzzy fzf popup.
# Must load after compinit, before autosuggestions / syntax-highlighting.
znap source Aloxaf/fzf-tab

# fzf env vars + fzf-tab behavior
source "${ZDOTDIR}/fzf.zsh"

# fzf-git.sh: Ctrl-G Ctrl-{B,F,H,T,S,R,...} fuzzy pickers for branches,
# changed files, hashes, tags, stashes, remotes
znap source junegunn/fzf-git.sh

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

# agterm agent-status integration
[[ -f "$HOME/.config/agterm/agent-status/shell/integration.sh" ]] &&
  source "$HOME/.config/agterm/agent-status/shell/integration.sh"
