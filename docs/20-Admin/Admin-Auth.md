---
type: module
area: admin
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [admin, auth]
related: ["[[Admin-MOC]]", "[[Backend-Auth]]"]
---
# Admin Auth

- Login `src/app/login/page.tsx` → `POST /auth/login`; client throws unless role `admin|uploader` → `AuthProvider.login()` → `saveSession` → `router.push("/")`.
- Cookies (`src/lib/auth.ts`, js-cookie, 7d, `secure` in prod, `sameSite Lax`, **not httpOnly**): `mf_admin_access_token`, `mf_admin_refresh_token`, `mf_admin_user` (JSON `AuthUser`).
- `AuthProvider` (`src/providers/auth-provider.tsx`) → `useAuth()` `{user, token, isLoading, login, logout, refresh}`; refresh actually done by axios interceptor ([[Admin-API-Client]]).
- Middleware `src/middleware.ts`: public `/login`, `/delete-account`; missing token cookie → `/login` (presence check only). Logged-in on `/login` → `/manhuas` (uploader) or `/`.
- **Uploader allowlist**: `/manhuas`, `/manhuas/*`, `/channels` (exact). Else → `/manhuas`.
- Nav gating: `roles` per item in `admin-shell.tsx`.
- Logout: client-only clear cookies; no server revoke, Query cache kept.
- Real authz = backend guards ([[Backend-Auth]]).
