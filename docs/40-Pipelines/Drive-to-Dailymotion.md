---
type: pipeline
area: pipelines
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [pipeline, dailymotion, drive]
related: ["[[Pipelines-MOC]]", "[[Upload-Jobs]]", "[[Video-Playback]]"]
---
# Drive → Dailymotion worker

Deployed: `apps/backend/src/colab-jobs/kaggle-worker-dailymotion.ipynb` (older `kaggle/gdrive_to_dailymotion.ipynb`). `JOB_KIND = "drive_to_dailymotion"`.

## Secrets (names)
`API_BASE`, `COLAB_JOB_SECRET`, `GDRIVE_CLIENT_ID/SECRET/REFRESH_TOKEN`, `DAILYMOTION_CLIENT_ID`, `DAILYMOTION_CLIENT_SECRET`, opt `DAILYMOTION_PROFILE_ID`.

## Auth
`POST https://oauth2.dailymotion.com/v2/token` `grant_type=client_credentials`, scope `video.manage account.read` — needs **Private API key** (Dailymotion Studio → Organization → API keys). Password grant no longer works. Profile from `GET /v2/me` `profiles`.

## Per part (sorted by `partNumber`, skip already in `resultUrls`)
1. `SessionQuota` (job uploads last 24h; 15 videos / 10h).
2. Drive `get_media` 8MB chunks → `/kaggle/working/gdrive-dm`.
3. `POST https://api.dailymotion.com/v2/files/upload_sessions` → upload URL → multipart upload.
4. `POST /v2/profiles/{profile_id}/videos {title "<base> - Part N", category job.dailymotionChannel||news, visibility public, is_for_kids false, tags, source.file_url}`.
5. Record `{title, videoId, url, driveFileId, uploadedAt}` → `/progress`.

Limit/quota text or 401/403 after successes → pause; first upload rejected → fail. Never deletes Drive files (admin trashes via `/drive-folder`).
