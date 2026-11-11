---
type: module
area: backend
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [backend, ads]
related: ["[[Backend-MOC]]", "[[Points-Progression]]", "[[Mobile-Ads]]"]
---
# Rewarded Ads & Ad Analytics

`src/rewarded-ads/`, `src/ad-engagement/`.

| Route | Guard |
|---|---|
| `POST /ads/claim`, `GET /ads/history` | R(user,admin) |
| `GET /admin/ads/rewards` | R(admin) |
| `GET /ads/ssv-callback` | Pub (Google; `@ApiExcludeController`) |
| `POST /ads/tracking/banner-impression`, `/ads/tracking/interaction` | R(user,admin) |
| `GET /admin/ad-analytics/overview`, `/events`, `/daily` | R(admin) |

- `claim`: if `require_ad_ssv` → 0 points, wait for SSV; else award now.
- `awardRewardedAd` transaction: unique `externalRewardId`, daily limit (server-local midnight = UTC on Vercel), insert `ad_rewards` + `ad_events`, `syncUserProgress`.
- SSV (`admob-ssv.service.ts`): ECDSA sha256 verify with keys from `gstatic.com/admob/reward/verifier-keys.json` (24h cache); parses `user_id`, `custom_data` JSON (externalRewardId, placementId, manhuaId), `transaction_id`; fallback id `admob_ssv:<transactionId>`; always 200.
- All tracking → `ad_events`.
