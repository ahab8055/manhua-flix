---
type: session
area: meta
status: done
created: 2026-11-08
updated: 2026-11-08
tags: [session]
related: ["[[Conventions]]"]
---
# 2026-11-08 Vault setup

## Goal
Make `docs/` an Obsidian vault acting as Claude's second brain; every new thing recorded.

## Done
- Vault structure, templates, conventions, MOCs.
- Seeded overview, backend, admin, mobile, pipelines, release notes from codebase scan.
- Mirrored auto-memory → [[ADR-001-android-only-store-driven]].
- Root `CLAUDE.md` rules + `.claude/hooks/vault-check.sh` Stop hook (blocks turn end once if code changed but `docs/` didn't).

## Open / next
- Deepen notes as areas get worked on.
