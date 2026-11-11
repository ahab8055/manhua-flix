---
type: module
area: backend
status: active
created: 2026-11-08
updated: 2026-11-11
tags: [backend, api]
related: ["[[Backend-MOC]]", "[[Admin-API-Client]]", "[[Mobile-API]]"]
---
# Backend API

All under `/api`. Guards: **Pub** none · **Auth** `AuthGuard` · **R(x)** `AuthGuard+RolesGuard+@Roles(x)` · **Secret** `x-colab-secret` header = `COLAB_JOB_SECRET`. Most user features allow `user,admin` only — **uploader can't** use favorites/comments/progress.

## auth `src/auth/`
`POST /auth/signup-admin` (body `adminSecret`) · `POST /auth/register` · `POST /auth/login` · `POST /auth/google {idToken}` · `POST /auth/refresh` · `POST /auth/forgot-password` · `GET /auth/reset-password?token=` (HTML form) · `POST /auth/reset-password/confirm` — all Pub. `POST /auth/logout` (no-op), `GET /auth/me` — Auth. See [[Backend-Auth]].

## users `src/users/`
`GET /users/admin`, `GET /users/admin/list`, `PATCH /users/:id/moderation` (activate/restrict/suspend; not admins/self), `DELETE /users/:id` — R(admin). `GET/PATCH /users/me/profile` (PATCH: `fullName?`, `username?`, `avatarUrl?|null`; taken username → 400 incl. unique-index race), `PATCH /users/me/password`, `DELETE /users/me` (needs password; role user only) — R(user,admin). `GET /users/:id/profile` — Pub.

## manhuas `src/manhuas/`
Pub: `GET /manhuas`, `/featured`, `/search` (`q`, `genres` csv AND, `status`, `sort` relevance|newest|popular|title, `page`, `limit`≤50; LIKE wildcards escaped; status-only browse ok — [[Mobile-Search]]), `/suggestions`, `/recommendations`; `GET /manhuas/:id` optional auth. Auth: `GET /:id/like-status`, `POST /:id/like`, `POST /:id/view` (dedup 48h via `manhua_views`). R(admin,uploader): `POST /manhuas`, `GET /manhuas/admin`, `PATCH/DELETE /manhuas/:id`.
- Manhua requires `channelId`; uploader only for channels they own (`ChannelsService.isUserChannelOwner`).
- Publish (create/update) → `channel_upload_notifications` rows + `notifyManhuaRelease` ([[Notifications]]).
- Search: `to_tsvector('simple')` + ILIKE, pg_trgm GIN (migrations 0012, 0014), genre filter.

## chapters `manhuas/:manhuaId/chapters`
`GET /` Pub (published only). R(admin): `GET /admin`, `GET /admin/list`, `POST /`, `PATCH/DELETE /:chapterId`. `src/chapters/dailymotion.ts` parses `dai.ly/<id>`, `/video/<id>`, `/embed/video/<id>` → embed `…/embed/video/<id>?sharing-enable=false`; `@IsDailymotionVideoUrl`. Publish → `notifyChapterRelease`.

## channels `src/channels/`
Pub: `GET /channels`, `/channels/:id`, `/channels/:id/manhuas` (`page`, `limit`, `sort` newest|updated|title — updated = latest published episode). Public reads and upload counts exclude unpublished drafts (2026-11-09). R(admin): `POST`, `PATCH /:id`, `POST /:id/owners`, `DELETE /:id/owners/:userId`. R(admin,uploader): `GET /:id/owners`. R(user,admin): `GET /subscribed`, `/recommended`, `/sections`, `POST/DELETE /:id/subscribe` (POST idempotent: repeat returns current state, no 409; push to uploader only on first subscribe), `GET/PATCH /:id/notification-settings`, `PATCH/DELETE /:id/pin`. Owner assign fills `uploaderUserId` if empty.

## comments
`GET /manhuas/:id/comments` (`ListCommentsDto`: page/limit + `sort=top|newest`, default top = ranking score) and `…/:commentId/replies` (oldest first) are Pub with **optional auth**: a valid Bearer token fills `myReaction`, else `null`. Items carry `author {id, username, fullName, rank, rankLabel, level, avatarUrl}`. R(user,admin): `POST` (optional `parentCommentId`), `PATCH`, `DELETE` (owner or admin; hard delete cascades replies + reactions), `POST …/like`, `…/dislike` — repeating your current reaction **removes** it (returns `myReaction: null`). `GET /comments/admin` R(admin). New comment → `notifyManhuaEngagement`. One shared select in `comments.service.ts` `buildCommentQuery`; rank labels in `users/rank-label.ts` (shared with users.service). Step 15, branch `feat/comments-v2`.

## others
- favorites R(user,admin): `GET /favorites`, `GET/POST/DELETE /favorites/:manhuaId` (POST → engagement push)
- genres: `GET /genres` Pub; `GET /genres/admin`, `POST/PATCH/DELETE` R(admin). `manhuas.genres` is jsonb names, no FK.
- home-feed: `GET /home-feed/featured|recently-added|new-updates` Pub; `/continue-watching` R(user,admin) (hardcoded 90% cutoff)
- watch-progress R(user,admin): `GET /me`, `GET/DELETE /:manhuaId`, `POST /:manhuaId/chapters/:chapterId` → completion points ([[Points-Progression]])
- watch-history R(user,admin): `POST /watch-history`; `GET /me?page&limit` → `{data,meta}` (no `page` → legacy bare array `?limit&offset`, kept for old app builds); `DELETE /me` clear all (204); `DELETE /:entryId` own entry (204/404). Items include chapter `dailymotion*` fields ([[My-List]])
- search-history R(user,admin): `POST`, `GET /me`, `DELETE /:id`, `DELETE /me`
- rewarded ads / ad engagement → [[Rewarded-Ads]]
- analytics R(admin): `GET /analytics/overview`, `/analytics/notifications/{overview,failed,activity}`
- notifications → [[Notifications]]
- progression-config R(admin): `GET/PUT /admin/progression-config`
- cloudinary R(admin,user,uploader): `POST /cloudinary/upload {image, folder?, oldUrl?}`, `POST /cloudinary/delete {url}`
- account deletion: `POST /account-deletion-requests/me` Auth (body `{confirmation:"DELETE", reason?}`, disables account, [[Account-Deletion]]); `POST /legal/delete-account/requests` Pub; R(admin) `GET /admin/account-deletion-requests`, `POST …/:id/approve` (hard delete, match by email+username), `PATCH …/:id/reject`
- colab-jobs → [[Upload-Jobs]]
