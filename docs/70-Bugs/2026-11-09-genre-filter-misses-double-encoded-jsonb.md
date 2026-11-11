---
type: bug
area: backend
status: open
created: 2026-11-09
updated: 2026-11-09
tags: [bug, backend, search, jsonb, drizzle]
related: ["[[Mobile-Search]]", "[[Backend-Gotchas]]", "[[Data-Model]]"]
---
# Genre filter misses most titles (double-encoded jsonb)

## Symptom
- User: "Genre filters are not working fine" (Step 11 Search).
- Live API 2026-11-09: `GET /manhuas/search?genres=Action` → total **1**, yet 18 of the top 20 `recommendations` items carry "Action". `Martial Arts`, `Harem` → 0 (6 and 2 seen in recs).

## Root cause
- drizzle-orm **0.31** + postgres-js driver double-encodes `jsonb` on write → `manhuas.genres` stored as a jsonb **string** `"[\"Action\"]"`, not an array. Reads look fine (drizzle parses the string again), so the API/app show arrays.
- SQL filters treated non-arrays as "no genres": `buildGenreFilter` (search + suggestions), Detail same-genre recommendations, admin `genre` filter (`@>`).
- The one matching title was likely written outside drizzle (seed/SQL).
- Confidence: high from API evidence + known driver behaviour; DB read to count `jsonb_typeof` was blocked (prod read permission) — not directly confirmed.

## Fix
- `apps/backend/src/manhuas/manhuas.service.ts` `genresArray()`: unwrap jsonb strings that start with `[`; used in all 3 places. Backend `f675d7f` on `feat/search-filters` (not deployed).
- Not yet done: data cleanup (`update manhuas set genres = (genres #>> '{}')::jsonb where jsonb_typeof(genres)='string'`) and stopping new double-encoded writes (upgrade drizzle-orm ≥ 0.33 with postgres-js jsonb fix, or write via `sql\`${JSON.stringify(v)}::jsonb\``). Other jsonb columns (chapters, colab_jobs, ad_events, notification tables) likely affected the same way.

## How to avoid next time
- Any SQL over jsonb columns: go through a normalizing helper or fix storage first. Check `jsonb_typeof` when a jsonb filter returns too few rows.
