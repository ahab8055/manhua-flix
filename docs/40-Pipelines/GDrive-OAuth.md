---
type: pipeline
area: pipelines
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [pipeline, drive, oauth]
related: ["[[Pipelines-MOC]]"]
---
# GDrive OAuth (refresh token)

`kaggle/gdrive_oauth.py` — run locally once.
- Env: `GDRIVE_CLIENT_ID`, `GDRIVE_CLIENT_SECRET` (GCP OAuth client type **Desktop**, Drive API enabled).
- `InstalledAppFlow.from_client_config`, scope `https://www.googleapis.com/auth/drive` (full — so worker sees UI-created folders), `run_local_server(port=0, prompt="consent")`.
- Prints `GDRIVE_REFRESH_TOKEN=…` → store in backend env (injected into workers) / Kaggle secrets. Never commit.
