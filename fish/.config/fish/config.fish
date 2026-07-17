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
    # Bootstrap Fisher (https://github.com/jorgebucaran/fisher) and install everything
    # declared in fish_plugins. Only runs once per machine, mirrors znap's self-bootstrap.
    if not functions -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        fisher install jorgebucaran/fisher
        fisher update
    end

    if type -q zoxide;   zoxide init fish | source; end
    if type -q mise;     mise activate fish | source; end
    # if type -q direnv;   direnv hook fish | source; end
    # if type -q atuin;    atuin init fish --disable-up-arrow | source; end
    if type -q starship; starship init fish | source; end
end
