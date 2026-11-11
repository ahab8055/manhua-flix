---
type: moc
area: backend
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [moc, backend]
related: ["[[Home]]", "[[Admin-MOC]]", "[[Mobile-MOC]]"]
---
# Backend MOC

`apps/backend` — NestJS 10 + Fastify 4 + Drizzle 0.31 (postgres-js), CommonJS, strict TS. Submodule `ahab8055/manhua-flix-backend`. All routes under `/api`, Swagger `/api/docs`. Runs as server (`PORT ?? 3001`) or Vercel serverless handler.

- [[Backend-Bootstrap]] — main.ts, modules list, env var names, scripts
- [[Backend-API]] — every route + guard, per module
- [[Data-Model]] — Drizzle tables, migrations
- [[Backend-Auth]] — JWT, guards, roles, Google, password reset
- [[Notifications]] — FCM topics, delivery queue, retries
- [[Points-Progression]] — points, levels, ranks, RPG stats, config
- [[Rewarded-Ads]] — claim, AdMob SSV, ad events/analytics
- [[Upload-Jobs]] — colab-jobs module: YouTube → Drive → Dailymotion on Kaggle
- [[Backend-Integrations]] — Firebase, Cloudinary, Mailjet, Dailymotion, Kaggle, Drive
- [[Account-Deletion]] — in-app deletion request, disable-now, admin approve/reject
- [[Backend-Gotchas]] — known issues found on scan
