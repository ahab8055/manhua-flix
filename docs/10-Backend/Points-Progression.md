---
type: module
area: backend
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [backend, points]
related: ["[[Backend-MOC]]", "[[Rewarded-Ads]]"]
---
# Points & Progression

- Services only: `src/points/points.service.ts`, `progression-events.service.ts`. Config row `progression_config` edited in admin `/progression` (`GET/PUT /admin/progression-config`); env vars are fallbacks ([[Backend-Bootstrap]]).
- **Chapter completion**: `POST /watch-progress/:manhuaId/chapters/:chapterId` with client `progressPercentage ≥ completion_threshold_percent` (90) → `awardChapterCompletion` (unique per user+chapter in `chapter_completions`).
- **Rewarded ad**: → [[Rewarded-Ads]].
- Level: base threshold 100 + growth 25/level. Rank thresholds string `F…SSS`. RPG stats (hp/mp/atk/def/luck) grow by configured min/max rolls and points divisors.
- Audit: `progression_events`, `rank_progression_history`. `onLevelUp` emitted, no subscribers.
- Client-trusted: completion % comes from client.
