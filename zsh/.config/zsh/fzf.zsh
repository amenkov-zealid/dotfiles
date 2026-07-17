# ------------------------------------------------------------------------------
# fzf configuration (sourced from .zshrc after fzf-tab loads)
# ------------------------------------------------------------------------------

# Consistent look and size for every fzf surface; ctrl-/ toggles the preview pane.
# Inside tmux everything opens as a centered 85%x70% popup; outside tmux --tmux is
# ignored and the inline --height applies.
export FZF_DEFAULT_OPTS="--height=70% --min-height=15 --tmux center,85%,70% --layout=reverse --border --info=inline --bind=ctrl-/:toggle-preview"

# fd-powered sources: respects .gitignore, includes hidden files, skips .git
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"

# Widget previews (popup size comes from FZF_DEFAULT_OPTS)
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :300 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"
# ctrl-y copies the selected history entry to the clipboard
export FZF_CTRL_R_OPTS="--preview 'echo {2..}' --preview-window down:3:wrap --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"

# --- fzf-tab ------------------------------------------------------------------
# Inherit FZF_DEFAULT_OPTS above (see Aloxaf/fzf-tab#455 if flags misbehave)
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept
zstyle ':fzf-tab:*' switch-group ',' '.'   # cycle groups with , / .
# Popup comes from --tmux in FZF_DEFAULT_OPTS (inherited above), same as every
# other fzf surface. If it ever misbehaves, revert to:
#   zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
#   zstyle ':fzf-tab:*' popup-min-size 100 20
# Preview directory contents when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# Preview file/branch context for git
zstyle ':fzf-tab:complete:git-(add|diff|restore|checkout):*' fzf-preview \
  'git diff --color=always -- $word 2>/dev/null | head -200'
