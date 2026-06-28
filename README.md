# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## New Machine Setup

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Clone this repo

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 3. Install core tools

```bash
brew install stow mise fish neovim tmux git zsh
```

Install optional tools used in these configs:

```bash
brew install atuin starship zoxide fzf bat ripgrep fd delta tpm ghostty kitty zed
```

### 4. Install mise and set up global tool versions

```bash
# mise is installed via brew above; apply the global config
stow mise

# Install the tool versions defined in mise/config.toml (python, uv)
mise install
```

### 5. Stow packages

From `~/dotfiles`, symlink all packages into `$HOME`:

```bash
stow zsh git nvim tmux ghostty fish zed starship mise atuin claude kitty
```

Or apply everything at once:

```bash
stow */
```

> **Note:** If any target file already exists (e.g. `~/.gitconfig`), stow will error. Back up or remove the conflicting file first, then re-run stow.

### 6. Set zsh as your shell (if not already)

```bash
chsh -s /bin/zsh
```

Restart your terminal. Zsh will load from `~/.config/zsh/.zshrc` via `ZDOTDIR` set in `~/.zshenv`.

### 7. Install zsh plugins

Plugins are managed by [znap](https://github.com/marlonrichert/zsh-snap). On first launch, znap will auto-install itself and the plugins declared in `.zshrc`.

### 8. Install Neovim plugins

Open Neovim — [lazy.nvim](https://github.com/folke/lazy.nvim) will bootstrap itself and install all plugins automatically.

```bash
nvim
```

### 9. Install tmux plugins

Start tmux, then press `C-s I` (prefix + I) to install plugins via [TPM](https://github.com/tmux-plugins/tpm).

TPM is expected at `/opt/homebrew/opt/tpm/share/tpm/tpm` (installed via `brew install tpm`).

### 10. Set up fish shell (optional)

If you prefer fish as your interactive shell:

```bash
chsh -s $(which fish)
```

Fish plugins live in `fish/conf.d/` and are auto-sourced on shell start.

---

## Package Overview

| Package | What it configures |
|---------|-------------------|
| `zsh` | Zsh shell, znap, fzf-tab, zoxide, starship |
| `fish` | Fish shell, env vars, plugins |
| `nvim` | Neovim (LazyVim) |
| `tmux` | tmux with Nord theme and TPM plugins |
| `git` | Git with delta pager, rerere, aliases |
| `ghostty` | Ghostty terminal |
| `kitty` | Kitty terminal |
| `zed` | Zed editor |
| `starship` | Starship prompt |
| `mise` | Global tool versions (python, uv) |
| `atuin` | Shell history sync |
| `claude` | Claude Code settings |
