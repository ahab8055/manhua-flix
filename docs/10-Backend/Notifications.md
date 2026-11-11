---
type: module
area: backend
status: active
created: 2026-11-08
updated: 2026-11-11
tags: [backend, push, notifications]
related: ["[[Backend-MOC]]", "[[Push-Notifications]]"]
---
# Notifications (backend)

`src/notifications/notifications.service.ts` (~1.5k lines).

## Routes
R(admin): `POST/GET /notifications/broadcasts`, `GET /notifications/broadcasts/:id`, `POST /notifications/resend/manhua/:id`, `POST /notifications/resend/chapter/:id`, `POST /notifications/process-pending`.
R(user,admin): `GET /notifications/history`, `GET /notifications/unread-count` → `{count}`, `PATCH /notifications/:id/read`, `DELETE /notifications/:id` (own row, 404 otherwise; Step 13), `PATCH /notifications/read-all`, `GET/PATCH /notifications/preferences`, `GET/POST/DELETE /notifications/devices` (`{token, platform, provider: fcm, appVersion}`).
Pub: `POST /notifications/devices/unregister` (by token).

## Firebase
Lazy `initializeApp(cert({projectId, clientEmail, privateKey}))` (`\n` unescaped), fallback default creds + health warning.

## Release pushes
`notifyManhuaRelease` / `notifyChapterRelease` → FCM **topic `new_releases`**, data-only, Android high priority, TTL 24h, `collapseKey manhua_<id>`. Payload: title, body, bigText (≤180), imageUrl, channel/manhua fields; chapter adds Dailymotion URLs + `screen: "Episode"`. `notifyChannelUpload` deprecated → calls `notifyManhuaRelease`.

## Per-user pushes
Event types: channel_subscription, engagement_comment/reply/favorite, admin_broadcast. Enqueue `push_notification_deliveries` → `getMessaging().send` per active token; data adds `eventType` + `notificationId` (delivery id) so the app skips its local inbox copy. Retry exp backoff 60s→1h, max 3. Token deactivated on permanent error or 10 failures. Preferences checked per event type.

## Scheduler
`setInterval` 60s `processDuePendingDeliveries(100)` — doesn't run reliably on Vercel; admin can hit process-pending.
