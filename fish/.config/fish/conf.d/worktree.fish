# Fuzzy-switch between git worktrees for the current repo
function wt --description 'Fuzzy-switch between git worktrees'
    set -l dir (git worktree list --porcelain | awk '
        /^worktree /{p=$2}
        /^branch /{b=$2; sub("refs/heads/","",b); print p"\t"b; next}
        /^detached/{print p"\t(detached)"}
    ' | fzf --delimiter='\t' --with-nth=2 \
        --preview 'git -C {1} log --oneline --color=always -n 20' \
        --preview-window down:60% | cut -f1)
    test -n "$dir"; and cd "$dir"
end

# Create (or resume) a worktree for <branch>, init submodules, and cd into it
function wta --description 'Create a worktree and cd into it'
    if test -z "$argv[1]"
        echo "usage: wta <branch>"
        return 1
    end
    set -l dir (mise run wt-add "$argv[1]")
    or return 1
    cd "$dir"
end

# Fuzzy-remove a worktree (never lists the main checkout)
function wtrm --description 'Fuzzy-remove a worktree'
    set -l sel (git worktree list --porcelain | awk '
        /^worktree /{p=$2}
        /^branch /{b=$2; sub("refs/heads/","",b); print p"\t"b; next}
        /^detached/{print p"\t(detached)"}
    ' | rg '/worktrees/' | fzf --delimiter='\t' --with-nth=2)
    test -z "$sel"; and return
    set -l branch (echo "$sel" | cut -f2)
    mise run wt-rm "$branch"
end
