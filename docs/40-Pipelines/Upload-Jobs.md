---
type: module
area: pipelines
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [pipeline, backend]
related: ["[[Pipelines-MOC]]", "[[Backend-MOC]]", "[[Admin-Routes]]"]
---
# Upload Jobs (colab-jobs)

Backend `apps/backend/src/colab-jobs/`: `colab-jobs.controller.ts`, `colab-jobs.service.ts`, `kaggle-kernels.service.ts`, `youtube-cookies.service.ts`, `cookie-merge.ts`, `colab-job-secret.guard.ts`, notebooks (copied to `dist` via `nest-cli.json` assets). Admin UI `/upload-jobs` ([[Admin-Routes]]).

## Routes
R(admin,uploader): `POST /colab-jobs` (queue `youtube_to_drive` + trigger Kaggle), `GET /colab-jobs` (+`related`, `inFlightCount`), `GET /colab-jobs/:id`, `GET /:id/logs?kaggle=`, `POST /:id/drive-folder` (trash Drive folder), `DELETE /:id`, `POST /:id/run` (`prepareRerun(startPartNumber?)`), `GET /cookies/status`, `POST /cookies` (merge into `youtube_cookies` id=1, ≤2MB).
Secret (`x-colab-secret`): `GET /pending?kind=` (claim, optimistic retry ×5), `GET /cookies`, `POST /:id/progress|status|log|complete|fail` (log tail cap 200k chars).

## Lifecycle
- Kinds `legacy | youtube_to_drive | drive_to_dailymotion`; statuses `pending | running | done | failed | paused`.
- Split ≤ 2h (Dailymotion standard limit); default 1h55m; quality forced 720p.
- Drive job complete needs folder + ≥1 part → auto child `drive_to_dailymotion` (`parentJobId`). Dailymotion complete needs `resultUrls`.
- Pause/fail carries checkpoint → resumable, skips done parts.
- Dailymotion caps: 15 videos / 10h per 24h (admin batch preview).

## Kaggle trigger `KaggleKernelsService.triggerWorker`
1. Replace `__INJECTED_SECRETS_B64__` in notebook with base64 JSON (COLAB_JOB_SECRET, GDRIVE_*, DAILYMOTION_*, API_BASE).
2. `POST https://www.kaggle.com/api/v1/kernels/push` (private, internet, no GPU), Basic or Bearer (`KGAT_` tokens).
3. Find kernel by title; 409 → update. Drive worker attaches `KAGGLE_COOKIE_DATASET`.
- Slugs: `KAGGLE_KERNEL_SLUG_DRIVE` (default `youtube-to-google-drive`), `KAGGLE_KERNEL_SLUG_DAILYMOTION` (default `google-drive-to-dailymotion`).
- Worker secret lookup: env → Kaggle `UserSecretsClient` → injected payload.
- Backend copies add log shipping (redacted, 15s flush), live status, 720p preference, 20GB source cap, disk check, batching.
