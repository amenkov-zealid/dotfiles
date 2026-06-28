# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Layout

This is a [GNU Stow](https://www.gnu.org/software/stow/) dotfiles repository. Each top-level directory is a **stow package** whose internal directory tree mirrors `$HOME`. For example:

```
zsh/.zshenv                       → ~/.zshenv
zsh/.config/zsh/.zshrc            → ~/.config/zsh/.zshrc
nvim/.config/nvim/lua/config/...  → ~/.config/nvim/lua/config/...
```

Packages: `atuin`, `claude`, `fish`, `ghostty`, `git`, `kitty`, `mise`, `nvim`, `starship`, `tmux`, `zed`, `zsh`

## Applying / Removing Configs

```bash
# Symlink a package into $HOME
stow <package>

# Remove symlinks for a package
stow -D <package>

# Re-apply (delete + relink)
stow -R <package>

# Dry-run to preview what would change
stow -n <package>

# Apply all packages at once
stow */
```

Always run stow from the repo root (`~/dotfiles`).

## Key Tool Configs

| Package | Config path | Purpose |
|---------|-------------|---------|
| `zsh` | `.zshenv`, `.config/zsh/.zshrc` | Shell; znap plugin manager, fzf-tab, zoxide, mise, direnv, starship |
| `nvim` | `.config/nvim/` | LazyVim + lazy.nvim; extras: python, fzf, claudecode |
| `tmux` | `.config/tmux/tmux.conf` | Prefix `C-s`; Nord theme; TPM plugins |
| `ghostty` | `.config/ghostty/config` | Terminal; theme loaded from `auto/theme.ghostty` |
| `git` | `.gitconfig`, `.config/git/` | delta pager, histogram diff, rerere, useful aliases |
| `mise` | `.config/mise/config.toml` | Global tool versions (python latest, uv latest) |
| `zed` | `.config/zed/settings.json` | Editor; JetBrains theme; SSH connections defined here |
| `claude` | `.claude/settings.json` | Claude Code settings; revdiff plugin enabled |

## Shell Environment Notes

- `$XDG_CONFIG_HOME` is set to `~/.config` (in `.zshenv` for zsh, `conf.d/env.fish` for fish)
- `$ZDOTDIR` is set to `~/.config/zsh` — zsh config lives there, not in `~`
- `$EDITOR` is `zed --wait`; `$PAGER` is `bat`
- Zsh plugins are managed by **znap** (at `~/.config/zsh/plugins/zsh-snap/`)
- Fish plugins live in `fish/conf.d/` (auto-sourced)

## Ghostty Theme System

`ghostty/config` includes `?auto/theme.ghostty` — a generated file (note the `?` prefix = optional include). Theme switching is automated and writes to `auto/theme.ghostty`. Edit `config` for persistent non-theme settings; edit `extra` for local overrides.

## tmux

- Prefix is `C-s` (not the default `C-b`)
- Reload config: `prefix + r`
- Plugins installed via TPM at `/opt/homebrew/opt/tpm/share/tpm/tpm`
- Install new plugins: `prefix + I`

## Neovim

Built on [LazyVim](https://lazyvim.org). Custom plugins go in `nvim/.config/nvim/lua/plugins/` (`.keep` file holds the dir). `lazyvim.json` tracks enabled LazyVim extras. `lazy-lock.json` pins plugin versions — commit it to keep the environment reproducible.
