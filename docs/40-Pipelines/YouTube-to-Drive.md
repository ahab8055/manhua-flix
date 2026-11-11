---
type: pipeline
area: pipelines
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [pipeline, youtube, drive]
related: ["[[Pipelines-MOC]]", "[[Upload-Jobs]]"]
---
# YouTube → Drive worker

Deployed: `apps/backend/src/colab-jobs/kaggle-worker-drive.ipynb` (older copy `kaggle/youtube_to_gdrive.ipynb`). `JOB_KIND = "youtube_to_drive"`.

## Secrets (names)
`API_BASE`, `COLAB_JOB_SECRET` (alias `JOB_SECRET`), `GDRIVE_CLIENT_ID`, `GDRIVE_CLIENT_SECRET`, `GDRIVE_REFRESH_TOKEN`, opt `GDRIVE_PARENT_FOLDER`, `YOUTUBE_COOKIES`/`COOKIES_TXT`.

## Steps
1. Install `yt-dlp[default]`, tqdm, google-api-python-client, **Deno** (yt-dlp JS challenges, `remote_components: ["ejs:github"]`).
2. Loop `claim_job`; fetch admin cookies `/colab-jobs/cookies` each job. Cookie order: admin → job path → secret → `/kaggle/input/youtube-cookies/*` → any cookies file in `/kaggle/input`.
3. Drive v3 via refresh token; parent folder: job → secret → hardcoded fallback id.
4. Playlist expand (`extract_flat`).
5. yt-dlp, H.264 preferred; client fallbacks `default,-android_sdkless` → `tv,mweb,web` → progressive; merge failure → retry pre-merged.
6. `ensure_named_folder` (title) → `ffmpeg -ss/-t -c copy` parts → ≤4GB check → resumable upload 8MB chunks `"<title> - Part N.mp4"` → delete local.
7. Checkpoint each part `POST /progress {urls, nextStartPart, resumeAtSeconds, driveFiles[], driveFolder*}`.
8. Done → `/complete`; error/pause → `/fail {errorMessage, paused, …checkpoint}`.

Drive folder private; no sharing.
