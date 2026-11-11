---
type: feature
area: mobile
status: active
created: 2026-11-09
updated: 2026-11-09
tags: [feature, mobile, channels, redesign]
related: ["[[Mobile-Navigation]]", "[[Push-Notifications]]", "[[Backend-API]]", "[[Mobile-UI-Kit]]"]
---
# Mobile Channels (redesign Step 12)

## Channels tab (`src/screens/app/channels/ChannelsScreen.tsx`)
- `Screen` + `AppHeader` "Channels" (old 40% hero gone). One `SectionList`.
- **Signed in**: Pinned (subscription.pinnedOrder != null) → Subscribed (Show more = next page) → Discover (`GET /channels/recommended`, See more). Subscribed rows ⋯ → Pin to top / Unpin, upload alerts on/off, Unsubscribe (ConfirmSheet). Rows with alerts off show "Alerts off".
- **Guest**: explainer card + Discover from public `GET /channels` (most subscribed). Subscribe → sign-in sheet, replays after sign-in.
- Pin sends `pinnedOrder` = current pinned count (backend orders asc, no renumbering).

## ChannelDetail (`src/screens/app/channels/ChannelDetailScreen.tsx`)
- Route **`{ channelId: number; preview?: ChannelPreview }`** (old `{ channel }` display object removed). Callers: Channels tab, manhua Detail creator card (`buildCreatorChannelRoute`), push deep links (`buildChannelParam`).
- Header renders from `preview` instantly; real data from `GET /channels/:id`. No preview + fetch error → ErrorState (no fake fallback).
- Banner + scrim, overlay back, avatar, name ✓, @handle, Subscribers / Series, description (3 lines, tap to expand), Subscribe always visible (Subscribed ✓ → confirm unsubscribe), Upload alerts `SwitchRow`.
- Uploads: `usePagedList` over `GET /channels/:id/manhuas?sort=newest|updated|title` (24/page), 3-col posters.

## Shared
- `src/hooks/use-channel-subscription.ts` — status query (`queryKeys.channelSubscription`) + optimistic subscribe/unsubscribe on status, `channelDetail` and `channel` caches, alerts toggle, toasts, `syncChannelSubscription`. Options `fetchStatus: false` + `initialSubscribed` for list rows (no request per row). Used by Channels tab, ChannelDetail and manhua Detail.
- `screens/app/channels/SubscribeButton.tsx` (guest gate + unsubscribe confirm); `components/media/ChannelRow.tsx`; `components/media/Avatar.tsx` (moved from Profile); `utils/format.ts` `formatCount` / `pluralize`; icon `pin`.
- Keys: `channelsPublic()`, `channelsSubscribedList()`, `channelsRecommendedList()`, `channelUploads(id, sort)` — all under `['channels', …]`, so `syncChannelSubscription` reaches them.

## Gotchas
- Upload counts now exclude drafts (backend); admin Channels list count matches.
- No ads on Channels yet (R-18).
