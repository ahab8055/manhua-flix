---
type: meta
area: meta
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [meta]
related: ["[[Home]]", "[[Changelog]]"]
---
# Vault Conventions

Vault = Claude's long-term project memory. Code is source of truth for *what*; vault holds *why*, *how it fits*, decisions, gotchas, and where to look.

## Frontmatter (required on every note)
| key | values |
|---|---|
| `type` | note · module · feature · pipeline · decision · bug · session · moc · meta |
| `area` | overview · backend · admin · mobile · pipelines · release · meta |
| `status` | active · draft · deprecated · accepted · superseded · fixed · open · done |
| `created` / `updated` | `YYYY-MM-DD` |
| `tags` | list |
| `related` | list of `"[[wikilinks]]"` |

## Naming
- Title-Case-With-Dashes: `Auth.md`, `Video-Playback.md`. Unique names vault-wide (wikilinks are shortest-path).
- Decisions: `60-Decisions/ADR-NNN-short-slug.md`, numbered sequentially.
- Bugs: `70-Bugs/YYYY-MM-DD-short-slug.md`.
- Sessions: `80-Sessions/YYYY-MM-DD-topic.md` (only for multi-step work worth recapping).

## Folder map
`00-Overview` · `10-Backend` · `20-Admin` · `30-Mobile` · `35-Mobile-Redesign` · `40-Pipelines` · `50-Release` · `60-Decisions` · `70-Bugs` · `80-Sessions` · `_templates` · `_assets` · `_meta`

Each area folder has `<Area>-MOC.md` listing its notes. New note → add link to its MOC.

## When to write
| Event | Action |
|---|---|
| New feature / module / endpoint / screen | Create or update note in area; link from MOC |
| Behaviour change | Update the note; bump `updated` |
| Decision or user preference on approach | New ADR in `60-Decisions`; link from [[Decisions-MOC]] |
| Bug with non-obvious root cause | Note in `70-Bugs` |
| Removed thing | Set `status: deprecated`, say what replaced it — don't delete history |
| Any of the above | One line in [[Changelog]] |

## Style
- Terse. Bullets over prose. Cite paths like `apps/backend/src/...`.
- Never put secrets (keys, tokens, cookies, passwords) in the vault — env var *names* only.
- Prefer updating an existing note over creating a near-duplicate. Search first.
- Link liberally with `[[wikilinks]]`; dangling links = TODO notes worth writing.
