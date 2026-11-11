---
type: module
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-11
tags: [mobile, ads]
related: ["[[Mobile-MOC]]", "[[Rewarded-Ads]]"]
---
# Mobile Ads

`react-native-google-mobile-ads` ^16.3.3; `mobileAds().initialize()` in `App.tsx`. App ID in `app.json` + manifest meta-data.

- Placements `src/constants/ad-placements.ts` (Step 20, R-18):
  - Banners `BANNER_AD_PLACEMENTS`: `home_banner`, `detail_banner`, `episode_banner`, `search_banner`, `channel_detail_banner`, `profile_banner`.
  - Natives `NATIVE_AD_PLACEMENTS`: `home_native`, `search_results_native`, `my_list_native`, `channels_native`, `notifications_native`, `comments_native`.
- Unit lookup `src/config/admob.ts`: placement override env → shared format unit (`ADMOB_ANDROID_BANNER_AD_UNIT_ID` / `ADMOB_ANDROID_NATIVE_AD_UNIT_ID`) → `TestIds` in dev → `''` (slot hidden). Override env names: `ADMOB_ANDROID_{HOME,DETAIL,EPISODE,SEARCH,CHANNEL_DETAIL,PROFILE}_BANNER_AD_UNIT_ID`, `ADMOB_ANDROID_{HOME,SEARCH_RESULTS,MY_LIST,CHANNELS,NOTIFICATIONS,COMMENTS}_NATIVE_AD_UNIT_ID` (all optional; listed in `.env.example`).
- **`.env.prod` had no AdMob ids at all (2026-11-11)** — release builds built from it show no ads until the ids are added.
- `components/ads/NativeAdCard.tsx`: `NativeAd.createForAdRequest` (non-personalized), `NativeAdView` + `NativeAsset` (headline, body/advertiser, icon, CTA) + `NativeMediaView` (card only, 16:9, ≥120dp — AdMob minimum). Renders nothing until loaded, retries 15/30/60s then hides, `destroy()` on unmount. Variants `row` / `card`. Yellow "Ad" badge.
- `utils/ad-slots.ts`: `withAdSlots(items, {first, every, max})`, `toGridRowsWithAds` (grids become rows of 3 with full-width ad rows; poster cells are too narrow for native media).

| Screen | Slot | Format |
|---|---|---|
| Home | after New Episodes / after Popular | native card / banner |
| Detail | below synopsis | banner (episode-list native every 25 rows **deferred**: breaks `getItemLayout` + scroll-to-comments math) |
| Episode | below Up Next | banner + rewarded (unchanged) |
| Search idle / results | below Popular / after row 2 then every 6 rows | banner / native card row |
| My List | Favorites after 3 rows then every 4; History after 9 then every 12 | native card row / native row |
| Channels / ChannelDetail | between Subscribed and Discover / above Uploads | native card / banner |
| Notifications | after first day group (2+ groups) | native row |
| Comments | every 8 | native row (was banner) |
| Profile | below shortcuts (signed in + guest) | banner |
- Never: auth, Settings, Delete account, About, Privacy, ForceUpdate, Splash. Interstitial + app-open still deferred (D-23).
- `AdBanner`: `LARGE_ANCHORED_ADAPTIVE_BANNER`, non-personalized, retry 15/30/60s then hide, keeps last ad.
- Rendered: Detail (`detail_banner`), Episode (`episode_banner`). `home_banner` was rendered above the tab bar on every tab until 2026-11-08; **removed in redesign Step 5** (mis-tap risk, D-20). **Back since Step 7 (2026-11-08):** two inline Home slots (after New Episodes, after Popular); Detail banner below synopsis. Loading placeholder now shows a quiet "Ad" label (dev copy removed).
- Rewarded (Episode, placement `episode_player_bonus`): login + daily limit; `RewardedAd.createForAdRequest(unit, {serverSideVerificationOptions: {userId, customData: {r: externalRewardId, p, m}}})` → `EARNED_REWARD` → `POST /ads/claim` → retry while `pending` (SSV) → invalidate `['my-profile']`. Backend side: [[Rewarded-Ads]].
