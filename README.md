# Dotfiles

Minimal chezmoi-managed setup for daily development.

## Scope

- shell and terminal: fish, zsh, starship, tmux, ghostty
- editor: Zed
- git/dev tooling: git config, global gitignore, mise runtimes
- bootstrap scripts: Homebrew packages, runtimes, macOS defaults

## First-time setup

```bash
chezmoi init --apply <your-repo-url>
```

## Apply updates

```bash
chezmoi apply
```

## Manual steps

- set your git identity (kept out of `dot_gitconfig`):

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

- set fish as default shell if needed:

```bash
chsh -s "$(which fish)"
```
