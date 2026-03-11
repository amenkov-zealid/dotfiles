# AGENTS.md

## Repository purpose

This repository is a **chezmoi-managed dotfiles setup** for macOS development environments.
It is not an application/library codebase; most files are shell configs, tool configs, and bootstrap scripts.

Primary scope from `README.md`:
- shell/terminal config: fish, zsh, starship, tmux, ghostty
- editor config: Zed
- git/dev tooling: git config, global gitignore, mise runtimes
- machine bootstrap scripts: Homebrew packages, runtimes, macOS defaults

## Top-level structure

Observed key paths:
- `README.md` — usage and setup notes
- `Brewfile` — Homebrew formulae/casks to install
- `run_once_before_install-packages.sh` — installs Homebrew (if missing)
- `run_once_install-packages.sh` — runs `brew bundle` using this repo’s `Brewfile`
- `run_once_install-runtimes.sh` — runs `mise install` (if `mise` exists)
- `run_once_configure-macos.sh` — applies macOS `defaults` and restarts Finder/Dock
- `run_onchange_refresh-shell.sh` — refreshes fish PATH on config changes
- `dot_config/...` — managed config files (git, fish, mise, tmux, ghostty, zed, etc.)
- `dot_zshrc`, `dot_gitconfig` — chezmoi-style managed dotfiles
- `private_dot_ssh/config.tmpl` — template for SSH config

## Project type and implications

- **Type**: dotfiles/infrastructure config repo (chezmoi source state)
- **Languages/tools**: mostly shell scripts + config formats (TOML/INI-like/JSON/plaintext)
- There is no app build pipeline, runtime server, or unit test framework visible in the current tree.

## Essential commands (observed)

### Chezmoi workflow
- Initial apply:
  - `chezmoi init --apply <your-repo-url>`
- Apply updates after changes:
  - `chezmoi apply`

### Bootstrap commands used by scripts
- Install packages from Brewfile:
  - `brew bundle --file="$HOME/.local/share/chezmoi/Brewfile"`
- Install runtimes via mise (when installed):
  - `mise install`

### Script entry points
Run directly from repo root when validating behavior:
- `bash run_once_before_install-packages.sh`
- `bash run_once_install-packages.sh`
- `bash run_once_install-runtimes.sh`
- `bash run_once_configure-macos.sh`
- `bash run_onchange_refresh-shell.sh`

## Conventions and patterns observed

### Script style
Across all `run_*.sh` scripts reviewed:
- shebang: `#!/usr/bin/env bash`
- strict mode: `set -euo pipefail`
- guard external commands with `command -v ... >/dev/null 2>&1` when optional

Follow this style for new scripts/edits unless intentionally changing global conventions.

### Chezmoi naming pattern
- Files prefixed with `dot_` map to dotfiles in `$HOME` when applied
- `private_...` indicates secret/private template-managed files
- `run_once_*` and `run_onchange_*` follow chezmoi script naming semantics

Keep naming aligned with chezmoi conventions to preserve execution/apply behavior.

## Testing and validation approach for this repo

No formal automated test suite was found. Validation is operational:
- Syntax-check scripts before applying:
  - `bash -n <script>`
- Execute targeted script(s) locally to verify expected behavior
- Re-run `chezmoi apply` to confirm generated/applied state is clean

For config changes, validate using the corresponding tool when possible (e.g., launch fish/tmux/ghostty/zed and confirm no startup errors).

## Known operational gotchas

- `run_once_before_install-packages.sh` uses `curl` to install Homebrew from GitHub; this requires network access and appropriate permissions.
- `run_once_configure-macos.sh` is macOS-specific (`defaults`, `Finder`, `Dock`) and not portable to Linux.
- `run_onchange_refresh-shell.sh` assumes fish is installed for its path-refresh behavior.
- `README.md` explicitly leaves Git identity out of managed config; users must set `user.name` and `user.email` manually.

## Existing rule/instruction files

Searched for and did **not** find:
- `.cursor/rules/*.md`
- `.cursorrules`
- `.github/copilot-instructions.md`
- `claude.md`
- `agents.md`

No additional agent policy files are currently present beyond this `AGENTS.md`.

## Practical guidance for future agents

- Treat this as a **configuration repo**, not an app codebase.
- Prefer minimal, surgical edits that preserve existing tool behavior.
- When adding new managed files, follow chezmoi naming/templates so target paths resolve correctly on apply.
- Validate changed shell scripts with `bash -n` and, when safe, direct execution.
- If adding commands/documentation, only include tools that are already present or explicitly added in repo files (e.g., `Brewfile`, scripts, README).
