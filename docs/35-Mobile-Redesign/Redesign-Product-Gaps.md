---
type: note
area: mobile
status: draft
created: 2026-11-08
updated: 2026-11-08
tags: [mobile, redesign, product]
related: ["[[Mobile-Redesign-MOC]]", "[[Redesign-UI-UX-Audit]]", "[[Redesign-Roadmap]]"]
---
# Product Gap Analysis

Scoring:
- **Value**: user/business impact, 1–5.
- **Effort**: S ≤1d, M 2–4d, L 5d+.
- **Backend**: ✅ endpoint exists, 🟡 small change, ❌ new work.

## Must-have (policy / broken core loop)
| Gap | Why | Value | Effort | Backend | Task |
|---|---|---|---|---|---|
| In-app account deletion request | Play User Data policy requires in-app + web deletion path | 5 | M | 🟡 reuse `account-deletion-requests` module + new signed-in endpoint (D-19, D-22) | R-10 |
| Accurate privacy policy (hosted URL) | Data-safety form must match SDKs used (AdMob, FCM, Cloudinary, Dailymotion, Google Sign-In) | 5 | S | 🟡 host page | R-11 |
| Full search results page | Core discovery; submit does nothing today | 5 | M | ✅ suggestions + genre endpoints; 🟡 paginated text search | R-13 |
| Working player fallback + error UI | Some videos can't be controlled at all | 5 | M | — | R-12 |
| Reliable binge loop (auto-play chain, prev/next, episode drawer) | Primary engagement metric for a recap app | 5 | M | ✅ chapters list | R-20 |
| One-tap resume | Continue Watching → Detail → Episode is 2 taps | 4 | S | ✅ | R-21 |
| Pagination / infinite scroll | Users can't see favorites >24, comments >20, notifications >50 | 4 | M | ✅/🟡 verify `page` params | R-16 |
| Error + offline states, toasts | Silent failures look like empty content | 4 | M | — | R-04, R-05 |

## Should-have (retention, trust)
| Gap | Value | Effort | Backend | Task |
|---|---|---|---|---|
| Settings screen (split from Profile) | 4 | M | ✅ | R-25 |
| My List hub (Favorites + Continue + History) | 4 | M | ✅ | R-24, R-34 |
| Remove from Continue Watching / clear history | 3 | S | ✅ `DELETE /watch-progress/:id` | R-34 |
| Watched / in-progress markers on episode list | 4 | S | ✅ watch-progress | R-23 |
| Episode sort + jump to episode / range chips | 4 | S | — | R-23 |
| Deep links + rich share (`https://…/m/:slug`) | 4 | M | 🟡 web landing + assetlinks.json | R-50 |
| Delete own comment, report comment | 3 | S | ✅ delete; ❌ report | R-33 |
| Persisted auto-play preference | 3 | S | — | R-20 |
| Inline auth sheet for guests (replaces dead ends) | 4 | S | — | R-15 |
| Flexible (non-blocking) Play update | 3 | S | — | R-52 |
| Native splash (bootsplash) | 2 | S | — | R-51 |

## Could-have (later; validate with data first)
- Real personalised recommendations (needs backend signals) → rename "Recommended" to "Popular" until then.
- Notification categories, grouping and swipe-to-delete.
- Channel pin reordering (drag).
- Double-tap seek, PiP on Android, landscape auto-rotate.
- Search filters: status, year, sort.
- Onboarding: 2-step genre picker on first launch to seed the Home feed (only once personalised recs exist).

## Explicitly rejected / deferred (avoid scope creep)
| Idea | Reason |
|---|---|
| Offline video download | Dailymotion SDK/ToS restrictions; large effort |
| Light theme | Dark-only fits the cinematic content; doubles QA. Revisit later |
| iOS work | [[ADR-001-android-only-store-driven]] |
| Backend-managed app config/version table | [[ADR-001-android-only-store-driven]] |
| Social feed / follow users | Out of product scope; comments suffice |
| Rating system | Low signal at current scale; likes exist |
| Redesigned RPG system mechanics | Keep mechanics; only fix presentation (PG-01..04) |
| Multi-step signup wizard | Adds steps; reduce fields instead |
