---
type: note
area: overview
status: active
created: 2026-11-11
updated: 2026-11-11
tags: [tooling, graphify, knowledge-graph]
related: ["[[Overview-MOC]]", "[[Repo-Layout]]", "[[Architecture]]", "[[ADR-004-graphify-auto-sync]]"]
---
# Knowledge Graph (graphify)

## Summary
- Repo-wide knowledge graph built with graphify CLI (`uv tool install graphifyy`, skill at `~/.claude/skills/graphify/`).
- Output: `graphify-out/` at repo root — `graph.html` (browser viz), `GRAPH_REPORT.md` (audit), `graph.json` (queryable), `manifest.json` + `cache/` (for `--update`).
- Use for structural / cross-doc questions: `graphify query "<q>"`, `graphify path "A" "B"`, `graphify explain "X"`. Plain grep still faster for single lookups.

## Details
- First build 2026-11-11: 619 files (530 code via tree-sitter AST, 89 docs via 5 Claude subagents, ~440k subagent tokens). 48 PNGs (Play Store screenshots) deliberately excluded — low value, 1 agent each.
- Result: 4274 nodes · 10855 edges · 194 communities (~70 thin).
- Docs ↔ code linked: vault `[[wikilinks]]` become `references` edges; doc nodes id'd by full path stem (e.g. `docs_30_mobile_video_playback`).
- God nodes: `AppText()`, `Roles()`, `TokenPayload`, `NotificationsService`, theme `tokens`, `PaginationDto`/`PaginatedResult`.
- Findings worth a look:
  - Import cycle `apps/backend/src/auth/auth.module.ts` ↔ `apps/backend/src/users/users.module.ts`.
  - [[Points-Progression]] is top cross-community bridge (betweenness 0.405).
  - AMBIGUOUS: admin `lib/dailymotion.ts` vs native player; mobile `signOut()` vs `setupPushNotifications`.
- Health: 40 dangling-endpoint edges, 2 self-loops; ~600 collapsed edges are repeated DTO decorator refs (benign).
- **Manual sync only** (auto-sync hook removed 2026-11-11, [[ADR-004-graphify-auto-sync]] superseded): user runs `/graphify . --update` when needed. Obsidian export available via `graphify export obsidian --dir graphify-out/obsidian` — keep it out of `docs/` to avoid noise.
- Subagent rule (add to every extraction prompt): `source_file` only from FILE_LIST, no stub nodes for wikilink targets — else replace-on-re-extract wipes those docs ([[2026-11-11-graphify-stub-nodes-wipe-docs]]).
- `graphify-out/` is gitignored (root `.gitignore`); rebuild locally with `/graphify .`.

## Links
- [[Overview-MOC]] · [[Repo-Layout]] · [[Architecture]]
