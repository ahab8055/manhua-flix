---
type: note
area: mobile
status: draft
created: 2026-11-08
updated: 2026-11-11
tags: [mobile, redesign, qa, testing]
related: ["[[Mobile-Redesign-MOC]]", "[[Redesign-Roadmap]]", "[[Android-Build]]"]
---
# QA Strategy

## Test layers
| Layer | Tool | Scope | Gate |
|---|---|---|---|
| Static | `yarn type-check`, `yarn lint` (+ hex-literal rule) | all PRs | must pass |
| Unit | Jest | zod schemas, `queryKeys`, mappers, next/prev chapter calc, error-copy mapper | must pass |
| Component | Jest + RN Testing Library | UI kit: states, a11y props, press handlers | must pass (R-60) |
| Manual device | release APK | per-screen checklist below | sign-off per screen |
| Accessibility | TalkBack, Accessibility Scanner app | primary tasks | sign-off |
| Regression | checklist "Must not break" | every P2 PR | sign-off |

Prerequisite (R-60): jest mocks for `react-native-mmkv`, `@react-native-firebase/*`, `@notifee/react-native`, `@react-native-google-signin/google-signin`, `react-native-google-mobile-ads`, `react-native-dailymotion-sdk`, `react-native-device-info`. Today the smoke test fails on the ads native module ([[Mobile-Gotchas]]).

## Device / environment matrix
| Axis | Values |
|---|---|
| Devices | low-end (2–3GB RAM, 720p), mid (1080p), large (6.7"), 7" tablet (screenshots exist) |
| Android | 7.0 (minSdk 24), 10, 13, 15/16 (targetSdk 36) |
| Font scale | 1.0 · 1.3 · 1.5 · 2.0 (no crash; clipping allowed only at 2.0) |
| Display size | default, largest |
| Network | Wi-Fi, 3G throttled, airplane mode, flapping |
| Account | guest, email user, Google-only user, user with large data (30+ favs, 60+ notifs, 400-ep series) |
| Build | debug + **release** (fonts, ads, In-App Update only behave correctly in release) |
| Gestures | 3-button and gesture navigation (safe areas, back) |

## Per-screen checklist (copy per PR)
- [ ] Matches wireframe/spec; tokens only.
- [ ] Loading = skeleton matching the layout; no spinner and empty state shown together.
- [ ] Empty state with an action.
- [ ] Error state with Retry and user-facing copy.
- [ ] Offline: banner visible; cached data shown; mutations explain why they're disabled.
- [ ] Pull-to-refresh only shows on a user pull.
- [ ] Every mutation has a pending state + success/error toast; destructive actions confirm or offer undo.
- [ ] Guest: every gated action opens AuthPromptSheet and replays after login.
- [ ] Back (hardware + header) returns to the expected screen.
- [ ] TalkBack: every control announces name + role + state; order is logical.
- [ ] Font scale 1.5: no clipped text, no overlapping.
- [ ] Targets ≥48dp (Accessibility Scanner clean).
- [ ] Scroll performance: no visible jank on a low-end device with 100+ items.
- [ ] No dev strings visible.

## Must-not-break (regression list)
- [ ] Email login/signup, Google sign-in, forgot password email, change password.
- [ ] Token refresh on 401; logout clears the push token.
- [ ] Watch progress saves (15s, background, unmount, 90%) and resumes at the saved position.
- [ ] Points awarded; level-up overlay; rewarded ad SSV claim ([[Rewarded-Ads]]).
- [ ] Favorites/likes/subscriptions/pins persist and reflect across all screens.
- [ ] Comments: post, reply (incl. reply-to-reply @mention), like/dislike + tap again removes, edit own, delete own, Top/Newest, paginate past 20 ([[Mobile-Comments]]).
- [ ] Push: topic subscription, per-user push, tap deep links (cold, background, foreground) ([[Push-Notifications]]).
- [ ] Notification preferences + per-channel alerts + release alerts toggle.
- [ ] AdMob banners on detail/episode placements; no ad within 48dp of nav controls.
- [ ] Force update (In-App Update) in release build ([[In-App-Update]]).
- [ ] Avatar upload to Cloudinary.

## Flow test scripts (key)
1. **Binge:** Home → Continue → Episode plays at the saved time → let it finish → Up Next counts down → Ep N+1 → Next → Ep N+2 → Prev. Repeat as a guest.
2. **Search:** type "hun" → suggestion → back → submit "hunter" → results → filter Status → scroll past 20 → open title.
3. **Guest conversion:** guest → ChannelDetail → Subscribe → sheet → Google → back on ChannelDetail, subscribed, toast.
4. **Delete account:** email user and Google user → Settings → Account → Delete → type DELETE → guest Home; login now shows "deletion pending"; admin sees request with 7-day due date; approve → data gone; reject → login works again.
5. **Session expiry:** invalidate the refresh token server-side → pull to refresh → guest + toast.
6. **Offline:** airplane mode on Detail → banner, cached content, Like disabled with explanation → reconnect → auto refetch.
7. **Player fallback:** chapter with no resolvable Dailymotion id → WebView controls work; bad id → error overlay + Retry.

## Release validation
- [ ] `./gradlew bundleRelease` succeeds; version bumped ([[Play-Store-Release]]).
- [ ] Internal testing track install; Play pre-launch report clean (a11y warnings reviewed).
- [ ] Data safety form updated to match the privacy policy (R-11).
- [ ] Store screenshots re-shot if the UI materially differs ([[Play-Store-Screenshots]]).
