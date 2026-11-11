---
type: moc
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-11
tags: [moc, mobile]
related: ["[[Home]]", "[[ADR-001-android-only-store-driven]]"]
---
# Mobile MOC

`apps/mobile` — React Native 0.83.1, React 19.2, New Arch + Hermes, arm64-v8a only. Yarn 1 (not in pnpm workspace). Display name **Manhwaflix**, package `com.manhuamobile`. **Android only** ([[ADR-001-android-only-store-driven]]). Alias `@` → `src`; env via `react-native-dotenv` (`@env`, `ENVFILE`).

- [[Mobile-Navigation]] — root flow, stack + tabs, screens
- [[Mobile-State]] — Zustand stores, MMKV keys
- [[Mobile-API]] — axios instance, refresh, endpoints, query keys
- [[Mobile-Auth]] — email + Google sign-in
- [[Video-Playback]] — Dailymotion native SDK + WebView fallback
- [[Mobile-Ads]] — AdMob banners + rewarded
- [[Push-Notifications]] — FCM + notifee, topic, deep links
- [[In-App-Update]] — Kotlin Play In-App Updates force update
- [[Mobile-Theme]] — colors, fonts, splash
- [[Mobile-Comments]] — Comments preview + full screen, optimistic votes, edit/delete own, one-level replies (Step 15)
- [[Mobile-Channels]] — Channels tab + ChannelDetail, shared subscription hook (Step 12)
- [[Mobile-Search]] — Search tab: suggestions, paged results with Status/Sort, recents, popular (Step 11)
- [[Mobile-Profile]] — Profile tab: identity, collapsible stats, edit sheet, progression overlays (Step 10)
- [[My-List]] — My List tab: Continue / Favorites / History, infinite lists, Undo removes (Step 9)
- [[Mobile-Settings]] — Settings + Delete account screens (Step 8)
- [[Mobile-UI-Kit]] — shared redesign components + icons + dev gallery
- [[Android-Build]] — gradle, signing, env files, release output
- [[Mobile-Gotchas]]
- Redesign blueprint → [[Mobile-Redesign-MOC]]

Env names: `API_BASE_URL`, `GOOGLE_WEB_CLIENT_ID`, `DAILYMOTION_PLAYER_ID`, `ADMOB_ANDROID_{HOME,DETAIL,EPISODE}_BANNER_AD_UNIT_ID`, `ADMOB_ANDROID_BANNER_AD_UNIT_ID`, `ADMOB_ANDROID_REWARDED_AD_UNIT_ID`, `PRIVACY_POLICY_URL`, `TERMS_URL`, `SUPPORT_EMAIL`. Files `.env`, `.env.stage`, `.env.prod`. Types `src/types/env.d.ts`.

Scripts: `android`, `start`, `lint`, `test` (jest smoke, fails on ads native module), `type-check`. Husky + lint-staged pre-commit.
