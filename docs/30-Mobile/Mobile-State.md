---
type: module
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-08
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
