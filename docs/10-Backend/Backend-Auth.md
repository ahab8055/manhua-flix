---
type: module
area: backend
status: active
created: 2026-11-08
updated: 2026-11-11
tags: [backend, auth]
related: ["[[Backend-MOC]]", "[[Admin-Auth]]", "[[Mobile-Auth]]"]
---
# Backend Auth

- **No Passport.** `src/auth/auth.guard.ts`: Bearer → verify `JWT_ACCESS_SECRET` → `AuthService.resolveAccessStatus(sub)` reloads user (rejects deleted/inactive/suspended) → overwrites `req.user.role` from DB (role changes immediate), sets `req.authUser`.
- `src/auth/roles.guard.ts`: `@Roles(...)` (`ROLES_KEY="roles"`), 403 on mismatch; **restricted** non-admins blocked on non-GET (read-only).
- Tokens: payload `{sub,email,username,role}`; access `JWT_ACCESS_EXPIRES_IN` (15m); refresh `JWT_REFRESH_SECRET`, **no expiry, not stored/rotated**.
- Passwords: bcryptjs cost 10, 8–72 chars.
- Register: `username` optional (Step 14, D-37). Omitted → `generateUniqueUsername(fullName, email)` (same as Google); sent (old app builds) → uniqueness check + 409.
- Roles: register + Google → `user`. `POST /auth/signup-admin` with `adminSecret` = `ADMIN_CREATION_SECRET`. **No API grants `uploader`** — set in DB.
- Google: `OAuth2Client.verifyIdToken` against `GOOGLE_CLIENT_ID` list; needs `email_verified`; existing email → log into that account (link by email); else create user with generated username + random password.
- Password reset: 1h JWT (`JWT_PASSWORD_RESET_SECRET`), link from request host `/api/auth/reset-password?token=`, Mailjet v3.1; non-prod logs link on Mailjet errors. Tokens not single-use.
- Same login/JWT for admin panel and mobile.
