---
type: module
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [mobile, ads]
related: ["[[Mobile-MOC]]", "[[Rewarded-Ads]]"]
---
# Mobile Ads

`react-native-google-mobile-ads` ^16.3.3; `mobileAds().initialize()` in `App.tsx`. App ID in `app.json` + manifest meta-data.

- Placements `src/constants/ad-placements.ts`: `home_banner`, `detail_banner`, `episode_banner`.
- Unit lookup `src/config/admob.ts`: placement env → `ADMOB_ANDROID_BANNER_AD_UNIT_ID` → `TestIds` in dev → empty in prod (slot hidden).
- `AdBanner`: `LARGE_ANCHORED_ADAPTIVE_BANNER`, non-personalized, retry 15/30/60s then hide, keeps last ad.
- Rendered: Detail (`detail_banner`), Episode (`episode_banner`). `home_banner` was rendered above the tab bar on every tab until 2026-11-08; **removed in redesign Step 5** (mis-tap risk, D-20). **Back since Step 7 (2026-11-08):** two inline Home slots (after New Episodes, after Popular); Detail banner below synopsis. Loading placeholder now shows a quiet "Ad" label (dev copy removed).
- Rewarded (Episode, placement `episode_player_bonus`): login + daily limit; `RewardedAd.createForAdRequest(unit, {serverSideVerificationOptions: {userId, customData: {r: externalRewardId, p, m}}})` → `EARNED_REWARD` → `POST /ads/claim` → retry while `pending` (SSV) → invalidate `['my-profile']`. Backend side: [[Rewarded-Ads]].
