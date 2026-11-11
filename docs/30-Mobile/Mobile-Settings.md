---
type: feature
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [feature, mobile, settings, redesign]
related: ["[[Account-Deletion]]", "[[Mobile-Navigation]]", "[[Push-Notifications]]", "[[Mobile-Auth]]"]
---
# Mobile Settings (redesign Step 8)

## What it does
- `src/screens/app/settings/SettingsScreen.tsx` (stack route `Settings`; Profile header gear + menu row). Sections:
  - **Notifications** — signed in: push master, new episode alerts (device topic, `release-notifications.ts`), channel uploads, channel activity, likes & replies. Optimistic `setQueryData` on `queryKeys.notificationPreferences()`, rollback + `toast.error`. Master off → children disabled + release alerts off. Guest: release alerts + "More alerts" → AuthPromptSheet.
  - **Channel alerts** — per subscribed channel (key `[...channelsSubscribed(), 'notification-settings']`, optimistic).
  - **Playback** — Autoplay next (`src/utils/playback-prefs.ts`, MMKV `autoplay_next`, shared with Episode).
  - **Account** (signed in) — Change password, Log out (ConfirmSheet), Delete account → `DeleteAccount`.
  - **About & legal** — Privacy (env URL via `Linking`, else in-app `PrivacyPolicy`), Terms + Contact support (hidden when env empty), About, Version from `DeviceInfo`.
- `DeleteAccountScreen.tsx`: explain → type DELETE (+ optional reason) → done. On success `signOut({reason:'deleted'})` (skips `/auth/logout`, account already disabled). Done/back → `navigation.reset` to Tabs. Swipe-back disabled on route.
- Login/Signup show `pendingDeletionMessage()` when backend returns `ACCOUNT_PENDING_DELETION` (`src/utils/api-error.ts`).

## Config
- Env: `PRIVACY_POLICY_URL`, `TERMS_URL`, `SUPPORT_EMAIL` (`src/types/env.d.ts`, read in `src/config/legal.ts`). Placeholders (empty) until Q-03 answered — fill before release.
- `.env.example` is matched by `.gitignore` `.env*` → additions there are local only.

## Profile changes
- Removed from `ProfileScreen.tsx`: notification card, guest alert switch, Log Out button, Change password/About/Privacy menu rows, hardcoded `v1.0.0`. Rest untouched until Step 10.
