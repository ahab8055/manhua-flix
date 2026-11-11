---
type: note
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [mobile, gotcha]
related: ["[[Mobile-MOC]]", "[[Bugs-MOC]]"]
---
# Mobile Gotchas (scan 2026-11-08)
1. `home_banner` configured, not rendered.
2. `react-native-bootsplash` installed, not wired.
3. ~~Urbanist fonts not bundled~~ — fixed 2026-11-08 (R-01, [[Mobile-Theme]]).
4. Debug buildType signed with release config.
5. Android dev `localhost` → hardcoded LAN IP in `src/network/instance.ts` — update when network changes.
6. Jest smoke test fails on google-mobile-ads native module.
7. README is unchanged RN template.
8. Google sign-in `DEVELOPER_ERROR` → add SHA-1s ([[Mobile-Auth]]).
9. ~~Refresh failure clears MMKV tokens but not `useAuthStore`~~ — fixed 2026-11-08 Step 4 ([[Mobile-Auth#Session lifecycle (redesign Step 4, 2026-11-08)]]). Also: network errors during refresh no longer sign users out.
10. ~~Player WebView fallback had no controls / no error UI~~ — fixed 2026-11-08 Step 6 ([[Video-Playback]]). Remaining: WebView path reports no progress.
11. `Header` ignores `title`/`subtitle` props, so SeeAll/Notifications have no title (X-10).
12. ~~Auto-play next works once~~ — fixed 2026-11-08 Step 6: next/prev from chapters list.
13. Theme `PRIMARY #5030E5` is unused; the real brand is red ([[ADR-002-red-brand-primary]]).
14. NetInfo, toast-message, bootsplash installed but unused. Account deletion UI added Step 8 via `POST /account-deletion-requests/me` ([[Mobile-Settings]]).
