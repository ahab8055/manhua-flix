---
type: note
area: mobile
status: draft
created: 2026-11-08
updated: 2026-11-08
tags: [mobile, redesign, dashboard]
related: ["[[Mobile-Redesign-MOC]]", "[[Redesign-Roadmap]]", "[[Redesign-Decision-Log]]"]
---
# 00 - Dashboard: Mobile App Redesign

> [!warning] Approval gate
> Phase = **Blueprint (proposed)**. No application code may change until the user says exactly:
> **"I approve the redesign. Start implementation"**. See [[ADR-003-redesign-artifact-first]].

## Goal
Turn Manhwaflix (Android, RN 0.83, animated manhua/manhwa recap videos) into a polished, consistent, accessible product. Fix dead ends and broken flows first, then visuals.

## Status
| Phase | Scope | Status |
|---|---|---|
| Discovery | Read all 19 screens, 30+ components, infra | ✅ done 2026-11-08 |
| Blueprint | 12 notes in this folder | ✅ proposed 2026-11-08 |
| Design prototype | Clickable canvas (https://claude.ai/artifact/Jw9ugkXM5PPhUDDWcc28JR) | 🔄 in review 2026-11-08 |
| Approval | User sign-off on prototype + blueprint | ⏳ waiting |
| P0 Foundation | Fonts, tokens, core components, error/offline/toast infra | 🔄 Step 1 (R-01, R-02) + Step 2 (R-03 UI kit) + Step 3 (R-04..R-06 toast/offline/error boundary/refresh) implemented 2026-11-08 + Step 4 (R-14 session, R-31 cache core, R-15 auth-sheet infra) 2026-11-08 — **P0 foundation complete** |
| P1 Critical flows | Account deletion, player fallback, search results, auth desync, dead ends | ⬜ proposed |
| P2 Screen redesigns | Home, Detail, Episode, My List, Search, Channels, Profile/Settings, Auth | 🔄 Step 5 nav shell (R-24), Step 6 Episode player (R-12, R-20), Step 7 Home + Detail (R-21–R-23) implemented 2026-11-08 |
| P3 Polish | Motion, deep links, a11y pass, perf, tests | ⬜ proposed |

Status legend for every task: `proposed → approved → implemented → tested`. Tracked in [[Redesign-Roadmap]].

## Top 10 priorities
| # | Issue | Sev | Fix task |
|---|---|---|---|
| 1 | No account deletion, and the privacy policy omits third-party SDKs (Play policy) | C | R-10, R-11 |
| 2 | WebView-fallback player can't be tapped and shows no error | C | R-12 |
| 3 | Search has no results page; submit does nothing | C | R-13 |
| 4 | Urbanist fonts not bundled, so all text renders in Roboto | C | R-01 |
| 5 | Token refresh failure leaves the UI "logged in" | C | R-14 |
| 6 | 7 dead-end buttons and sections (guest menu, Preview, Subscribe hidden, sort…) | H | R-15 |
| 7 | No error, offline or toast feedback; silent mutation failures | H | R-04, R-05 |
| 8 | Pagination caps (Favorites 24, Notifications 50, Comments 20…) | H | R-16 |
| 9 | Auto-play next works only once; resume needs 2+ taps | H | R-20, R-21 |
| 10 | Accessibility: 11 labels app-wide, 20–38px targets, 7–10px text | H | R-03, R-40 |

## Numbers (2026-11-08 scan)
- 19 screens, ~19.6k LOC in `apps/mobile/src`.
- 290 hex literals, 103 `rgba(`, 28 font sizes, 35 radius values.
- 8 hand-rolled back headers, 11 button copies, 49 inline SVG icons, ~650 lines of dead styles.
- 11 `accessibilityLabel`s (10 in the player).
- 1 smoke test.

## Notes
[[Redesign-App-Overview]] · [[Redesign-UI-UX-Audit]] · [[Redesign-Product-Gaps]] · [[Redesign-Strategy]] · [[Redesign-Design-System]] · [[Redesign-User-Flows]] · [[Redesign-Visual-References]] · [[Redesign-Roadmap]] · [[Redesign-QA-Strategy]] · [[Redesign-Decision-Log]] · [[Redesign-Final-Summary]]

## Open questions (blocking implementation)
See [[Redesign-Decision-Log#Open questions]]. Key ones: backend delete-account endpoint, privacy policy host URL, deep link domain, final tab structure.
