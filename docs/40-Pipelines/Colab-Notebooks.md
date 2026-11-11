---
type: pipeline
area: pipelines
status: deprecated
created: 2026-11-08
updated: 2026-11-08
tags: [pipeline, colab, legacy]
related: ["[[Pipelines-MOC]]"]
---
# Colab Notebooks (legacy)

Superseded by Kaggle workers ([[Upload-Jobs]]). Manual Google Colab.

- `colab/YT_Downloader.ipynb` — YouTube → mounted Drive; quality 4K…360p / MP3; cookie merge cell (youtube + google JSON → Netscape `combined_cookies.txt`). No backend.
- `colab/YouTube_to_Dailymotion_V1_0_3.ipynb` — 5 manual steps: install, download, Dailymotion login (legacy password grant), ffmpeg split 1h55m, upload folder (legacy `/file/upload` → `/me/videos`). No backend.
- `colab/YouTube_to_Dailymotion_Merged.ipynb` — first backend-wired version (`legacy` kind): `JOB_SOURCE api|form`, polls `GET /colab-jobs/pending`, creds from Drive `dailymotion_credentials.json`, `/complete {urls}` or `/fail`.

Cookie exports gitignored (`cookies.txt`, `combined_cookies.txt`, `youtube_cookies.txt`).
