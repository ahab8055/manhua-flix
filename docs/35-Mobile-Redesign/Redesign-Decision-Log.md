---
type: note
area: mobile
status: draft
created: 2026-11-08
updated: 2026-11-11
tags: [mobile, redesign, decisions]
related: ["[[Mobile-Redesign-MOC]]", "[[Decisions-MOC]]", "[[ADR-002-red-brand-primary]]", "[[ADR-003-redesign-artifact-first]]"]
---
# Decision Log

Status values:
- `decided`: user confirmed.
- `proposed`: recommended, awaiting approval.
- `open`: needs input.

## Decisions
| # | Date | Decision | Status | By | Ref |
|---|---|---|---|---|---|
| D-01 | 2026-11-08 | Blueprint lives in `docs/35-Mobile-Redesign/` with dashed names (vault convention) | decided | user | [[Conventions]] |
| D-02 | 2026-11-08 | Brand primary = red. Purple `#5030E5`/blue dropped | decided | user | [[ADR-002-red-brand-primary]] |
| D-03 | 2026-11-08 | Artifact-first: no app code until "I approve the redesign. Start implementation" | decided | user | [[ADR-003-redesign-artifact-first]] |
| D-04 | 2026-11-08 | Android only; no iOS work in the redesign | decided (prior) | user | [[ADR-001-android-only-store-driven]] |
| D-05 | 2026-11-08 | Dark-only theme; no light mode | proposed | Claude | [[Redesign-Product-Gaps]] |
| D-06 | 2026-11-08 | Keep Urbanist (bundle it) rather than switch fonts | proposed | Claude | [[Redesign-Design-System]] |
| D-07 | 2026-11-08 | Two-red system: `#FF3142` for fg on dark, `#E11D2E` for filled buttons (white label AA) | proposed | Claude | [[Redesign-Design-System]] |
| D-08 | 2026-11-08 | Tabs: Home · Search · My List · Channels · Profile; WatchHistory folds into My List | proposed | Claude | [[Redesign-Strategy]] |
| D-09 | 2026-11-08 | Settings split out of Profile | proposed | Claude | [[Redesign-Strategy]] |
| D-10 | 2026-11-08 | AuthPromptSheet + action replay replaces all guest dead ends | proposed | Claude | [[Redesign-User-Flows]] |
| D-11 | 2026-11-08 | Remove persistent ad above tab bar; use inline placements | proposed | Claude | [[Redesign-Strategy]] |
| D-12 | 2026-11-08 | "Recommended for You" → "Popular" until real personalisation exists | proposed | Claude | [[Redesign-UI-UX-Audit]] |
| D-13 | 2026-11-08 | Reuse installed libs (toast, netinfo, bootsplash); no new UI framework | proposed | Claude | [[Redesign-Roadmap]] |
| D-14 | 2026-11-08 | Remove "Remember me" (sessions persist anyway) | proposed | Claude | [[Redesign-Strategy]] |
| D-16 | 2026-11-08 | Brand spelling **MANHWAFLIX** (matches Play app name); wordmark MANHWA red + FLIX white | decided | user | Q-01 |
| D-17 | 2026-11-08 | Mockups use vault design system (not the unrelated saved "Khail" system) | decided | user | [[Redesign-Design-System]] |
| D-18 | 2026-11-08 | Review order: clickable design prototype first, iterate on feedback, finalize full mobile flow, then code | decided | user | [[Redesign-Visual-References]] |
| D-19 | 2026-11-08 | Account deletion = **request flow**: in-app submit disables account (`isActive=false`, status `pending_deletion`), signs out everywhere, creates `account_deletion_requests` row; admin approves → existing hard delete of all user data; reject → reactivate. Reuses `apps/backend/src/account-deletion-requests` + admin page `delete-account-requests` | decided | user | [[Redesign-Roadmap]] R-10 |
| D-20 | 2026-11-08 | Keep ads across many screens; remove only the tab-bar-adjacent banner; placement map in [[Redesign-Strategy#Ad placement map]] | decided (map proposed) | user | R-18 |
| D-21 | 2026-11-08 | All list endpoints use one pagination contract (`PaginationDto` page/limit → `PaginatedResult {data, meta}`); mobile uses `useInfiniteQuery` everywhere | decided | user | R-17 |
| D-22 | 2026-11-08 | Deletion confirm = user types **DELETE** (all account types, no password / Google re-auth). Request **cannot be cancelled** by the user. Admin review window **7 days** (state in privacy policy + app copy) | decided | user | R-10 |
| D-23 | 2026-11-08 | Optional ad formats (between-episode interstitial, app-open) **deferred**; banner/native/rewarded placements stand. Prototype not updated with ad slots yet | decided | user | [[Redesign-Strategy#Ad placement map]] |
| D-24 | 2026-11-08 | User explicitly started implementation of **Step 1 only** ("Just start implementation of step 1"); each later step needs its own go-ahead | decided | user | [[Redesign-Roadmap]] |
| D-25 | 2026-11-08 | User started **Step 2** (UI kit). Kit is additive; dev-only gallery via Dev Menu | decided | user | [[Mobile-UI-Kit]] |
| D-26 | 2026-11-08 | User started **Step 3**. Unknown NetInfo reachability counts as online (no false offline banner); global OfflineBanner + ToastHost + root ErrorBoundary in `App.tsx`; no query-cache persistence yet | decided | user | [[Mobile-UI-Kit]] |
| D-27 | 2026-11-08 | User started **Step 4**. Refresh-token rejection (400/401/403) is the only automatic sign-out; offline keeps session. Guest actions replay after sign-in (10-min TTL) | decided | user | [[Mobile-Auth]] |
| D-28 | 2026-11-08 | User started **Step 5**. My List tab uses FavoritesScreen until Step 9; Settings/DeleteAccount routes registered with their screens (Step 8), not as placeholders; tab-bar banner removed now, inline ads in Step 7 | decided | user | [[Mobile-Navigation]] |
| D-29 | 2026-11-08 | User started **Step 6**. Up Next countdown 5s; fullscreen in-app (same view resized + own Kotlin orientation/immersive module; SDK fullscreen dropped because it shows the host logo, D-30); autoplay persisted under MMKV `autoplay_next`; Episode logic split into hooks under `src/screens/app/episode/` | decided | user | [[Video-Playback]] |
| D-30 | 2026-11-08 | **Hide video host**: users must never see or learn videos are on Dailymotion — no external links/buttons, no branding, no copy naming it. Native player branding must be disabled in Dailymotion Partner HQ player config | decided | user | [[Video-Playback]] |
| D-31 | 2026-11-08 | User started **Step 7**. Detail episodes default **oldest first**; "Watched" inferred for chapters below the single saved progress row; Home "Popular" rail uses real `recommendations?type=popular`; Home inline ads ×2 + Detail ad below synopsis | decided | user | [[Mobile-Navigation]] |
| D-32 | 2026-11-08 | User started **Step 8**; approved backend + admin changes. Legal links = env placeholders (rows hide / Privacy falls back in-app) until Q-03. No DB migration (varchar status `pending_deletion`). Deletion endpoint skips RolesGuard so restricted users can delete. Login returns `code: ACCOUNT_PENDING_DELETION` after password check. `signOut` reason `deleted` | decided | user | [[Account-Deletion]] [[Mobile-Settings]] |
| D-33 | 2026-11-09 | User started **Step 9**; approved backend history delete/clear/paging. **No ads in My List** until native cards (R-18). Removes use hide + Undo toast + delayed server call (no restore APIs). `GET /watch-history/me` pages only when `page` sent, so live app builds keep the bare array | decided | user | [[My-List]] |
| D-34 | 2026-11-09 | User started **Step 10**. Stats collapsible + closed by default (Q-08). Display name editable → backend `fullName` on `PATCH /users/me/profile` (approved). No crop lib (resize only). Avatar uploads on Save, old photo deleted only after PATCH succeeds | decided | user | [[Mobile-Profile]] |
| D-35 | 2026-11-09 | User started **Step 11**; approved backend `status` + `sort` on `/manhuas/search` (+ LIKE escaping). Recents saved only on explicit submit (not on recent/suggestion tap). Sort default Best match with q, Newest without | decided | user | [[Mobile-Search]] |
| D-37 | 2026-11-11 | User started **Step 14**. Sign up = Name, Email, Password only: no username (server generates via `generateUniqueUsername`, Q-07) and no confirm password (eye + live rules instead). Approved backend: `RegisterDto.username` optional. Consent line (no checkbox) under Google + Create account | decided | user | [[Mobile-Auth]] [[Backend-Auth]] |
| D-46 | 2026-11-11 | User started **Step 23**: show cached data instead of loading and update lists in place → persisted React Query cache in MMKV (allowlist, page-1 trim, build buster, 3 days), wiped on sign-out. Supersedes D-26's "no persistence" | decided | user | [[ADR-005-persisted-query-cache]] |
| D-45 | 2026-11-11 | User started **Step 22** (R-40/R-41). Copy rules: watch/episode/series vocabulary, "Ep N" compact vs "Episode N" titles, no raw dev/SDK error text; images decorative by default for TalkBack | decided | user | [[Mobile-UI-Kit]] |
| D-44 | 2026-11-11 | User started **Step 21**. Native splash logo = launcher M artwork (circle crop) on `#050507`; JS splash removed. Adopted D-15 (priority ≥4 blocks, else flexible + Restart bar) | decided | user | [[Mobile-Theme]] [[In-App-Update]] |
| D-43 | 2026-11-11 | User started **Step 20** (R-18). One AdMob unit per format (Native + Banner) with optional per-placement env overrides. Grid ads are full-width rows between poster rows (native media ≥120dp). Detail episode-list native deferred | decided | user | [[Mobile-Ads]] |
| D-42 | 2026-11-11 | User started **Step 19** (R-31). Like/My List actions are **intent-based** (desired state, server checked first) and shared by Detail + Episode; inline query keys banned by lint; views recorded once per session | decided | user | [[Mobile-API]] |
| D-41 | 2026-11-11 | User started **Step 18** (R-17). Pagination is **opt-in** (`page` → `{data, meta}`, else legacy array) so Play 1.0.4 keeps working. Chapters: app keeps the full list but slim (`fields=list`) instead of paging Detail/Episode | decided | user | [[Backend-API]] |
| D-40 | 2026-11-11 | User started **Step 17** (R-15). After sign-in without an explicit target the app returns to the screen sign-in started from (not Profile). Profile guest Google is one tap. Account-only screens show a signed-out state instead of a broken form | decided | user | [[Mobile-Auth]] |
| D-39 | 2026-11-11 | User chose **Step 16 = last legacy screens**: SeeAll paged per collection (sort chips dropped), About + in-app Privacy rebuilt (video host unnamed in policy), ForceUpdate loading + Play fallback; legacy Header/cards/`COLORS` deleted | decided | user | [[Mobile-Settings]] [[In-App-Update]] |
| D-38 | 2026-11-11 | User started **Step 15** (Comments). Approved backend: optional-auth `myReaction`, `sort=top\|newest`, vote toggle-off, `author.level/avatarUrl`. ⋯ menu = Edit + Delete own (no Report). Replies **one level**, reply-to-reply posts under the parent with @mention. Full-screen Comments route + 3-comment preview on Detail/Episode (not a sheet) | decided | user | [[Mobile-Comments]] |
| D-36 | 2026-11-09 | User started **Step 12**; approved backend: hide drafts on public channel routes/counts, idempotent subscribe, uploads `sort`. ChannelDetail route = `channelId` + optional preview. One shared `useChannelSubscription` hook | decided | user | [[Mobile-Channels]] |
| D-15 | 2026-11-08 | Flexible Play update by default; immediate only at priority ≥4 | decided 2026-11-11 (Step 21) | Claude | [[Redesign-Roadmap]] |

## Open questions
| # | Question | Why it matters | Blocks |
|---|---|---|---|
| ~~Q-01~~ | ~~Brand spelling~~ → resolved D-16 (MANHWAFLIX). Store screenshots need re-shoot later | — | — |
| ~~Q-02~~ | Resolved D-22: type DELETE, no cancel, 7 days | — | — |
| ~~Q-03~~ | Resolved 2026-11-11: hosted Privacy + Terms on manhuaflix.hbhammaddyar.com (`/p/privacy-policy.html`, `/p/terms-and-conditions.html`), support email set; all in `.env*` (`PRIVACY_POLICY_URL`, `TERMS_URL`, `SUPPORT_EMAIL`) | — | — |
| Q-04 | Deep link domain: `manhuaflix.hbhammaddyar.com` is Blogger (no `/.well-known/assetlinks.json`). Proposed: `link.hbhammaddyar.com` on Firebase Hosting (assetlinks + fallback pages); needs subdomain name, Play app-signing + upload SHA-256, fallback target | Share and deep links | R-50 |
| ~~Q-05~~ | Resolved: `GET /manhuas/search` already paginated; mobile never calls it. Other gaps in R-17 | — | — |
| ~~Q-06~~ | Resolved D-20: remove tab-bar banner, add inline placements | — | — |
| ~~Q-07~~ | Resolved D-37: username auto-created by the server, editable in Edit profile | — | — |
| ~~Q-08~~ | Resolved D-34: collapsible Stats card, closed by default, remembered per device | — | — |
| Q-09 | Ship incrementally to Play (per phase) or as one big release? | Release plan, screenshots | all |

## Approval status
| Artifact | Status | Date |
|---|---|---|
| Blueprint (this folder) | ⏳ awaiting user approval | — |
| Design prototype (https://claude.ai/artifact/Jw9ugkXM5PPhUDDWcc28JR) | 🔄 in review | 2026-11-08 |
| Design system | ⏳ | — |
| Roadmap | ⏳ | — |
