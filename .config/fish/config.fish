# ==============================================================================
# FISH CONFIGURATION
# ==============================================================================
# env vars  → conf.d/env.fish
# aliases   → conf.d/aliases.fish
# tools     → conf.d/tools.fish

# ------------------------------------------------------------------------------
# INTERACTIVE SESSION
# ------------------------------------------------------------------------------
if status is-interactive
    if type -q fzf;      fzf --fish | source; end
    if type -q zoxide;   zoxide init fish | source; end
    if type -q mise;     mise activate fish | source; end
    if type -q direnv;   direnv hook fish | source; end
    if type -q atuin;    atuin init fish --disable-up-arrow | source; end
    if type -q starship; starship init fish | source; end
end
