---
type: decision
area: mobile
status: accepted
created: 2026-11-08
updated: 2026-11-08
tags: [adr, mobile, process, redesign]
related: ["[[Mobile-Redesign-MOC]]", "[[Redesign-Dashboard]]", "[[Redesign-Roadmap]]"]
---
# ADR-003 Redesign is artifact-first with an explicit approval gate

## Context
- The user requested a full mobile UI/UX audit and redesign.
- They required the blueprint to be documented in the vault before any code changes.

## Decision
- **Phase 1 (blueprint):** only docs in `docs/35-Mobile-Redesign/`. No app code, deps, navigation, API or config changes.
- **Gate:** implementation starts only when the user says exactly **"I approve the redesign. Start implementation"**.
- **Phase 2 (implementation):** screen by screen, following the approved docs. Preserve business logic, auth and API integrations. Track each task as `proposed → approved → implemented → tested` in [[Redesign-Roadmap]] and [[Redesign-Dashboard]].

## Consequences
- Never treat plan approval or other phrasing as implementation approval.
- Doc updates must distinguish proposed work from implemented work.

## Alternatives rejected
- Iterative code-and-design: rejected by the user; they want to review the whole blueprint first.
