#!/usr/bin/env bash
input=$(cat)

c() { printf '\033[%sm%s\033[0m' "$1" "$2"; }

label="M5"

project_dir=$(jq -r '.workspace.project_dir // .workspace.current_dir' <<<"$input")
dir_name=$(basename "$project_dir")
branch=$(git -C "$project_dir" branch --show-current 2>/dev/null)

model=$(jq -r '.model.display_name' <<<"$input")
ctx_size=$(jq -r '.context_window.context_window_size // 200000' <<<"$input")
model_str="$model"
[ "$ctx_size" = "1000000" ] && model_str="$model (1M context)"

used_tokens=$(jq -r '.context_window.total_input_tokens // 0' <<<"$input")
used_pct=$(jq -r '((.context_window.used_percentage // 0) | round)' <<<"$input")
tokens_fmt=$(awk -v t="$used_tokens" 'BEGIN{printf "%dk", t/1000}')

week_pct=$(jq -r '.rate_limits.seven_day.used_percentage // empty' <<<"$input")
resets_at=$(jq -r '.rate_limits.seven_day.resets_at // empty' <<<"$input")

week_part=""
if [ -n "$resets_at" ]; then
  remaining=$((resets_at - $(date +%s)))
  days=$((remaining / 86400))
  hours=$(((remaining % 86400) / 3600))
  week_pct_rounded=$(printf '%.0f' "$week_pct")
  week_part=" $(c '2;32' "${days}d${hours}h·${week_pct_rounded}%")"
fi

branch_part=""
[ -n "$branch" ] && branch_part=" $(c 33 "[$branch]")"

out="$(c '1;37' "${label}:") $(c 32 "$dir_name")${branch_part} $(c 37 "[${model_str}]") $(c 35 "${tokens_fmt}/${used_pct}%")${week_part}"
echo "$out"
