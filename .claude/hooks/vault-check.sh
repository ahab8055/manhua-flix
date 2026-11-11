#!/usr/bin/env bash
# Stop hook: if code changed more recently than the docs vault, block once and
# remind Claude to record the change in docs/ (see docs/_meta/Conventions.md).
set -uo pipefail

input="$(cat)"
# Avoid loops: if we already blocked once this stop cycle, let it finish.
if printf '%s' "$input" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi

root="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}"
[ -n "$root" ] && cd "$root" || exit 0

mtime() { stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null || echo 0; }

newest_code=0
newest_file=""
check_repo() { # $1 = repo dir relative to root ("" for root)
  local dir="$1" line path full t
  while IFS= read -r line; do
    path="${line:3}"; path="${path##* -> }"; path="${path%\"}"; path="${path#\"}"
    full="${dir:+$dir/}$path"; full="${full%/}"
    case "$full" in docs|docs/*|graphify-out|graphify-out/*|.claude|.claude/*|apps/admin|apps/backend|apps/mobile) continue ;; esac
    [ -e "$full" ] || continue
    t=$(mtime "$full")
    if [ "$t" -gt "$newest_code" ]; then newest_code=$t; newest_file=$full; fi
  done < <(git -C "${dir:-.}" status --porcelain --ignore-submodules=all 2>/dev/null)
}

check_repo ""
for sm in apps/admin apps/backend apps/mobile; do
  [ -d "$sm" ] && check_repo "$sm"
done

[ "$newest_code" -eq 0 ] && exit 0

newest_docs=0
if [ -d docs ]; then
  while IFS= read -r f; do
    t=$(mtime "$f"); [ "$t" -gt "$newest_docs" ] && newest_docs=$t
  done < <(find docs -type f -name '*.md' -not -path 'docs/.obsidian/*' 2>/dev/null)
fi

if [ "$newest_code" -gt "$newest_docs" ]; then
  reason="Code changed after the last docs vault update (latest: $newest_file). Before finishing, record what changed in the Obsidian vault per docs/_meta/Conventions.md: update/create the relevant note in docs/, link it from its area MOC, bump 'updated', and add a line to docs/_meta/Changelog.md. If nothing is worth recording (trivial/temporary change), say so briefly and stop."
  printf '{"decision":"block","reason":%s}\n' "$(printf '%s' "$reason" | python3 -c 'import json,sys;print(json.dumps(sys.stdin.read()))')"
fi
exit 0
