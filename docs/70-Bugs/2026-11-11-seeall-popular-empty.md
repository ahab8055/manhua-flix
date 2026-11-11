---
type: bug
area: backend
status: fixed
created: 2026-11-11
updated: 2026-11-11
tags: [bug, backend, search, mobile]
related: ["[[Backend-API]]", "[[Mobile-Navigation]]", "[[Bugs-MOC]]"]
---
# SeeAll "Popular" shows nothing

## Symptom
- Step 16 SeeAll for the Home "Popular" rail pages `/manhuas/search?sort=popular` with no q/genres/status → always empty ("Nothing here yet").

## Root cause
- `ManhuasService.search()` short-circuits to an empty page when there's no q, genres or status (written so a blank search returns nothing). An explicit `sort` was ignored.

## Fix (Step 18, backend `feat/pagination-sweep`)
- Explicit `sort` with no filters → browse branch over all published titles. No params at all → still empty (old callers unchanged).
- Needs the backend deployed; no app change.

## Links
- [[Backend-API#manhuas `src/manhuas/`]]
