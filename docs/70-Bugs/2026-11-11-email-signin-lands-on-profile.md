---
type: bug
area: mobile
status: fixed
created: 2026-11-11
updated: 2026-11-11
tags: [bug, mobile, auth, navigation]
related: ["[[Mobile-Auth]]", "[[Bugs-MOC]]"]
---
# Email sign-in from the sign-in sheet lands on Profile

## Symptom
- Guest on Episode (or Detail, Comments…) taps Like → sign-in sheet → **Use email** → signs in → app jumps to the **Profile tab**; the screen they were on and its stack are gone. The like replays in the background, so it looks like nothing happened.

## Root cause
- `useRequireAuth` never passes `redirectTo`, so `AuthPromptHost.onUseEmail` opens `Login` with no params.
- `useAuthCompletion` (`hooks/use-auth-completion.ts`) treated "no `redirectTo`" as "reset to Profile" — written for Profile's own Sign in button, before the sheet existed.

## Fix (Step 17)
- No `redirectTo` → remove `Login`/`SignUp`/`ForgotPassword` from the current stack (`CommonActions.reset` with filtered routes). Nothing left → Profile. Explicit `redirectTo` (push deep-link guard) unchanged.

## Links
- [[Mobile-Auth#Guest gating without dead ends]]
