---
type: note
area: mobile
status: draft
created: 2026-11-08
updated: 2026-11-08
tags: [mobile, redesign, strategy]
related: ["[[Mobile-Redesign-MOC]]", "[[Redesign-Design-System]]", "[[Redesign-Visual-References]]", "[[Redesign-User-Flows]]"]
---
# Redesign Strategy

## Principles
1. **Watch first.** Every screen should be at most 1 tap from playing the next relevant episode.
2. **No dead ends.** Every disabled or locked thing explains why and offers the way forward (auth sheet, retry, settings).
3. **Always give feedback.** Every action gets visible feedback within 100ms (pressed state, optimistic update) plus a result (toast or inline). Errors are never silent.
4. **One system.** All UI comes from tokens and shared components in [[Redesign-Design-System]]. No raw hex or font sizes in screens.
5. **Accessible by default.** 48dp targets, 12px minimum text, labels and roles, font scaling up to 1.5× without clipping, reduced-motion respected.
6. **Fast on low-end Android.** Virtualized lists, sized images, memoized rows.

## Visual direction: "Cinematic Dark"
- Near-black canvas (`#050507`) with elevated surfaces. One brand red ([[ADR-002-red-brand-primary]]). Purple, blue and ad-hoc reds are removed.
- Covers and title art carry the colour. UI chrome stays neutral (grey scale), and red is reserved for primary actions, progress and the active state.
- Typography: Urbanist (bundled) on a 6-step scale. Bold display titles, Medium body text.
- Cards: 12 radius, 1px hairline border `rgba(255,255,255,0.06)`, no heavy shadows. Gradient scrims over imagery to keep text readable.
- Matches the existing Play Store screenshots' look, so store assets stay valid.

## Information architecture
### Tabs (proposed)
| Pos | Tab | Contents | Change |
|---|---|---|---|
| 1 | **Home** (initial) | Hero, Continue, rails | moved from center |
| 2 | **Search** | Search bar, genres, results | full results page |
| 3 | **My List** | Segments: Continue · Favorites · History | merges Favorites tab + WatchHistory screen |
| 4 | **Channels** | Subscribed, discover | guest-aware |
| 5 | **Profile** | Identity, progression, shortcuts, ⚙ Settings | settings moved out |

- Active tab: filled icon, red label, and a 3px top indicator pill (not colour alone).
- Re-tapping the active tab scrolls to top.
- Remove the persistent ad banner above the tab bar (mis-tap risk next to nav). Ads stay on many screens, inline: see [[#Ad placement map]] (D-20).

### Stack screens
- Kept: Detail, Episode, SeeAll (renamed **Collection**, paginated), ChannelDetail, Notifications, auth screens, ForceUpdate.
- New:
  - **Settings**, with sub-pages Notifications, Account (change password, **delete account**), and Legal (Privacy, Terms, Licenses, About).
  - **SearchResults**: can be an in-tab state rather than a separate route.
- Removed:
  - **WatchHistory**: folds into My List → History.
  - **AboutApp** standalone: becomes Settings → About.

### Guest gating
- Replace hidden buttons, plain-text "Login to…" notices and no-op rows with an **AuthPromptSheet**: a bottom sheet titled "Sign in to {action}", with Google + Email buttons and "Not now".
- It keeps `redirectTo` and replays the action after login (e.g. auto-favorite).

## Screen specs
Wireframes are in [[Redesign-Visual-References]]. Issue IDs refer to [[Redesign-UI-UX-Audit]].

### Home
- **Hero carousel:** full-bleed 16:9 cover with a gradient scrim, title, genres, and **Play** + **My List +** buttons. Paging dots get a 24dp touch area. Autoplay pauses while the user drags and when screen reader is on.
- **Continue Watching (auth):**
  - Wide cards with a progress bar and "Ep N · 12 min left".
  - Tap → Episode directly (H-01).
  - Long-press or ⋯ → Remove (H-08).
- **Rails, in order:** New Episodes → Recently Added → Popular (renamed from "Recommended" until real recs exist, H-03).
- **Rail headers:** title + "See all ›" with a 48dp touch target.
- **Inline ad** between the 2nd and 3rd rails.
- **States:**
  - Per-rail skeleton.
  - Failed rail → compact inline error with Retry.
  - All failed / offline → full ErrorState + OfflineBanner.
  - Empty rails are hidden. The Featured empty state gets user copy.

### Detail
- **Hero:** cover with scrim, poster, title, meta line (genres · N episodes · status), and a primary **▶ Play Ep 1 / Continue Ep N** button. The secondary row is icon buttons with labels: My List, Like, Share, Comments.
- **Synopsis:** shown once, 3 lines with "More" (removes the duplicate Storyline).
- **Tabs (Episodes first):**
  - **Episodes:**
    - Virtualized `FlatList` as the screen's main list; the header holds the hero.
    - Sort toggle (Oldest/Newest), range chips (1–50, 51–100…) and "Jump to #".
    - Rows: thumbnail, "Ep N · title", duration, watched ✓ or progress bar.
  - **About:** metadata without slug or type, the creator channel card, recommendations.
- **Comments:** preview (top 3) + "View all N comments" → full-screen comments sheet, paginated.
- **Guests:** all actions are visible. Tapping one opens the AuthPromptSheet (D-04).
- **States:** shimmer skeleton matching the layout; ErrorState with user copy; Episodes empty: "Episodes coming soon".

### Episode (player)
- **Sticky player** at top: 16:9, does not scroll away. The back button overlays it (48dp, labelled).
- **One control system for both native and WebView:**
  - Native: custom controls.
  - WebView: render the Dailymotion player's own chrome (`showChrome` true for the fallback) and remove the blocker (E-01).
  - Both show an error overlay: "Video unavailable" + Retry + "Open in Dailymotion".
- **Seek bar:** draggable, 24dp tall touch area, time labels.
- **Settings:** speed, quality and captions go into one **⚙ bottom sheet** with labelled options (E-05).
- **Fullscreen:** rotates the same player instance (no remount, E-04). On-screen ✕ button plus hardware back.
- **Below the player:**
  - Title row: "Ep N · title", series link ›.
  - **Prev / Next buttons.**
  - Action chips: My List, Like, Share, Comments.
  - Up Next card with countdown. Persisted toggle in MMKV `autoplay_next`. Works for guests: it uses the local chapters list, not the sync result (E-02).
  - **Episodes drawer:** bottom sheet with the full list, current one highlighted.
  - Rewarded card (auth only; guests see a sign-in hint).
  - Synopsis (expandable), comments preview.
- **Navigation:** next/prev computed from `['chapters',manhuaId]` (cached), so the chain never breaks, including from History (WH-01).

### My List (new tab)
- Segmented control: **Continue · Favorites · History**.
- **Continue:** list with progress bars, swipe or ⋯ to remove.
- **Favorites:** infinite grid (FV-01); long-press or ⋯ → Remove with an **Undo** toast (FV-02). One sort menu: Recently added / A–Z / Recently updated.
- **History:** grouped Today / Yesterday / Earlier, infinite scroll, ⋯ → remove, and "Clear all" with confirm.
- **Guests:** one EmptyState: "Sign in to save your list" + Google/Email.

### Search
- Sticky search field (labelled; ✕ clear 48dp). Genre chips scroll horizontally beneath it.
- **Typing:** a suggestions list replaces the content (in-flow, not `top:120` absolute), plus a first row "Search for '{q}'".
- **Submit or suggestion "see all":** results grid, infinite. Filter chips: Genre, Status, Sort. Result count shown.
- **Idle:** Recent searches (auth; guests get a sign-in link) and Popular.
- **States:** no results ("No titles match '{q}'" + clear filters); error + retry; offline.
- Clear history asks for confirmation. Stop re-saving recents on tap. Keep the user's casing.

### Channels
- **Guest:** a short explainer + Discover list. Subscribe buttons open the AuthPromptSheet.
- **Auth:** compact header (remove the 40% hero). Subscribed list with pin (⋯ menu) and a "Pinned" section. **Discover** cards with a real **Subscribe** button (removes the fake "Preview", CH-02).
- **States:** skeletons and errors for each section.

### ChannelDetail
- Banner, avatar, name ✓, stats (Subscribers, Uploads).
- **Subscribe** is always visible (guest → auth sheet). Once subscribed: "Subscribed ✓" + a 🔔 alerts toggle as a proper switch.
- Unsubscribe asks for confirmation in a sheet.
- Uploads grid sorted by real date.
- Error state.

### Profile
- Identity card: avatar (edit 48dp), name, @handle, rank badge, level progress with "Max level" support.
- Progression: RPG stats as a collapsible "Stats" card. Bars use an absolute scale. Icons come from the icon set, not emoji.
- **Shortcuts:** My List, Notifications, Settings ⚙.
- **Guest:** a single welcome card (Sign in / Create account), benefits list (12px+). About/Privacy reachable via Settings, unlocked.
- **Edit profile sheet:** keyboard-aware. Name and username editable. Avatar pick → crop/resize → upload on **Save** only (P-05). "Remove photo" with confirm. Raw URL field removed.

### Settings (new)
- **Notifications:** push master switch → dependent toggles (disabled with an explanation when push is off). Release alerts. Per-channel alerts list. Optimistic switches with error toasts.
- **Account:** email (read only), Change password (hidden for Google-only accounts), **Delete account** (red, 3 steps: explainer → type DELETE → request received → signOut; account disabled until admin approves within 7 days; no cancel, D-22).
- **Playback:** auto-play next, default quality (if the SDK supports it).
- **About & legal:** version from `DeviceInfo`, Privacy (hosted URL in WebView/Custom Tab), Terms, Open-source licenses, Contact support (mailto), Rate app.
- **Log out:** confirm sheet; clears the query cache, auth store and push token.

### Auth (Login / SignUp / Forgot)
- **Shared AuthLayout:** wordmark, title, subtitle, form, and the Google button **first** (lowest-friction path), then the "or" divider and the email form.
- **TextField:** label, leading icon, error text, password eye, `autoComplete`/`textContentType`, `returnKeyType` chaining, keyboard-aware scroll.
- **Login:** remove "Remember me" (sessions persist anyway). "Forgot?" inline.
- **SignUp:** Name, Email, Password (live rules checklist). Username auto-derived and editable later (open question). Tappable Terms/Privacy. The same consent line applies to Google ("By continuing you agree…").
- **Forgot:** email → success state with "Open email app" and Resend, with a cooldown timer.
- **Errors:** mapped to friendly copy. Cancelling Google is silent.

### Notifications
- Auth-gated (guest → sign-in EmptyState).
- Header with title + "Mark all read" (48dp).
- Sections Today / Earlier. Category icons are correct (engagement ≠ new chapter).
- Tapping a row navigates immediately; marking read happens in the background. A failed deep link shows a toast.
- Loading skeleton XOR empty XOR error. Infinite scroll.

### Splash / ForceUpdate
- Native bootsplash (brand red "M" on `#050507`) hands off to a JS fade. No double splash.
- Update: flexible update for normal releases, immediate only when the Play priority is ≥4. Button shows a loading state, plus a retry on error.

## Micro-interactions (purposeful only)
| Interaction | Motion | Duration |
|---|---|---|
| Press on any touchable | scale 0.97 + opacity 0.9 | 100ms |
| Favorite / like | icon pop scale 1→1.2→1 + fill | 220ms |
| Tab switch | indicator slide | 220ms |
| Skeleton | shimmer (one shared driver) | 1200ms loop |
| Toast | slide up + fade | 220ms in / 160ms out |
| Up Next countdown | ring progress | 6s |
| Level-up | card scale-in + confetti (skipped on reduced motion) | ≤1.8s, tappable to dismiss |

All motion uses Reanimated and respects `AccessibilityInfo.isReduceMotionEnabled`.

## Feedback & error copy rules
- Speak to the user, never the dev: "Couldn't load episodes. Check your connection and try again."
- Toasts:
  - Success: 2s.
  - Error: 4s with Retry when possible.
  - Undo: 5s.
- Destructive actions use a ConfirmSheet with a red action that names the object: "Remove from My List?".
- Offline: a persistent top banner "You're offline. Showing saved content". Mutations are disabled with an explanation.

## Ad placement map
Rules: never within 48dp of nav controls, player controls or primary CTAs; always labelled "Ad"; same card shape as content (native ad) or adaptive banner; no ads on auth, settings, delete account, force update, splash; frequency caps below.

| Screen | Placement | Format | Cap / rule |
|---|---|---|---|
| Home | after 2nd rail; again after 4th rail | native card (rail-height) / adaptive banner | 2 per scroll |
| Detail | below synopsis, above tabs | adaptive banner (existing `detail_banner`) | 1 |
| Detail episode list | every 25 rows | slim native row | — |
| Episode | below Up Next card (not under player) | adaptive banner (existing `episode_banner`) | 1 |
| Episode | Bonus XP card | rewarded (existing) | user-initiated only |
| Episode → next episode | *(deferred, D-23)* interstitial on autoplay transition | interstitial | every 3rd transition, max 1 / 10 min, never mid-video |
| Search results | after row 2, then every 6 rows | native grid card | — |
| Search idle | below Popular | adaptive banner | 1 |
| My List (Favorites / History) | after 9 items, then every 12 | native card | — |
| Channels | between Subscribed and Discover | native card | 1 |
| Channel detail | above Uploads grid | adaptive banner | 1 |
| Notifications | after "Today" group | native row | 1 |
| Comments sheet | every 8 comments (was 5) | native row | — |
| Profile | bottom of shortcuts | adaptive banner | 1 |
| App open | *(deferred, D-23)* cold start after splash | app-open ad | max 1 / 4 h, never first launch |

Removed: banner above tab bar on every tab; "Loading ad" placeholder copy (slot collapses until loaded).
