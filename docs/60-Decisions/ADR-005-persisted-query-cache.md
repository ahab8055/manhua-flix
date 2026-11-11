---
type: decision
area: mobile
status: accepted
created: 2026-11-11
updated: 2026-11-11
tags: [adr, mobile, cache, offline]
related: ["[[Mobile-State]]", "[[Decisions-MOC]]", "[[Redesign-Roadmap]]"]
---
# ADR-005 Persisted React Query cache (offline-first)

## Context
- User (Step 23): show already-loaded data instead of loading states, and update listings when new data arrives.
- Until now the cache lived in memory only (D-26 deferred persistence): every cold start waited on the network behind the splash, then screens showed skeletons; offline launch showed nothing.

## Decision
- Persist the React Query cache to its own MMKV instance (`query_cache`) via `@tanstack/react-query-persist-client` + `@tanstack/query-sync-storage-persister` (`src/services/query-persistence.ts`, wired in `src/providers/AppProvider.tsx`).
- Stale-while-revalidate: restored data renders at once; queries keep `staleTime` 60s, so they refetch on mount/focus/reconnect and replace the data in place. `networkMode: 'offlineFirst'`, `gcTime` = persisted max age (3 days).
- Allowlist only (`shouldPersistQuery`): titles, episodes lists, Home feeds, featured/recommendations, My List, statuses, watch progress/history, profile, channels, notifications, comments preview, genres, search history. Infinite lists keep only page 1 on disk.
- `buster` = app version + build. Sign-out (any reason) clears memory **and** disk (`clearPersistedQueries`).
- Boot: cached Home → splash hides right after restore (update check raced at 1.5s); no cache → old prefetch path.
- Detail / Episode use the tapped list row (`findCachedManhua`) as `placeholderData`.

## Consequences
- Cold start and offline launch show the last known screens; first launch / after sign-out still load from network.
- Cached data may be up to a refetch old (seconds online); counts update in place.
- New query keys are **not** persisted unless added to the allowlist — decide per key (privacy, size, arbitrary params).
- Changing a persisted response shape needs no migration: the next build busts the cache.

## Alternatives rejected
- Persist everything (search results/suggestions grow unbounded; other users' profiles).
- Hand-rolled MMKV caches per screen (duplicates React Query, breaks the single-key sync from Step 19).
- AsyncStorage persister (async restore → visible flash; MMKV is sync and already installed).
