---
type: module
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-11
tags: [mobile, auth]
related: ["[[Mobile-MOC]]", "[[Backend-Auth]]", "[[Mobile-UI-Kit]]"]
---
# Mobile Auth

- Email/password: `LoginScreen`, `SignupScreen`, react-hook-form + zod (`src/schemas/auth.ts`).

## Auth screens (redesign Step 14, 2026-11-11)
- Shell `screens/auth/AuthLayout.tsx` (Screen + AppHeader back, Wordmark, title/subtitle, keyboard-aware scroll, footer) + `OrDivider`, `FooterPrompt`. Used by Login, SignUp, ForgotPassword, ChangePassword.
- Google first (`components/auth/GoogleButton.tsx`, kit Button `leading` slot), then "or", then email form. Kit `TextField` with `autoComplete`/`textContentType`, next→done chaining via refs, `secure` eye.
- `hooks/use-auth-completion.ts`: `useAuthCompletion(redirectTo)` (store session; with `redirectTo` → reset to it on top of Home; **without → pop the auth screens and return to where sign-in started**, Profile only if nothing is underneath — Step 17, [[2026-11-11-email-signin-lands-on-profile]]), `useGoogleAuth`, `authErrorMessage` (pending deletion + friendly copy).
- `services/google-auth.ts`: `GoogleSignInCancelledError` (silent everywhere, incl. AuthPromptSheet), `GoogleSignInError` = user-safe copy. DEVELOPER_ERROR → "Google sign-in isn't available right now. Use email instead." (SHA-1 hint only `__DEV__` console).
- Consent: `components/auth/LegalConsent.tsx` ("By continuing you agree to the Terms and Privacy Policy", no checkbox) under Login, SignUp and AuthPromptSheet → covers Google sign-up. Terms plain text until `TERMS_URL` set; Privacy falls back to in-app page.
- SignUp: Name, Email, Password only (D-37); username made by the server. 409 → email field error + "Sign in instead". Live `PasswordRules` (`components/auth/PasswordRules.tsx`) from `SIGNUP_PASSWORD_RULES` (= backend min 8).
- Login: Remember me removed; "Forgot password?" passes typed email; 401 → "Wrong email or password."
- ForgotPassword: optional `email` route param prefill; success state with Open email app (`mailto:`; Android `<queries>` VIEW mailto in manifest), Resend with 60s cooldown, Back to sign in. Friendly errors only.
- ChangePassword: current + new (eyes) + live `CHANGE_PASSWORD_RULES` (= backend ChangePasswordDto); 401 → current-password field error (interceptor refreshes once, session kept); success toast + back; "Signed up with Google?" row → ForgotPassword with email (Google users have a random password).
- Tests `src/schemas/__tests__/auth.test.ts`.
- Google `src/services/google-auth.ts`: `GoogleSignin.configure({webClientId: GOOGLE_WEB_CLIENT_ID})` → `hasPlayServices` → `signOut()` (force picker) → `signIn()` → `idToken` → `POST /auth/google`.
- `mapAuthResponse` accepts tokens nested or top-level; `fullName` → `name`.
- `DEVELOPER_ERROR` = missing SHA-1 for `com.manhuamobile` in Firebase/GCP — Play builds need **Play App Signing SHA-1**.
- Tokens + user in MMKV ([[Mobile-State]]).

## Session lifecycle (redesign Step 4, 2026-11-08)
- **Only sign-out path:** `signOut({ reason: 'user' | 'expired' | 'deleted' })` (`deleted` skips `/auth/logout`, Step 8) in `src/services/session.ts`. Order: `POST /auth/logout` (user only, 5s best effort) → `unregisterPushToken()` (needs auth, so before clearing) → `signOutGoogle()` → `useAuthStore.logout()` → `queryClient.clear()` → expired toast. Single-flight.
- **Refresh failure rules** (`src/network/instance.ts`): tokens deleted + session expired **only** when refresh returns 400/401/403 or no refresh token stored. Network error / timeout / 5xx keep tokens (offline ≠ signed out). `setSessionExpiredHandler` registered by `session.ts` (imported for side effect in `src/navigation/index.tsx`).
- Log out lives in Settings → Account with a ConfirmSheet ([[Mobile-Settings]]). Pending-deletion login → `ACCOUNT_PENDING_DELETION` message.

## Guest gating without dead ends
- `useRequireAuth()` (`src/hooks/use-require-auth.ts`): `requireAuth(action, { reason, redirectTo? })` — signed in runs now; guest opens sheet and **replays `action` after any sign-in** (Google in sheet, or email via Login `redirectTo`).
- `AuthPromptHost` (`src/components/AuthPromptSheet.tsx`) mounted inside `NavigationContainer`; store `src/store/auth-prompt` (pending action TTL 10 min; "Not now" drops it).
- Step 17: `use-auth-guard.ts` deleted (no callers). AuthPromptSheet + Profile guest card share `useGoogleAuth`; Profile's "Continue with Google" signs in directly (one tap, P-03).
- `components/auth/RequireSignedIn.tsx`: `RequireSignedIn` / `SignedOutScreen` — account-only screens (ChangePassword, DeleteAccount except its final "Request received" step) show a sign-in state if the session ends while open.
- Replayed like/My List taps are safe since Step 19: actions carry the desired state and check the server first ([[Mobile-API]]).
