---
type: note
area: release
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [release, play-store]
related: ["[[Release-MOC]]", "[[Android-Build]]", "[[In-App-Update]]"]
---
# Play Store Release

Current: **1.0.4 (versionCode 5)**, Android. Package `com.manhuamobile`.

## Release notes `apps/mobile/release-notes/<version>.md`
Existing: `1.0.4.md`. Format:
- `# ManhuaFlix <version> (versionCode N) — Android` + date + previous version
- `## Play Store "What's new" (en-US)` fenced block to paste
- `## What changed` → `### Mobile app`, `### Backend (must ship before the app rollout)` (list migrations), `### Admin`
- `## Release checklist`, `## Known issues`

## Order / checklist
1. Backend `pnpm db:migrate` → deploy.
2. Deploy admin.
3. Keep "Require AdMob SSV" off until SSV callback URL set in AdMob ([[Rewarded-Ads]]).
4. Bump versionCode/Name, `bundleRelease`, upload AAB, staged rollout 20% → 100%.
5. Smoke test. Force update triggers automatically via [[In-App-Update]].

Public data-deletion URL: admin `/delete-account` ([[Admin-Routes]]).
