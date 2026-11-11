---
type: module
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-09
tags: [mobile, api]
related: ["[[Mobile-MOC]]", "[[Backend-API]]"]
---
# Mobile API Layer

- `src/network/instance.ts`: `apiClient` axios, `baseURL = API_BASE_URL`, timeout 10s. Android dev replaces `localhost` with hardcoded LAN IP.
- Bearer from MMKV `tokens`. 401 → single shared `refreshInFlight` → `POST /auth/refresh` via separate `refreshClient` → retry once; fail → delete tokens.
- React Query `providers/AppProvider.tsx`: `staleTime 60s`, `retry 1`; `queryClient` exported.
- Endpoints: `src/constants/Endpoints.ts` + `src/api/*` (auth, channels, cloudinary, comments, genres, home-feed, manhuas, notifications, rewarded-ads, users, watch-history). Full list → [[Backend-API]]. Uses: auth register/login/google/refresh/forgot; users me profile/password; cloudinary upload; manhuas list/featured/:id/chapters/view/like/recommendations(mixed, detail)/search/suggestions; comments; genres; favorites; search-history; home-feed; watch-progress; watch-history; channels; notifications devices/history/read/preferences; `POST /ads/claim`.
- Query keys: `['manhuas', …]`, `['manhua', id]`, `['chapters', id]`, `['home-feed', …]`, `['favorites', 'list', sort]` (infinite), `['favorite-status', id]`, `['watch-progress', id]`, `['watch-history','me','list']` (infinite), `['genres']`, `['search-history','me']`, `['channels', …]`, `['notifications', …]`, `['comments', id]`, `['my-profile']`, `['user-profile', id]`.
- Favorites + subscriptions: optimistic updates with rollback.

## Query keys + cache sync (redesign Step 4, 2026-11-08)
- `src/api/query-keys.ts` `queryKeys` mirrors existing keys (numeric ids). New code must use it; legacy call sites migrate per screen.
- `src/api/cache-sync.ts`: `syncManhuaEngagement(qc, id)` (manhua, favorite-status, episode-like-status, favorites*, continue-watching, my-profile) and `syncChannelSubscription(qc, id)` (subscription, detail, channel, channels/subscribed*, recommended, sections). Used by Detail/Episode like+favorite and Detail/ChannelDetail subscribe.
- Episode like/favorite now toast friendly errors (`getFriendlyErrorMessage`).
- `ENDPOINTS.LOGOUT` + `logoutUser()` added.
