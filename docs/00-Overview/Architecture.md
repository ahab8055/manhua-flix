---
type: note
area: overview
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [overview, architecture]
related: ["[[Home]]", "[[Tech-Stack]]"]
---
# Architecture

```
 Mobile (RN, Android) ─┐                    ┌─ Postgres (Drizzle)
                       ├─ /api ─ Backend ───┼─ Firebase FCM (push, topic new_releases)
 Admin (Next.js) ──────┘   NestJS+Fastify   ├─ Cloudinary (images)
                           (Vercel/server)  ├─ Mailjet (password reset)
                                            ├─ AdMob SSV callback
                                            └─ Kaggle kernels ─ YouTube → Drive → Dailymotion
 Mobile plays chapters from Dailymotion (native SDK / embed)
```

- Single backend serves both clients; same JWT login, roles `user | uploader | admin` ([[Backend-Auth]]).
- Content model: Channel → Manhua → Chapter (Dailymotion video) ([[Data-Model]]).
- Engagement: favorites, likes, comments, watch progress/history, search history, subscriptions.
- Gamification: points → level → rank F…SSS + RPG stats ([[Points-Progression]]), rewarded ads ([[Rewarded-Ads]]).
- Push: release topic + per-user queued deliveries ([[Notifications]], [[Push-Notifications]]).
- Video ingest: [[Pipelines-MOC]].
- Force update via Play In-App Updates ([[In-App-Update]]).
