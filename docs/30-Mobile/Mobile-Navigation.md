---
type: module
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-09
tags: [mobile, navigation]
related: ["[[Mobile-MOC]]"]
---
# Mobile Navigation

`src/navigation/` (types `src/types/routes/index.ts`).

## RootNavigation `navigation/index.tsx`
1. `SplashScreen` while `useAuthStore.isLoading`.
2. `ForceUpdateScreen` if `useAppUpdateStore.updateRequired` ([[In-App-Update]]).
3. Else `NavigationContainer(navigationRef)` → `AppStack`.

Startup: wait 300ms MMKV hydrate → `Promise.allSettled([checkForUpdate(), prefetch ['manhuas','featured'], ['home-feed','recently-added'], ['home-feed','new-updates']])` → hide splash (max 6s). `setupPushNotifications` re-run on auth change. AppState `active` → `checkForUpdate()` + `syncPushToken()`.

## AppStack (native-stack, no header) — guests can browse
| Screen | Purpose |
|---|---|
| `Tabs` | bottom tabs |
| `Detail {id}` | manhua info, chapters, recs, progress, favorite, like, channel subscribe, comments, `detail_banner` |
| `Episode {manhuaId, chapterId, …, dailymotion*, next*}` | player, progress save, rewarded bonus, `episode_banner`, comments |
| `Notifications` | server history + local inbox |
| `ChangePassword`, `AboutApp`, `PrivacyPolicy` | |
| `Settings`, `DeleteAccount` | Step 8, [[Mobile-Settings]]; `DeleteAccount` has `gestureEnabled:false` |
| `SeeAll {title, items}` | grid of rail |
| `ChannelDetail { channelId, preview? }` | header preview + subscribe, alerts, paged uploads ([[Mobile-Channels]]) |
| `Login`, `SignUp`, `ForgotPassword {redirectTo?}` | auth then redirect back |

## AppTabs (custom `BottomTabBar`, initial `Home`) — redesign Step 5 (2026-11-08)
Order: **Home · Search · My List (`MyList`) · Channels · Profile**. `backBehavior="initialRoute"`.
- `MyList` → `MyListScreen` (Step 9, [[My-List]]); params `{ segment?: 'continue'|'favorites'|'history' }`. `WatchHistory` stack route removed (History segment). Old route name `Favorites` removed.
- `src/components/BottomTabBar.tsx`: kit `Icon` + tokens; active = filled icon + brand label + 3px top indicator; `tablist`/`tab` roles, `testID="tab-<Route>"`, min height 56; emits `tabPress`/`tabLongPress`.
- Re-tap active tab → scroll to top via `useScrollToTop(scrollToTopRef)` in Home/Search/My List (active segment list)/Channels/Profile main scrollers.
- Tab-bar ad banner removed (D-20); see [[Mobile-Ads]].
- Legacy content (pre-Step 5): Channels · Favorites · Home(centre) · Search · Profile; screens: Home (featured carousel, continue watching, recently added, new updates) · Search (genres, recs, history, suggestions) · Profile (RPG stats/rank/level, avatar upload, notif prefs, release-alerts toggle, links, logout).

Auth gate: legacy `hooks/use-auth-guard.ts` `requireAuth(redirectTo)`; new `useRequireAuth()` + AuthPromptSheet ([[Mobile-Auth]]). Global `ProgressionMilestoneHost` (level-up animations, watches `['my-profile']`).

## Home & Detail — redesign Step 7 (2026-11-08)
- **Home** (`src/screens/app/HomeScreen.tsx`): AppHeader brand + bell badge (`useUnreadNotificationsCount`); HeroCarousel (Play → `openFirstEpisode`, Details); Continue Watching `WideCard` → **Episode directly** via `buildEpisodeParams(lastChapter, progressSeconds)` (⋯ → ConfirmSheet → `deleteWatchProgress`); New Episodes; ad; Recently Added; **Popular** (`fetchPopularRecommendations('popular',12)`, key `['manhuas','recommendations','popular']`); ad. Query keys for featured/recently-added/new-updates unchanged (splash prefetch). Per-rail skeleton + compact error/Retry; full ErrorState if all fail.
- **Detail** (`src/screens/app/DetailScreen.tsx` + logic `src/screens/app/detail/use-manhua-detail.ts`, moved verbatim): single virtualized FlatList; hero (cover + scrim, back/share/bell), poster/title/meta, genre chips → Search, primary CTA **Continue Ep N · X%** / **Play Ep 1**, ActionChips (My List, Like, Share, Comments→scroll), synopsis once, `detail_banner`, SegmentedControl **Episodes | About**; episodes toolbar: sort (default **oldest first**), range chips (>50), jump-to sheet. EpisodeRow state from single watch-progress row: in-progress bar on that chapter, **inferred "Watched"** for lower numbers. About: metadata (no slug/type), channel card with Subscribe for everyone (guest → sign-in sheet), "More like this" rail. Comments unchanged.
- Shared: `src/utils/episode-navigation.ts` (`buildEpisodeParams`, `openFirstEpisode`); `api/home-feed.ts` `lastChapter` typed as full `Chapter`.
