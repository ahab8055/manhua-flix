---
type: moc
area: pipelines
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [moc, pipeline]
related: ["[[Home]]", "[[Upload-Jobs]]"]
---
# Pipelines MOC

Video flow: **YouTube → Google Drive (private) → Dailymotion → chapter**. Backend `colab-jobs` module = queue + orchestrator; workers run as Kaggle kernels.

```
admin /upload-jobs ──POST /colab-jobs──▶ backend (youtube_to_drive job)
   backend pushes kaggle-worker-drive.ipynb ─▶ Kaggle: yt-dlp → ffmpeg split → Drive
   worker /complete ─▶ backend auto-creates drive_to_dailymotion child job (waits for admin Start)
   backend pushes kaggle-worker-dailymotion.ipynb ─▶ Kaggle: Drive → Dailymotion API
   resultUrls ─▶ admin pastes into chapter Dailymotion URL ─▶ mobile plays
```

- [[Upload-Jobs]] — backend module, routes, job lifecycle, Kaggle push
- [[YouTube-to-Drive]] — drive worker
- [[Drive-to-Dailymotion]] — dailymotion worker
- [[GDrive-OAuth]] — one-time refresh token script
- [[Colab-Notebooks]] — legacy manual notebooks (`colab/`)

**Source of truth for deployed workers:** `apps/backend/src/colab-jobs/kaggle-worker-{drive,dailymotion}.ipynb`. Root `kaggle/*.ipynb` copies are **older** — edit backend copies.
