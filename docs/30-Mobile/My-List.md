---
type: feature
area: mobile
status: active
created: 2026-11-09
updated: 2026-11-09
tags: [feature, mobile, my-list, redesign]
related: ["[[Mobile-Navigation]]", "[[Mobile-API]]", "[[Mobile-UI-Kit]]", "[[Redesign-Roadmap]]"]
---
# My List (redesign Step 9)

## What it does
- Tab `MyList` → `src/screens/app/my-list/MyListScreen.tsx`. `SegmentedControl` Continue · Favorites · History; route param `segment` (Home "See all" → continue, Profile shortcuts → continue/favorites/history), cleared after use.
- Guest: one EmptyState "Sign in to save your list" → AuthPromptSheet.
- **Continue** (`ContinueList.tsx`): `GET /home-feed/continue-watching?page`, rows `MyListRow` with progress; tap resumes (`buildEpisodeParams` + `initialPlaybackSeconds`); ⋯ → Go to series / Remove (`DELETE /watch-progress/:manhuaId`).
- **Favorites** (`FavoritesGrid.tsx`): `GET /favorites?page&limit=24&sort`, 3-col `PosterCard` grid, sort chips Recently added / Oldest / A–Z (backend has no "recently updated"). Long-press (or TalkBack action) → Go to series / Remove from My List.
- **History** (`HistoryList.tsx`): `GET /watch-history/me?page`, `SectionList` Today / Yesterday / Earlier (local time, `groupByDay`). Tap plays (resume if <90%, else from start; video ids now in response). ⋯ → Go to series / Remove (`DELETE /watch-history/:id`). "Clear all" → ConfirmSheet → `DELETE /watch-history/me` (Continue Watching kept).
- No ads here yet (D-33; native cards wait for R-18).

## Key pieces
- `src/hooks/use-paged-list.ts` — first `useInfiniteQuery` in the app; next page while `meta.page < meta.totalPages` (short pages OK — continue-watching `total` can over-count).
- `src/utils/undoable-remove.ts` — hide now + Undo toast, server call after 5s; undo/failure restores. No restore APIs needed. Timer is module-level, so leaving the screen still commits; killing the app inside 5s cancels the remove.
- `src/api/cache-sync.ts` `removeFromPagedLists` / `restoreQueries` — optimistic removal across infinite caches under a prefix.
- Keys `queryKeys.myList.{favorites(sort),continue(),history()}` extend legacy prefixes so `syncManhuaEngagement` and Home's continue invalidation reach them.

## Gotchas
- Favorites caches are now `{pages:[{data,meta}]}`. Detail's favorite toggle (`use-manhua-detail.ts`) only does optimistic **removal** via `removeFromPagedLists`; add just refetches (old insert/sort helpers deleted).
- Legacy `FavoritesScreen` + `WatchHistoryScreen` and route `WatchHistory` removed.
