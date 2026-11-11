---
type: moc
area: meta
status: active
created: 2026-11-08
updated: 2026-11-11
tags: [moc, bug]
related: ["[[Home]]"]
---
# Bugs & Gotchas

Non-obvious bugs, root causes, traps. New bug note: `70-Bugs/YYYY-MM-DD-slug.md` from `_templates/Bug.md`.

## Known-issue lists (from 2026-11-08 scan)
- [[Backend-Gotchas]] — incl. security items
- [[Admin-Gotchas]]
- [[Mobile-Gotchas]]

## Bug notes
- [[2026-11-11-graphify-stub-nodes-wipe-docs]] — graphify --update wiped 34 docs: subagent stub nodes carried other notes' source_file (restored from cache; prompt rule in sync hook)
- [[2026-11-11-malicious-git-hooks]] — machine compromise Jun 2: stealer, cron persistence, curl|sh git hooks in 26 repos (open, security)
- [[2026-11-09-genre-filter-misses-double-encoded-jsonb]] — genre filters missed most titles: drizzle 0.31 + postgres-js store jsonb as string (read-side fix in code; data cleanup open)
- [[2026-11-08-player-error-over-playing-video]] — SDK non-fatal errors showed error overlay over playing video (fixed)
