---
type: module
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-11
tags: [mobile, state]
related: ["[[Mobile-MOC]]"]
---
# Mobile State

## Zustand `src/store/`
- `useAuthStore`: `user`, `tokens`, `isAuthenticated = Boolean(user && tokens)`, `isLoading`; hydrated sync from MMKV.
- `useAppUpdateStore`: `updateRequired` (not persisted).

## MMKV `src/utils/storage.ts` — id `manhua_mobile_storage`
| Key | Owner |
|---|---|
| `user`, `tokens` | auth store, axios refresh |
| `push_device_token`, `push_device_token_synced_at` (resync 12h) | `services/push-notifications.ts` |
| `release_alerts_enabled` (default true), `release_topic_subscribed` | `services/release-notifications.ts` |
| `notification_pending_press` | parked background press |
| `local_notification_inbox` | `services/local-notification-inbox.ts` |

## React Query ↔ device (since 2026-11-08, redesign Step 3)
- `src/services/network.ts` `setupNetworkManagers()` (called at module load in `src/providers/AppProvider.tsx`): `onlineManager` ← NetInfo (`isConnected !== false && isInternetReachable !== false`; unknown = online), `focusManager` ← AppState `active`.
- Effect: queries pause offline, refetch on reconnect and on app foreground (stale only). `mutations.retry = 0`.
- UI: [[Mobile-UI-Kit]] OfflineBanner, `useIsOffline()`.

## Persisted cache — offline-first (Step 23, [[ADR-005-persisted-query-cache]])
- `src/services/query-persistence.ts`: MMKV id `query_cache`, key `rq-cache`, throttle 1s, `PERSIST_MAX_AGE_MS` 3 days, `PERSIST_BUSTER` = version-build. `shouldPersistQuery` allowlist (prefixes) + comments preview only; infinite lists saved with page 1 only (custom `serialize`).
- `AppProvider`: `PersistQueryClientProvider`; defaults `staleTime` 60s, `gcTime` = max age, `networkMode: 'offlineFirst'`. `useCacheStore` (`src/store/cache`) `restored` flips on restore success/error.
- Boot (`navigation/index.tsx`): waits for `restored`; cached Home → hide splash after restore (update check raced 1.5s); else prefetch Home (6s ceiling).
- `api/cache-lookup.ts` `findCachedManhua` → Detail + Episode `manhuaQuery.placeholderData`.
- `signOut()` → `queryClient.clear()` + `clearPersistedQueries()`.
- Adding a query key: decide whether it belongs in the allowlist (privacy, size, arbitrary params).
