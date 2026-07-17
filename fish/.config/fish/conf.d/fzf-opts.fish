# fzf.fish plugin configuration (conf.d files are auto-sourced)
# Plugin: https://github.com/PatrickF1/fzf.fish (installed via Fisher, see fish_plugins)

# Consistent look and size for every fzf surface; ctrl-/ toggles the preview pane.
# Inside tmux everything opens as a centered 85%x70% popup; outside tmux --tmux is
# ignored and the inline --height applies.
set -gx FZF_DEFAULT_OPTS "--height=70% --min-height=15 --tmux center,85%,70% --layout=reverse --border --info=inline --bind=ctrl-/:toggle-preview"

# Search Directory (ctrl-alt-f): fd options appended when listing candidates
set -g fzf_fd_opts --hidden --follow --exclude .git

# Preview commands for Search Directory / Search Git Status (path is appended automatically)
set -g fzf_preview_file_cmd bat -n --color=always --line-range :300
set -g fzf_preview_dir_cmd eza --tree --level=2 --color=always

# Search History (popup size comes from FZF_DEFAULT_OPTS): ctrl-y copies the
# selected command (strips the "MM-DD HH:MM:SS │ " prefix fzf.fish adds to each
# entry) to the clipboard
set -g fzf_history_opts --bind "ctrl-y:execute-silent(string replace --regex '^.*? │ ' '' -- {} | pbcopy)+abort"
