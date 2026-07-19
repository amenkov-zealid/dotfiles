# agterm helpers (https://github.com/umputun/agterm)

# Create a worktree for <branch> under <repo>/.worktrees and open an agterm
# session there running claude: `ags <branch>`
ags() {
  if [[ -z "$1" ]]; then
    echo "usage: ags <branch>" >&2
    return 1
  fi
  if [[ "$AGTERM_ENABLED" != 1 ]] || ! command -v agtermctl >/dev/null; then
    echo "ags: requires agterm and agtermctl on PATH" >&2
    return 1
  fi
  local branch=$1 root repo wt
  # first worktree listed is always the main checkout, even when run from another worktree
  root=$(git worktree list --porcelain | head -1 | cut -d' ' -f2-) || return 1
  repo=${root:t}
  wt="$root/.worktrees/$branch"

  # keep .worktrees/ out of git status without touching the repo's .gitignore
  grep -qxF '.worktrees/' "$root/.git/info/exclude" 2>/dev/null ||
    echo '.worktrees/' >> "$root/.git/info/exclude"

  if [[ ! -d "$wt" ]]; then
    # existing local branch (or remote DWIM), else new branch off HEAD
    git -C "$root" worktree add "$wt" "$branch" 2>/dev/null ||
      git -C "$root" worktree add -b "$branch" "$wt" || return 1
  fi

  agtermctl session new \
    --cwd "$wt" \
    --workspace-name "$repo" --create-workspace \
    --name "$branch" \
    --command "zsh -ilc 'claude; exec zsh -i'"
}
