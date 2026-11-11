---
type: feature
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-11
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
- **About** (Step 16, `AboutAppScreen.tsx`): Wordmark, one-line video copy, version, feature list, rows Rate on Google Play (`openPlayStore`), Privacy, Terms/Contact when env set.
- **Privacy** (Step 16, `PrivacyPolicyScreen.tsx`): in-app fallback only while `PRIVACY_POLICY_URL` empty. Factual draft (`LAST_UPDATED` const): collected data, Google Sign-In / FCM / AdMob / Cloudinary + "a third-party video hosting provider" (never named, D-30), deletion via in-app request ≤7 days, contact, Delete my account button (signed in). Update `SECTIONS` when data collection changes. Not legal advice; hosted policy (Q-03) is the real one.
- Removed from `ProfileScreen.tsx`: notification card, guest alert switch, Log Out button, Change password/About/Privacy menu rows, hardcoded `v1.0.0`. Rest untouched until Step 10.

## Legal links live (2026-11-11, Q-03)
- `PRIVACY_POLICY_URL` = https://manhuaflix.hbhammaddyar.com/p/privacy-policy.html, `TERMS_URL` = https://manhuaflix.hbhammaddyar.com/p/terms-and-conditions.html, `SUPPORT_EMAIL` set (env files are git-ignored; set per machine/CI).
- Effect: Settings + About open the hosted pages; Terms row + Contact support appear; LegalConsent links Terms; Delete account shows the mailto. In-app `PrivacyPolicyScreen` only when the URL is empty.
- Hosted policy gaps vs the app (owner to fix on the site): brand spelled "ManhuaFlix" (app = Manhwaflix, D-16); no 7-day deletion window (D-22 says to state it); Cloudinary (profile photos) not named; support email not on the page. Host correctly unnamed (D-30).
