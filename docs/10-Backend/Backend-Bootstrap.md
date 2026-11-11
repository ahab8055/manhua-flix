---
type: module
area: backend
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [backend, config]
related: ["[[Backend-MOC]]"]
---
# Backend Bootstrap & Config

## `src/main.ts`
- `FastifyAdapter({logger: true, bodyLimit: 50MB})` (base64 image uploads).
- Prefix `api`; CORS `origin = FRONTEND_URL ?? "*"`, credentials.
- Swagger `/api/docs` (assets from cdnjs swagger-ui 5.17.14 for serverless), bearer auth.
- `VERCEL !== "1"` → listen `0.0.0.0:${PORT ?? 3001}`; else export `handler(req,res)` with cached app.
- No global `ValidationPipe` — per-handler `@UsePipes(new ValidationPipe({whitelist, forbidNonWhitelisted}))`. No helmet / rate limit.
- `GET /api/health` → `{status, timestamp}`.

## Modules (`src/app.module.ts`)
Db (global, `DRIZZLE_TOKEN`, `src/db/db.provider.ts`), Auth, Users, Manhuas, Chapters, Channels, Comments, Favorites, Genres, HomeFeed, WatchProgress, WatchHistory, SearchHistory, RewardedAds, AdEngagement, Analytics, Notifications, Cloudinary, ProgressionConfig, AccountDeletionRequests, ColabJobs. `PointsModule` imported by features. Config global from `.env`.

## Env var names
- Core: `DATABASE_URL`, `PORT`, `FRONTEND_URL`, `NODE_ENV`, `VERCEL`, `ADMIN_CREATION_SECRET`
- JWT: `JWT_ACCESS_SECRET`, `JWT_REFRESH_SECRET`, `JWT_PASSWORD_RESET_SECRET`, `JWT_ACCESS_EXPIRES_IN` (default 15m)
- Google: `GOOGLE_CLIENT_ID` (comma-separated audiences)
- Cloudinary: `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`
- Mailjet: `MAILJET_API_KEY`, `MAILJET_API_SECRET`, `MAILJET_FROM_EMAIL` (aliases `MJ_APIKEY_PUBLIC/PRIVATE`)
- Firebase: `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY`
- Points fallbacks: `RANK_THRESHOLDS`, `POINTS_CHAPTER_COMPLETION`, `POINTS_REWARDED_AD`, `REWARDED_AD_DAILY_LIMIT`, `CHAPTER_COMPLETION_REWARD_THRESHOLD_PERCENT`, `POINTS_LEVEL_BASE_THRESHOLD`, `POINTS_LEVEL_GROWTH_PER_LEVEL`
- Pipeline: `COLAB_JOB_SECRET`, `KAGGLE_USERNAME`, `KAGGLE_KEY`/`KAGGLE_API_TOKEN`, `KAGGLE_COOKIE_DATASET`, `KAGGLE_KERNEL_SLUG_DRIVE`, `KAGGLE_KERNEL_SLUG`, `KAGGLE_KERNEL_SLUG_DAILYMOTION`, `GDRIVE_CLIENT_ID`, `GDRIVE_CLIENT_SECRET`, `GDRIVE_REFRESH_TOKEN`, `GDRIVE_PARENT_FOLDER`, `DAILYMOTION_CLIENT_ID`, `DAILYMOTION_CLIENT_SECRET`, `DAILYMOTION_PROFILE_ID`, `API_PUBLIC_URL`, `COLAB_API_BASE`, `VERCEL_PROJECT_PRODUCTION_URL`, `VERCEL_URL`

Many not in `.env.example` — keep it in sync when adding vars.

## Scripts
`dev` (nest --watch), `build`, `start:prod`, `lint`, `type-check`, `db:generate`, `db:push`, `db:migrate`. No tests.

## Scheduled work
No cron. `NotificationsService.onModuleInit` `setInterval` 60s → `processDuePendingDeliveries(100)` (unreliable on Vercel).
