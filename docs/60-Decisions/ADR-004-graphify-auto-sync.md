---
type: decision
area: meta
status: superseded
created: 2026-11-11
updated: 2026-11-11
tags: [adr, tooling, graphify]
related: ["[[Knowledge-Graph]]", "[[Decisions-MOC]]"]
---
# ADR-004 Auto-sync graphify-out on every change

> [!warning] Superseded 2026-11-11: user turned auto-sync off and will refresh the graph manually (`/graphify . --update`). Hook `graphify-sync.sh` removed from `.claude/settings.json` and deleted. Kept below for history.

## Context
User wants `graphify-out/` ([[Knowledge-Graph]]) to stay current whenever project code or `docs/` vault changes, without remembering to rebuild.

## Decision
Stop hook `.claude/hooks/graphify-sync.sh` (registered in `.claude/settings.json` next to `vault-check.sh`):
- Code (root + submodules, git-dirty, newer than `graphify-out/graph.json`) → `graphify update .` detached in background. AST only, free, ~10s. Log: `graphify-out/.sync.log`.
- `docs/*.md` newer than stamp `graphify-out/.docs_synced` → block once per docs state; Claude runs `/graphify . --update` (LLM, incremental, cached) then `touch graphify-out/.docs_synced`.
- `vault-check.sh` now ignores `graphify-out/` (it was flagging graph output as "code changed").

## Consequences
- Doc syncs cost tokens (only changed notes re-extracted).
- Only fires inside Claude Code sessions. Edits made in Obsidian alone sync on next Claude session stop; manual: `/graphify . --update`.
- `graphify update` regenerates community labels generically (curated names from first build lost).
- Images (Play Store PNGs) stay excluded.

## Alternatives rejected
- `graphify hook install` (git post-commit): root repo only, misses submodule commits, ignores docs.
- `graphify watch`: needs a long-running process; still ignores docs.
- Rebuild docs on every stop: too many tokens.
