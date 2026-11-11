---
type: note
area: mobile
status: draft
created: 2026-11-08
updated: 2026-11-11
tags: [mobile, redesign, audit, a11y]
related: ["[[Mobile-Redesign-MOC]]", "[[Redesign-Roadmap]]", "[[Redesign-Strategy]]", "[[Mobile-Gotchas]]"]
---
# UI/UX Audit (2026-11-08)

Source: full read of `apps/mobile/src` (19 screens, all components). Paths are relative to `apps/mobile/src`, and line numbers are as of 2026-11-08.

Severity:
- **C** Critical: broken flow, store-policy risk, or data loss.
- **H** High: dead end, missing feedback, or a11y blocker.
- **M** Medium: inconsistency or friction.
- **L** Low: polish or copy.

The `→ R-xx` arrows point to tasks in [[Redesign-Roadmap]].

## Severity summary
| Sev | Count | Examples |
|---|---|---|
| C | 6 | Account deletion missing, player fallback dead, no search results, fonts missing, auth desync, privacy policy |
| H | 30+ | Dead ends, silent failures, pagination caps, auto-play once, a11y |
| M | 40+ | Token drift, duplicated components, stale caches, copy mismatches |
| L | 20+ | Dead styles, emoji icons, fake refresh |

---
## Cross-cutting
| ID | Issue | Evidence | Sev | Fix |
|---|---|---|---|---|
| X-01 | Urbanist fonts not bundled: 256 `fontFamily` refs fall back to Roboto. Half the screens use `fontWeight` + system font instead (Home, Profile, Favorites, WatchHistory, progression, tab bar, Login, Signup, Splash) | `assets/fonts` empty; `react-native.config.js` | C | R-01 |
| X-02 | Refresh failure clears MMKV tokens but not `useAuthStore`, so the UI stays "logged in" and every call 401s | `network/instance.ts:84` | C | R-14 |
| X-03 | No offline detection (NetInfo unused), no `onlineManager`, no ErrorBoundary | `providers/AppProvider.tsx` | H | R-05 |
| X-04 | No toast/snackbar feedback: `react-native-toast-message` unused; one `Alert.alert` app-wide. Most mutation errors are silent | grep | H | R-04 |
| X-05 | Accessibility: 11 `accessibilityLabel` total (10 in player, 1 tab bar). No roles on touchables, no `maxFontSizeMultiplier`, fixed-height cards clip at large font scale | grep | H | R-03, R-40 ✅ Step 22 |
| X-06 | Text 7–10px common (Favorites 7px badge, Profile 9px, poster 9–10px) | see screens | H | R-02 ✅ Step 22 |
| X-07 | Hit targets <44dp: avatar pen 20, fav heart 22, sort chips ~22, back 36–38, "See All" ~20, "Mark all" ~16 | see screens | H | R-03 ✅ Step 22 |
| X-08 | Token drift: 290 hex literals, 103 rgba, 28 font sizes, 35 radii; two reds `#F23645` (×14) vs `ACCENT_RED #FF3142`; purple/blue/light tokens unused | `theme/colors.ts` | M | R-02 |
| X-09 | Duplication: 8 custom back headers, `BackIcon` ×4, wordmark ×5, primary button ×11, auth input ×8, empty states ×6, 49 inline SVG icons | grep | M | R-03 |
| X-10 | `Header` ignores `title`/`subtitle`/`rightActions`: SeeAll and Notifications show no title | `components/Header.tsx:107-147` | H | R-03 |
| X-11 | Brand spelled 4 ways: MANHWAFLIX / MANHUA FLIX / ManhuaFlix / Manhwaflix | ForceUpdate:21, Splash, Profile, `strings.xml` | M | R-02 |
| X-12 | Stale caches: Episode like/fav don't update `['manhua',id]`; ChannelDetail invalidates `['channels','sections']`, not `['channels','subscribed']` | Episode:195-217, ChannelDetail:334,356 | M | R-31 ✅ Step 19 |
| X-13 | Background refetch toggles the pull-to-refresh spinner (OR of all `isFetching`) | Home:302, Detail, Search:344 | M | R-06 |
| X-14 | Dev strings shown to users: "Check your API base URL", "AdMob rewarded unit is not configured", "Publish titles from the admin panel", "Loading ad / This slot will update automatically", raw axios/Google errors | Detail:858, Episode:612, Home:81, AdBanner:102, Login:163, Forgot:96 | M | R-41 ✅ Step 22 |
| X-15 | No deep links (no `linking`, no VIEW intent); share sends plain text slug | `navigation/index.tsx:132`, Detail:747 | H | R-50 |
| X-16 | No skeleton consistency: Home shimmer, Detail static, everything else spinners | — | M | R-03 |
| X-17 | Single smoke test that likely fails (no native mocks) | `__tests__/App.test.tsx` | M | R-60 |
| X-18 | Every Play update forces a blocking screen (no flexible path) | `services/app-update.ts:80` | L | R-52 ✅ Step 21 |
| X-19 | Progression milestone shows late: only fires when `['my-profile']` refetches; inline `onComplete` restarts the animation | `ProgressionMilestoneHost.tsx:63` | M | R-35 |
| X-20 | Video app copy says "reading" (About, WatchHistory empty, Detail "Continue Reading") | About:49, WatchHistory:119, Detail:1086 | L | R-41 ✅ Step 22 |
---
## 1. Splash
- States: n/a.
- Issues:
  - S-01 (M) Red `#CC1111` ≠ brand red; 18 hex literals; module-level `Dimensions` → R-02. ✅ fixed Step 21 (JS splash removed)
  - S-02 (L) `react-native-bootsplash` installed but not wired, so the white→JS splash flashes → R-51. ✅ fixed Step 21

## 2. ForceUpdate
- Status: F-01/F-02 fixed Step 16 (2026-11-11).
- States: no loading on "Update now"; errors swallowed (34).
- Issues:
  - F-01 (M) No pending state or error retry → R-52.
  - F-02 (L) "MANHWAFLIX" wordmark is different from the app header (X-11).

## 3. Login
- States:
  - Loading: button spinner ✅.
  - Error: inline ✅, but raw Google messages.
  - Offline: generic.
- Issues:
  - L-01 (H) "Remember me" checkbox does nothing (88, 246) → R-30.
  - L-02 (M) Google spinner `DARK_BG` on dark button is invisible (292).
  - L-03 (M) No `returnKeyType`/`onSubmitEditing`/`autoComplete`/`textContentType`, so no autofill or next-field flow; ScrollView lacks `keyboardShouldPersistTaps`.
  - L-04 (M) "Google sign-in cancelled." shown as an error; `DEVELOPER_ERROR` long dev message.
  - L-05 (L) No `fontFamily`; dead styles.

## 4. SignUp
- Issues:
  - SU-01 (H) Terms/Privacy text not tappable (426); Google signup bypasses the terms check (210) → R-30.
  - SU-02 (M) Password hint "letters, numbers and symbols" ≠ schema (min 8 only).
  - SU-03 (M) 5 fields on one screen; username + full name both required. Username could be auto-suggested.
  - SU-04 (L) Commented-out 3-step stepper; duplicated `navigateAfterAuth` with Login.

## 5. ForgotPassword
- Issues:
  - FP-01 (M) Raw axios error "Request failed with status code 400" (96).
  - FP-02 (M) Own header/back icon; uses `fontFamily` while Login/Signup don't.
  - FP-03 (L) No zod; "Open email app" shortcut missing.

## 6. Home
- Layout: Header → Featured carousel → Continue Watching (auth) → Recently Added → New Updates → "Recommended for You".
- States:
  - Loading: shimmer ✅ (Continue Watching has none, so the layout shifts).
  - Empty: only Featured (admin copy).
  - Error: ❌.
  - Offline: ❌.
- Issues:
  - H-01 (H) Continue Watching opens Detail, not the episode: an extra tap to resume (378) → R-21.
  - H-02 (H) A failed query looks identical to empty; no retry → R-05.
  - H-03 (M) "Recommended for You" = Recently Added sorted A–Z (292), so the label misleads → R-22.
  - H-04 (M) See All passes loaded items; no pagination → R-16.
  - H-05 (M) Carousel keeps auto-advancing while the user drags; 7px dots; no Play CTA → R-22.
  - H-06 (M) Rails = ScrollView+map, inline arrows defeat memo; skeleton loops never stop → R-42.
  - H-07 (L) "Ch. N" vs "CH. N" casing; Header fetches 50 notifications just to count unread.
  - H-08 (L) No way to remove a title from Continue Watching.

## 7. Detail
- Layout: absolute top bar → cover → hero (title img, title, genres, views, count, desc) → engagement row → ad → tabs Details/Episodes → channel card → recs → comments.
- States:
  - Loading: static skeleton.
  - Error: full screen with dev copy.
  - Episodes: spinner/empty.
  - Recs: none.
- Issues:
  - D-01 (H) No primary Play/Continue CTA in hero; Episodes tab is second → R-23.
  - D-02 (H) Sort "Newest ↓" has no `onPress` (1162) → R-15. ✅ fixed Step 7
  - D-03 (H) Episodes = nested ScrollView rendering all chapters (1173); slow for 400+ chapters, no watched markers, no jump-to → R-23.
  - D-04 (M) Guests see "Login to favorite" text instead of the icon; like count tap → login with no explanation → R-15. ✅ fixed Step 7
  - D-05 (M) Episode rows show series views; mixed "Episode N"/"Chapter N"/"Continue Reading"; description shown twice; "Slug" and hardcoded "Type: Manhua" in metadata.
  - D-06 (M) View recorded on every focus (276) inflates counts → backend/mobile R-31. ✅ fixed Step 19 (once per session)
  - D-07 (M) Like/subscribe errors roll back silently → R-04.
  - D-08 (L) ~480 lines dead styles; 7 icons redefined; 38px icon buttons; 10px description.

## 8. Episode (player)
- Layout: top bar (scrolls away) → player → ad → meta card → Up Next → action tiles → rewarded card → synopsis → comments.
- States:
  - Player loading ✅.
  - Error: ❌.
  - Fav/like: no pending, no error.
- Issues:
  - E-01 (C) WebView fallback: `showChrome={false}` (751) + transparent blocker (`dailymotion-player-card.tsx:596`) means no controls; errors only render when chrome is on (765) → R-12.
  - E-02 (H) Auto-play next works once: `navigateToNextChapter` clears next params (431); next title hardcoded "Chapter N" (424); Up Next needs a successful progress sync, so guests never get it (337) → R-20.
  - E-03 (H) No previous episode, no episode drawer; switching requires going back → R-20.
  - E-04 (H) Fullscreen mounts a second native player, so the video reloads on enter and exit; no visible close (804, 456) → R-12.
  - E-05 (M) Seek bar 10px tall, tap-only; speed/captions/quality pills cycle blindly with raw "default"/"off" → R-12.
  - E-06 (M) "More ▾" not pressable; synopsis falls back to filler text "compact mobile layout…" (523) → R-41.
  - E-07 (M) Guests see "Watch Rewarded Ad" which then redirects to login; dev string on unconfigured ad → R-15. ✅ fixed Step 6
  - E-08 (M) "Part 01" and "Episode 1" both shown; auto-play pref not persisted (`useState(true)` 176). ✅ fixed Steps 6/22
  - E-09 (M) Inline `onProgressChange` re-runs the player effect on every render (725) → R-42.
  - E-10 (L) Back = 36px "‹" glyph; mockup leftovers in the player (fake 72% bar 1136, marketing copy 769); purple `rgba(114,76,255)` off-brand.

## 9. Comments section (Detail + Episode)
- Status: CM-01..06 fixed in Step 15 (2026-11-11, [[Mobile-Comments]]); report/flag not built.
- Issues:
  - CM-01 (H) Only page 1/20 fetched; header shows "Comments (312)" → R-16.
  - CM-02 (M) Top/Newest sorts client-side within 20.
  - CM-03 (M) Like/dislike not optimistic, refetches the list, ~20px targets, arrow icons → R-31. ✅ fixed Step 15/19
  - CM-04 (M) No delete own comment (backend supports it), no report, no edit → R-33.
  - CM-05 (M) Non-virtualized `FlatList scrollEnabled=false` inside ScrollView.
  - CM-06 (L) Author RPG modal level bar hardcoded 42% (980); ad every 5 comments is heavy.

## 10. SeeAll
- Status: SA-01..03 fixed Step 16 (paged, real refresh, sort chips removed — natural order per collection).
- Issues:
  - SA-01 (H) No title (X-10); fake pull-to-refresh 300ms (118); no pagination → R-16.
  - SA-02 (M) "Latest" sorts by parsed chapter number (35), not recency.
  - SA-03 (M) No empty state; sort chips ~22px, 10px text.

## 11. WatchHistory
- Best state coverage (gate, spinner, error+retry, empty).
- Issues:
  - WH-01 (H) Opening an episode passes no next-chapter info, so Next/auto-play are dead from history (58) → R-20.
  - WH-02 (M) Text "Back" button, no icon; progress as text, no bar; 100 cap.
  - WH-03 (M) No delete/clear, no date grouping, no link to series → R-34.
  - WH-04 (L) "Start reading chapters" copy.

## 12. Channels (tab)
- Issues:
  - CH-01 (H) Queries not gated by auth, so guests 401 → see "No subscriptions yet"; no login prompt → R-15. ✅ fixed Step 12
  - CH-02 (H) Recommended card button "Preview" has no action; no Subscribe on this screen (380) → R-15. ✅ fixed Step 12
  - CH-03 (M) Recommended has no loading state (flashes "Nothing new"); no error states → R-05.
  - CH-04 (M) Hero takes ~40% of the viewport for low-value stats; decorative purple glow off-brand.
  - CH-05 (M) Pin/unpin: no feedback; no reordering; 12-item cap.

## 13. ChannelDetail
- Best mutation engineering (optimistic + rollback).
- Issues:
  - CD-01 (H) Guests get **no** Subscribe button (441), so the conversion path is lost → R-15. ✅ fixed Step 12
  - CD-02 (M) Unsubscribe has no confirm; custom toggle lacks switch role.
  - CD-03 (M) Fallback parses "1.2K" → 12, so a wrong count flashes; no error state.
  - CD-04 (M) "New First" just reverses the array (190); "Following: Yes/No" stat is redundant.
  - CD-05 (L) Back 38px; sort chips ~22px.

## 14. Favorites (tab)
- Issues:
  - FV-01 (H) Hard cap 24 items, shows `meta.total` (192) → R-16.
  - FV-02 (H) Remove = 22px ♥ glyph only in hidden edit mode; no confirm/undo → R-34.
  - FV-03 (M) Two sort controls toggle the same dropdown; ⚙ gear for sort; dropdown not dismissible by outside tap.
  - FV-04 (M) Login without `redirectTo`, so the user doesn't return to Favorites.
  - FV-05 (M) Card shows "CH. {total}" and "Chapter {n}" (total chapters as if current).
  - FV-06 (L) 7px badge, 9–10px text, no `fontFamily`, ~50 lines dead styles.

## 15. Search (tab)
- Issues:
  - SR-01 (C) No results page: submit only saves history (370); only 6 suggestions ever → R-13.
  - SR-02 (H) Guest "Sign in to save searches" has no button (581) → R-15. ✅ fixed Step 11
  - SR-03 (H) Dropdown absolutely positioned `top: 120` (729), so it overlaps chips; no maxHeight, goes under the keyboard.
  - SR-04 (M) Suggestions query fires while not typing; genre results capped 20; no status/sort filters → R-13.
  - SR-05 (M) Clear All history has no confirm; selecting a recent re-saves it (count inflation); `capitalize` alters input.
  - SR-06 (M) `initialGenres` merges and never resets; recs error = blank section.
  - SR-07 (L) Grid `width: '30%'` misaligns; purple fixed palette for See All.

## 16. Notifications
- Issues:
  - N-01 (H) Loading spinner and "No notifications" empty state render together (352/384); no error state → R-05.
  - N-02 (H) No auth guard; guests reach it from the bell → R-15. ✅ fixed Step 13
  - N-03 (M) Mark-all awaits the backend before marking local; on failure nothing is marked (318).
  - N-04 (M) Tap awaits mark-read before navigating (laggy); failed deep link navigates to itself.
  - N-05 (M) Engagement events mapped as `new_chapter` icon; no grouping, filters, delete; 50 cap.
  - N-06 (L) "Mark all as read" ~16px target; wordmark scaled 0.72 hack.

## 17. Profile (tab)
- Mixes profile, stats, history, settings and legal in one 1780-line screen.
- Issues:
  - P-01 (C) No account deletion anywhere (Play policy) → R-10.
  - P-02 (H) Guest locked rows are Pressables without `onPress`; even About/Privacy are "locked" (240) → R-15. ✅ fixed Step 10
  - P-03 (H) Guest "Continue with Google" only navigates to Login (874) → R-15. ✅ fixed Step 17
  - P-04 (H) Logout: no confirm, query cache not cleared → R-14.
  - P-05 (H) Avatar upload deletes the old image **before Save**, so Cancel leaves a broken avatar (501); no resize; raw "Avatar URL" field exposed → R-32.
  - P-06 (M) Watch History rows not tappable, no "See all" link (712).
  - P-07 (M) Toggles: no optimism, all disabled while one pends, silent errors; push-off kills release alerts but push-on doesn't restore them (559).
  - P-08 (M) Hardcoded `v1.0.0` (242) vs 1.0.4.
  - P-09 (M) Placeholder 0s / "Lv 1 / F" before load look like real data; profile fetched twice on mount.
  - P-10 (M) Three guest sign-up CTAs; "Why Login?" 5 items with 9px labels.
  - P-11 (L) ~120 lines dead styles; 🎁 emoji; no `fontFamily`; RefreshControl no tint.

## 18. ChangePassword
- Issues:
  - CP-01 (M) Rules not shown upfront, errors one-at-a-time post-submit; no show/hide; no autofill hints → R-30.
  - CP-02 (M) Success = inline text, user stays on screen; fake refresh; no auth guard; Google-only users can't use it.
  - CP-03 (L) Text "Back".

## 19. About / PrivacyPolicy
- Status: AB-01/AB-02 fixed Step 16; PP-01 mitigated (factual in-app fallback), hosted policy still pending Q-03.
- Issues:
  - AB-01 (M) "Reading platform" copy; "Support via in-app channels" doesn't exist (71) → R-11.
  - PP-01 (C) Generic hardcoded policy: no date, controller or contact; omits AdMob, FCM, Cloudinary, Dailymotion, Google Sign-In; "request removal" with no mechanism → R-11.
  - AB-02 (L) Fake pull-to-refresh on static content.

## Tab bar
- Issues:
  - TB-01 (M) Order Channels · Favorites · **Home (center)** · Search · Profile; Home expected left → R-24.
  - TB-02 (M) Active state = color only (no filled icon/indicator); hardcoded colors.
  - TB-03 (M) Ad banner above tabs on every tab (HOME placement), next to tab targets (mis-tap risk, AdMob policy concern) → R-24.
  - TB-04 (L) Re-tap active tab does nothing (no scroll-to-top).

## Progression components
- Issues:
  - PG-01 (M) Rank default label differs: "Rookie" / "Novice" / "Reader".
  - PG-02 (M) RPG stat bars relative to the max stat, so the top stat is always 100%; emoji icons vary by OEM.
  - PG-03 (M) Milestone overlays ignore safe area, can't be dismissed, no a11y announce, no reduced-motion; reward and level-up overlap.
  - PG-04 (L) No "Max level" state.
