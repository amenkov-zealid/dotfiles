# ------------------------------------------------------------------------------
# fzf configuration (sourced from .zshrc after fzf-tab loads)
# ------------------------------------------------------------------------------

# Consistent look for every fzf surface; ctrl-/ toggles the preview pane
export FZF_DEFAULT_OPTS="--height=50% --layout=reverse --border --info=inline --bind=ctrl-/:toggle-preview"

# fd-powered sources: respects .gitignore, includes hidden files, skips .git
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"

# Widget previews (--tmux runs them in a tmux popup; ignored outside tmux)
export FZF_CTRL_T_OPTS="--tmux center,70% --preview 'bat -n --color=always --line-range :300 {}'"
export FZF_ALT_C_OPTS="--tmux center,70% --preview 'eza --tree --level=2 --color=always {}'"
# ctrl-y copies the selected history entry to the clipboard
export FZF_CTRL_R_OPTS="--tmux center,70% --preview 'echo {2..}' --preview-window down:3:wrap --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"

# --- fzf-tab ------------------------------------------------------------------
# Inherit FZF_DEFAULT_OPTS above (see Aloxaf/fzf-tab#455 if flags misbehave)
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept
zstyle ':fzf-tab:*' switch-group ',' '.'   # cycle groups with , / .
# Run in a tmux popup when inside tmux
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# Preview directory contents when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# Preview file/branch context for git
zstyle ':fzf-tab:complete:git-(add|diff|restore|checkout):*' fzf-preview \
  'git diff --color=always -- $word 2>/dev/null | head -200'
