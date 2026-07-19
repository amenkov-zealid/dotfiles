# agterm helpers (https://github.com/umputun/agterm)

# Create a worktree for <branch> under <repo>/.worktrees and open an agterm
# session there running claude: `ags <branch>`
function ags --description 'Worktree + agterm session running claude'
    if test -z "$argv[1]"
        echo "usage: ags <branch>" >&2
        return 1
    end
    if test "$AGTERM_ENABLED" != 1; or not command -q agtermctl
        echo "ags: requires agterm and agtermctl on PATH" >&2
        return 1
    end
    set -l branch $argv[1]
    # first worktree listed is always the main checkout, even when run from another worktree
    set -l root (git worktree list --porcelain | head -1 | cut -d' ' -f2-)
    or return 1
    set -l repo (basename $root)
    set -l wt "$root/.worktrees/$branch"

    # keep .worktrees/ out of git status without touching the repo's .gitignore
    grep -qxF '.worktrees/' "$root/.git/info/exclude" 2>/dev/null
    or echo '.worktrees/' >>"$root/.git/info/exclude"

    if not test -d "$wt"
        # existing local branch (or remote DWIM), else new branch off HEAD
        git -C "$root" worktree add "$wt" "$branch" 2>/dev/null
        or git -C "$root" worktree add -b "$branch" "$wt"
        or return 1
    end

    agtermctl session new \
        --cwd "$wt" \
        --workspace-name "$repo" --create-workspace \
        --name "$branch" \
        --command "zsh -ilc 'claude; exec zsh -i'"
end
