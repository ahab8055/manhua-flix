---
type: moc
area: meta
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [moc, home]
related: ["[[Conventions]]", "[[Changelog]]"]
---
# ManhuaFlix — Second Brain

Persistent project memory for Claude (and humans). Read this first, then the area MOC.

## Areas
- [[Overview-MOC]] — architecture, stack, repo layout, glossary
- [[Backend-MOC]] — NestJS API, data model, auth, notifications, points, ads
- [[Admin-MOC]] — Next.js admin panel
- [[Mobile-MOC]] — React Native Android app
- [[Mobile-Redesign-MOC]] — mobile UI/UX audit + redesign blueprint (awaiting approval)
- [[Pipelines-MOC]] — YouTube → Drive → Dailymotion on Kaggle
- [[Release-MOC]] — Play Store release + screenshots
- [[Decisions-MOC]] — ADRs (why things are the way they are)
- [[Bugs-MOC]] — bugs, root causes, gotchas
- [[Sessions-MOC]] — recaps of bigger work

## Meta
- [[Conventions]] — how to write notes (frontmatter, naming, when to update)
- [[Changelog]] — what changed, newest first
- Templates: `_templates/`

## How Claude uses this vault
1. **Before work:** read Home → area MOC → relevant notes + decisions.
2. **After any change/decision/discovery:** update or create the note, bump `updated`, link from MOC, append to [[Changelog]].
3. Enforced by root `CLAUDE.md` + Stop hook `.claude/hooks/vault-check.sh`.

## Current state (2026-11-08)
- Mobile 1.0.4 (vc 5) on Play Store, Android only ([[ADR-001-android-only-store-driven]]).
- Backend migrations through `0048_colab_jobs_log_tail`.
- Mobile redesign blueprint proposed, awaiting approval ([[Redesign-Dashboard]], [[ADR-003-redesign-artifact-first]]).
- Known issues: [[Backend-Gotchas]], [[Admin-Gotchas]], [[Mobile-Gotchas]].
