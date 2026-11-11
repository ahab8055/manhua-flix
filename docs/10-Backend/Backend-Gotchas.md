---
type: note
area: backend
status: active
created: 2026-11-08
updated: 2026-11-09
tags: [backend, gotcha, security]
related: ["[[Backend-MOC]]", "[[Bugs-MOC]]"]
---
# Backend Gotchas (scan 2026-11-08)

Not fixed unless noted.

## Security
- `ADMIN_CREATION_SECRET` unset → code falls back to a hardcoded default → anyone reading source can create admin. **Always set it in every env.**
- `/cloudinary/delete` + `oldUrl`: any logged-in user can delete any asset; no ValidationPipe on that controller.
- `POST /notifications/devices/unregister` public.
- Refresh tokens never expire, not revocable. Reset tokens not single-use.
- Login checks `isActive` but not suspended (guard rejects later).
- Points client-trusted (completion %, `externalRewardId` when SSV off).
- Kaggle worker creds injected base64 into private notebook source.
- No helmet / rate limit.

## Data / correctness
- `watch_history.progress_percentage` text vs numeric elsewhere; `chapter_id` no FK.
- `manhuas.genres` jsonb names, no FK to `genres`.
- continue-watching hardcodes 90% instead of config.
- Ad daily limit uses server-local midnight.
- Drizzle snapshots missing 0046–0048.
- Google-only users can't `DELETE /users/me` (random password) → mobile uses `POST /account-deletion-requests/me` instead ([[Account-Deletion]]).
- `pnpm exec eslint` crashes: "outdated version of the 'jiti' library" (eslint 9.39 + jiti 1.21.7). Lint unverified until jiti bumped (2026-11-08).
- Channel public routes used to include unpublished drafts (lists, counts, recent covers) — fixed 2026-11-09 on `feat/channels-cleanup`.
- **jsonb double-encoded on write** (drizzle 0.31 + postgres-js): `manhuas.genres` etc. stored as JSON strings → raw SQL jsonb ops miss them. Use `genresArray()` in manhuas.service; see [[2026-11-09-genre-filter-misses-double-encoded-jsonb]].
- Refresh tokens are stateless JWT, no revocation table; `logout` is a no-op. Disabling `is_active` is the only kill switch.
- No API to grant `uploader`.

## Ops
- Notification retry timer unreliable on Vercel.
- `AnalyticsService.getOverview` many sequential counts, no cache.
- Unused `@fastify/static`; stray `src/colab-jobs/__pycache__/*.pyc`; many env vars missing from `.env.example`.
