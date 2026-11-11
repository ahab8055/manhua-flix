---
type: note
area: admin
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [admin, gotcha]
related: ["[[Admin-MOC]]", "[[Bugs-MOC]]"]
---
# Admin Gotchas (scan 2026-11-08)

Not yet fixed unless noted.
1. Uploader sees `/upload-jobs` in nav but middleware bounces them to `/manhuas`.
2. Concurrent 401s each start own refresh — races if backend rotates refresh tokens.
3. Refresh skips `saveSession` if `mf_admin_user` cookie missing, still retries.
4. Middleware checks cookie presence only; role from client-writable cookie.
5. Tokens in non-httpOnly cookies, 7d regardless of JWT TTL.
6. Logout doesn't clear Query cache or revoke server-side.
7. Only `api.ts` unwraps backend error `message`; other `*-api.ts` show generic axios text.
8. `/manhuas/new` + import don't invalidate `["manhuas"]`.
9. Channel dropdowns `listChannels({limit: 50})` — 51st channel missing.
10. Images upload/delete before form save → orphan Cloudinary assets.
11. Chapter stores single image `pageUrls[0]`.
12. CSV parser hand-rolled; breaks on quoted newlines; sequential, no abort.
13. `AuthProvider.refresh()` unused; `tsconfig.tsbuildinfo` committed; `next lint` deprecated.
