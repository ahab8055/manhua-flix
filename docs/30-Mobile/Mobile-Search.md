---
type: feature
area: mobile
status: active
created: 2026-11-09
updated: 2026-11-09
tags: [feature, mobile, search, redesign]
related: ["[[Mobile-API]]", "[[Mobile-UI-Kit]]", "[[Backend-API]]", "[[Redesign-Roadmap]]"]
---
# Mobile Search (redesign Step 11)

## What it does
- Tab `Search` → `src/screens/app/search/SearchScreen.tsx` (old 1030-line file deleted). Sticky `TextField` (label "Search", `onClear` ✕) + horizontal genre `Chip`s.
- Three modes:
  - **Typing** (focused, text ≠ last submitted) → `SuggestionsList`: first row "Search for “q”" (submits), then `GET /manhuas/suggestions` (debounced 250ms, 8) → Detail. In-flow, no overlay.
  - **Results** (submitted q, or any genre/status) → `ResultsGrid`: `usePagedList` over `GET /manhuas/search` (24/page), 3-col posters, count line, Status + Sort chips → BottomSheets. Empty: "No titles match “q”" + Clear filters.
  - **Idle** → `IdleContent`: Recent searches (signed in; ✕ each, Clear all → ConfirmSheet; guest row → sign-in sheet) + Popular grid (`recommendations?type=popular&limit=9`).
- Sort default: Best match with q, Newest without (Best match hidden without q).
- Saving recents: only on explicit submit (keyboard or "Search for" row). Tapping a recent or a suggestion does **not** save. User casing kept (old `textTransform: capitalize` gone).
- `initialGenres` (Detail genre tag) **replaces** genres and resets q/filters; param cleared after use.

## Keys
- `queryKeys.search.{results(params), suggestions(q, genres), popular()}`, plus `genres()`, `searchHistory()`.

## Backend contract ([[Backend-API]])
- `GET /manhuas/search?q&genres&status&sort&page&limit` — `status` ∈ ongoing|completed|hiatus|dropped, `sort` ∈ relevance|newest|popular|title. Status-only browse allowed. Multiple genres = AND.

## Gotchas
- Genre filter depended on a backend fix for double-encoded jsonb ([[2026-11-09-genre-filter-misses-double-encoded-jsonb]]); old backend returns ~1 title per genre.
- Author isn't searched (title, description, genres only).
- No ads on Search (none before either; placement map R-18).
