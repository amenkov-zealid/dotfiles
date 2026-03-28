# tools.fish — sourced for all sessions (interactive + scripts)
# Tool init hooks that need prompts/completions go in config.fish under is-interactive

# Homebrew environment (sets HOMEBREW_PREFIX etc.)
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end
