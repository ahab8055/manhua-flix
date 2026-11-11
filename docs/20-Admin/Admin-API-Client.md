---
type: module
area: admin
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [admin, api]
related: ["[[Admin-MOC]]", "[[Backend-API]]"]
---
# Admin API Client

`src/lib/api.ts`: `axios.create({ baseURL: NEXT_PUBLIC_API_URL ?? "http://localhost:3001/api" })`.
- Request: `Authorization: Bearer <mf_admin_access_token>`.
- Response 401 (not login/refresh, not retried): bare `axios.post(/auth/refresh, {refreshToken})` → `saveSession` → retry; failure → `clearSession()` + `location = /login`.
- `throwApiError` / `messageFromApiBody` flatten Nest `message: string|string[]` — only used in `api.ts`.
- Pagination: `src/lib/list-query.ts` — `PaginatedList<T> {data, meta{page,limit,total,totalPages}}`, `toQueryParams()` drops empty/`"all"`, `paginateLocally()`.

Types live beside API fns in `src/lib/*-api.ts` (no shared types pkg).

## Endpoints per feature
| Feature | File | Endpoints |
|---|---|---|
| Auth | `api.ts` | `POST /auth/login`, `POST /auth/refresh` |
| Dashboard | `api.ts` | `GET /analytics/overview` |
| Notifications | `api.ts` | `GET /analytics/notifications/{overview,failed,activity}`, `POST/GET /notifications/broadcasts`, `GET /notifications/broadcasts/:id`, `POST /notifications/resend/{manhua/:id,chapter/:id}`, `POST /notifications/process-pending` |
| Ad analytics | `ad-analytics-api.ts` | `GET /admin/ad-analytics/overview?from&to`, `GET /admin/ad-analytics/daily?days` |
| Deletion (admin) | `admin-account-deletion-requests-api.ts` | `GET /admin/account-deletion-requests`, `POST …/:id/approve`, `PATCH …/:id/reject` |
| Deletion (public) | `account-deletion-requests-api.ts` | `POST /legal/delete-account/requests` (uses `fetch`, no auth) |
| Channels | `channels-api.ts` | `GET/POST /channels`, `GET/PATCH /channels/:id`, `GET/POST /channels/:id/owners`, `DELETE /channels/:id/owners/:userId` |
| Cloudinary | `cloudinary-api.ts` | `POST /cloudinary/upload {image(base64), folder, oldUrl}`, `POST /cloudinary/delete {url}` |
| Upload jobs | `colab-jobs-api.ts` | `POST/GET /colab-jobs`, `GET/DELETE /colab-jobs/:id`, `POST /colab-jobs/:id/run`, `POST /colab-jobs/:id/drive-folder`, `GET /colab-jobs/:id/logs?kaggle=1`, `GET /colab-jobs/cookies/status`, `POST /colab-jobs/cookies` |
| Comments | `comments-api.ts` | `GET /comments/admin`, `DELETE /manhuas/:manhuaId/comments/:commentId` |
| Genres | `genres-api.ts` | `GET /genres`, `GET /genres/admin`, `POST/PATCH/DELETE /genres(/:id)` |
| Manhuas/chapters | `manhuas-api.ts` | `GET /manhuas`, `GET /manhuas/admin`, `GET/PATCH/DELETE /manhuas/:id`, `POST /manhuas`, `GET /manhuas/:id/chapters/admin(/list)`, `POST /manhuas/:id/chapters`, `PATCH/DELETE /manhuas/:id/chapters/:chapterId` |
| Progression | `progression-api.ts` | `GET/PUT /admin/progression-config` |
| Users | `users-api.ts` | `GET /users/admin(/list)`, `GET /users/:id/profile`, `PATCH /users/:id/moderation`, `DELETE /users/:id` |

Helpers: `lib/dailymotion.ts` (extract id, embed URL), `lib/delete-account-content.ts` (policy copy).
