---
type: note
area: backend
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [backend, integrations]
related: ["[[Backend-MOC]]"]
---
# Backend Integrations

| Service | Where | Use |
|---|---|---|
| Firebase Admin / FCM | `src/notifications/` | pushes → [[Notifications]] |
| Cloudinary | `src/cloudinary/` | `uploader.upload(base64, {folder default "manhuas", resource_type auto})` → `{url, publicId}`; delete parses public_id after `/upload/<version>/` |
| Mailjet | `AuthService.requestPasswordReset` | password reset email only |
| Google OAuth | `src/auth/` | ID token verify ([[Backend-Auth]]) |
| AdMob SSV | `src/rewarded-ads/admob-ssv.service.ts` | [[Rewarded-Ads]] |
| Dailymotion | `src/chapters/dailymotion.ts` | store URL/id/embed only; upload done by Kaggle worker ([[Upload-Jobs]]) |
| Kaggle API | `src/colab-jobs/kaggle-kernels.service.ts` | push/list kernels, fetch output |
| Google Drive v3 | `colab-jobs.service.ts` | list/trash files, OAuth refresh token |
