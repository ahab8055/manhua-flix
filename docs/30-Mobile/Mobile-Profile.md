---
type: feature
area: mobile
status: active
created: 2026-11-09
updated: 2026-11-11
tags: [feature, mobile, profile, progression, redesign]
related: ["[[My-List]]", "[[Mobile-Settings]]", "[[Points-Progression]]", "[[Mobile-UI-Kit]]"]
---
# Mobile Profile (redesign Step 10)

## What it does
- Tab `Profile` → `src/screens/app/profile/ProfileScreen.tsx` (old 1566-line file deleted). `Screen` + `AppHeader` title with gear → Settings.
- **Signed in:** `IdentityCard` (avatar/initials + edit, name, @handle, email, compact `RankBadge`, level bar from server `levelProgress`, "Max level" when `pointsToNextLevel === null`, totals Episodes / Series / My List, member since) → `StatsCard` → shortcuts (Continue watching / My List / Watch history → My List segments; Notifications with unread count; Settings).
- **Guest:** welcome card (Continue with Google → AuthPromptSheet, Sign in, Create account), benefits list, Settings row.
- Data: `useQuery(queryKeys.myProfile())` + refetch on focus; pull-to-refresh via `useRefreshControl` (spinner only on pull). `ProgressionMilestoneHost` still listens to that cache.

## Stats (Q-08 → D-34)
- `StatsCard.tsx`: collapsed by default; open state per device in MMKV `profile_stats_open`.
- Bars share one ceiling = next multiple of 100 above the highest stat (`statCeiling`), icons from the set: HP `heart`, MP `bolt`, ATK `sword`, DEF `shield`, LUCK `sparkle`. Backend stats are unbounded, so there is no true max.

## Edit profile (`EditProfileSheet.tsx`, fixes P-05)
- Name (backend `fullName`, new), Username (client regex = backend `^[a-zA-Z0-9_]{3,100}$`), photo Change / Remove / Keep.
- Picker resizes (`maxWidth/Height 512`, `quality 0.8`). **No crop** — no crop lib installed (native lib = rebuild).
- Save: upload (no `oldUrl`) → `PATCH /users/me/profile` (changed fields only, `avatarUrl: null` removes) → best-effort `POST /cloudinary/delete` of the replaced photo. PATCH failure deletes the fresh upload. Cancel never touches the server.
- "Username already in use" → field error. Updates `myProfile` cache + auth store `name/username`.

## Progression polish (R-35)
- `src/components/progression/`: `DEFAULT_RANK_LABEL = 'Novice'` + `RANK_ORDER` in `constants.ts`; `RankBadge` reads `tokens.color.rank`.
- `CelebrationOverlay.tsx` shared by level/rank/reward overlays: below status bar (safe-area inset), tap to dismiss, `announceForAccessibility`, fade-only with reduced motion. `onComplete` must be stable — Host uses `useCallback` (X-19), `use-rewarded-bonus.ts` `clearRewardOverlay` too.
- Removed `ProgressionWidgets.tsx` (local 100/25 level fallback) and `RpgStatsWidgets.tsx` (relative bars, emoji).

## Gotchas
- `POST /cloudinary/delete` has no ownership check (see [[Backend-Gotchas]]); Profile only deletes the user's own replaced photo, but the endpoint itself stays open.
- Comments now use the shared `RankBadge` too (Step 15, [[Mobile-Comments]]).
