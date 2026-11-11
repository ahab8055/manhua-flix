---
type: bug
area: meta
status: fixed
created: 2026-11-11
updated: 2026-11-11
tags: [bug, graphify, tooling]
related: ["[[Knowledge-Graph]]", "[[ADR-004-graphify-auto-sync]]"]
---
# graphify update wiped 34 docs' nodes (subagent stub nodes)

## Symptom
- `/graphify . --update` for 2 changed docs (Redesign-Roadmap, Changelog) removed 177 nodes / 460 edges.
- Cache save warned "skipped out-of-scope source_file …" for 34 other docs.

## Root cause
- Extraction subagent created stub nodes for `[[wikilink]]` targets and set their `source_file` to the linked note.
- `build_merge` replace-on-re-extract drops **every** `source_file` mentioned in a chunk from the base graph → those 34 docs lost their real nodes, kept only stubs.

## Fix
- Restored from semantic cache (all 77 docs hit): `check_semantic_cache` on the docs → `build_merge` as a new chunk → real nodes back (4427 nodes).
- Rule added to the Stop hook message (`.claude/hooks/graphify-sync.sh`), so every docs sync appends it to subagent prompts.

## How to avoid next time
- Subagent prompt rule: `source_file` on every node/edge/hyperedge must be in its FILE_LIST; no stub nodes for notes outside it; point edges at deterministic stem ids.
- Before merging, drop chunk items whose `source_file` is outside the dispatched list.
- Don't edit `~/.claude/skills/graphify/references/extraction-spec.md`: cache entries are keyed to that prompt (edit = re-extract all docs) and skill upgrades overwrite it.
