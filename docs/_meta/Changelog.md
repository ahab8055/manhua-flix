---
type: meta
area: meta
status: active
created: 2026-11-08
updated: 2026-11-11
tags: [meta, changelog]
related: ["[[Home]]", "[[Conventions]]"]
---
# Changelog

Newest first. Format: `- YYYY-MM-DD · area · what changed · [[notes]]`

- 2026-11-11 · meta · Pushed `main` of backend (`546d701`), admin (`4f6a8f9`), mobile (`fe16717`), root (`aa5cded`). User verified all redesign work through Step 15 on a physical device → roadmap rows `tested` · [[Redesign-Roadmap]]
- 2026-11-11 · meta · All redesign work merged (fast-forward) into local `main`: mobile steps 1–15 (`fe16717`), backend 7 feature branches + comments (`546d701`), admin deletion requests (`4f6a8f9`); root repo commits vault + submodule pointers. Not pushed · [[Redesign-Roadmap]]
- 2026-11-11 · mobile+backend · Step 15: Comments rebuilt — 3-comment preview on Detail/Episode + full-screen `Comments` route (server Top/Newest, infinite, ad every 8, sticky composer), optimistic votes with toggle-off, edit/delete own, one-level replies with @mention, author sheet with real level bar; backend optional-auth `myReaction`, `sort`, vote toggle-off, author `level/avatarUrl`, deduped comment query + shared rank labels (mobile `fe16717`, backend `546d701`) · [[Mobile-Comments]] [[Backend-API]] [[Redesign-Decision-Log]]
- 2026-11-11 · meta · graphify auto-sync removed (hook unregistered + deleted); graph refreshed manually by user · [[ADR-004-graphify-auto-sync]] [[Knowledge-Graph]]
- 2026-11-11 · mobile+backend · Step 14 committed: mobile `9907ab7` (`redesign/step-14-auth`), backend `cf6c8dd` (`feat/register-auto-username`); not pushed · [[Mobile-Auth]] [[Backend-Auth]]
- 2026-11-11 · mobile+backend · Step 14: auth screens rebuilt on AuthLayout (Google first, autofill + chaining, consent line incl. Google, silent Google cancel, friendly errors), SignUp = name/email/password with live rules, Forgot success state (Open email app, 60s resend), ChangePassword rules checklist + Google-user path; backend `RegisterDto.username` optional → auto-generated (uncommitted) · [[Mobile-Auth]] [[Backend-Auth]] [[Redesign-Decision-Log]]
- 2026-11-11 · meta · graphify subagent rule (source_file only from FILE_LIST, no stub nodes) added to sync hook message after an update wiped 34 docs' nodes · [[2026-11-11-graphify-stub-nodes-wipe-docs]]
- 2026-11-11 · mobile+backend · Step 13 committed: mobile `5d7753a` (`redesign/step-13-notifications`), backend `a855175` (`feat/notifications-inbox`); not pushed · [[Push-Notifications]] [[Notifications]]
- 2026-11-11 · mobile+backend · Step 13: Notifications inbox rebuilt (auth gate, Today/Yesterday/Earlier, infinite, instant navigate + background read, announcement sheet, optimistic mark-all, remove + undo, category icons, exact badge); backend `GET /notifications/unread-count`, `DELETE /notifications/:id`, push data `notificationId` (uncommitted) · [[Push-Notifications]] [[Notifications]]
- 2026-11-11 · meta · traced malware: Jun 2 08:27 devRock/Healthcare-Medical-Supply-Plan → stealer + cron persistence + git hooks · [[2026-11-11-malicious-git-hooks]]
- 2026-11-11 · meta · graphify-out/ gitignored; found malicious local git hooks (security, open) · [[2026-11-11-malicious-git-hooks]] [[Knowledge-Graph]]
- 2026-11-11 · meta · Stop hook graphify-sync.sh auto-updates graphify-out (code: background AST; docs: /graphify --update); vault-check ignores graphify-out · [[ADR-004-graphify-auto-sync]]
- 2026-11-11 · overview · built repo knowledge graph with graphify (graphify-out/, 4274 nodes, images excluded) · [[Knowledge-Graph]]
- 2026-11-11 · mobile+backend · Step 12 committed: mobile `cadfd57` (`redesign/step-12-channels`), backend `c6906c6` (`feat/channels-cleanup`); not pushed · [[Mobile-Channels]]
- 2026-11-09 · mobile+backend · Step 12: Channels tab (Pinned/Subscribed/Discover, guest Discover, ⋯ pin/alerts/unsubscribe) + ChannelDetail (id+preview route, Subscribe always visible, alerts switch, paged uploads with real sort); shared `useChannelSubscription`; backend hides drafts on public channel routes, idempotent subscribe, uploads sort (uncommitted) · [[Mobile-Channels]]
- 2026-11-09 · mobile+backend · Step 11 committed: mobile `f7d161e` (`redesign/step-11-search`), backend `f675d7f` (`feat/search-filters`, incl. genre jsonb fix); not pushed · [[Mobile-Search]]
- 2026-11-09 · backend · Genre filter bug: `manhuas.genres` stored as double-encoded jsonb strings; `genresArray()` unwraps them in search, suggestions, Detail recs, admin filter (uncommitted; data cleanup + write fix open) · [[2026-11-09-genre-filter-misses-double-encoded-jsonb]]
- 2026-11-09 · mobile+backend · Step 11: Search rebuilt (in-flow suggestions, paged results grid with Status/Sort + count, recents without re-saving, confirm clear, popular grid, states); TextField `onClear`; backend `/manhuas/search` `status` + `sort`, LIKE escaping (uncommitted) · [[Mobile-Search]]
- 2026-11-09 · mobile+backend · Step 10 committed: mobile `a5fe030` (`redesign/step-10-profile`), backend `82388c2` (`feat/profile-full-name`); not pushed · [[Mobile-Profile]]
- 2026-11-09 · mobile+backend · Step 10: Profile rebuilt (identity card, collapsible Stats, shortcuts, guest card, edit sheet with upload-on-save), progression overlays fixed (restart, safe area, a11y, reduced motion), one rank label; backend `fullName` on profile PATCH + username race → 400 (uncommitted) · [[Mobile-Profile]]
- 2026-11-09 · mobile+backend · Step 9 committed: mobile `ef23390` (`redesign/step-9-my-list`), backend `7912fc1` (`feat/watch-history-manage`); not pushed · [[My-List]]
- 2026-11-09 · mobile+backend · Step 9: My List tab (Continue / Favorites / History, infinite lists, Undo removes, history grouped by day, Clear all); backend `DELETE /watch-history/:id`, `DELETE /watch-history/me`, paged `GET /watch-history/me?page`; legacy Favorites/WatchHistory screens removed (uncommitted) · [[My-List]]
- 2026-11-09 · mobile+backend+admin · Step 8 committed: mobile `b13c8f3` (`redesign/step-8-settings-delete`), backend `3bec1a0` + admin `4f6a8f9` (`feat/account-deletion-me`); not pushed · [[Account-Deletion]] [[Mobile-Settings]]
- 2026-11-08 · mobile+backend+admin · Step 8: Settings screen (optimistic notification switches, playback, account, legal, version), 3-step Delete account → `POST /account-deletion-requests/me` (disable now, admin 7-day Due column, reject reactivates), pending-deletion login code, Profile slimmed (uncommitted) · [[Account-Deletion]] [[Mobile-Settings]]
- 2026-11-08 · mobile · Step 7: Home (hero Play, one-tap resume, Popular rail, per-rail errors, 2 inline ads) + Detail (CTA Continue/Play, virtualized episodes with sort/range/jump + watched markers, About tab, guest sheet everywhere); media components; Detail logic moved to hook unchanged (mobile commit `54e42b6` on `redesign/step-7-home-detail`) · [[Mobile-Navigation]] [[Mobile-UI-Kit]]
- 2026-11-08 · mobile · Fullscreen no longer uses Dailymotion SDK dialog (showed DM logo): in-app fullscreen with own controls + new `PlayerFullscreenModule.kt` (landscape + immersive) · [[Video-Playback]]
- 2026-11-08 · mobile · Fix: "Video unavailable" overlay shown over a playing video — errors now debounced (4s grace, 25s setup timeout) and self-heal on playback activity · [[Video-Playback]]
- 2026-11-08 · mobile · Hide video host (D-30): removed "Open in Dailymotion", WebView embed-only with branding/sharing/queue off and outbound navigation blocked · [[Video-Playback]]
- 2026-11-08 · mobile · Step 6: Episode player redesign — sticky player, prev/next from chapters, persisted autoplay + guest Up Next, episodes drawer, player overlay controls + draggable seek + settings sheet, SDK fullscreen (no reload), error/retry + setup timeout, WebView fallback usable; logic moved to hooks unchanged (mobile commit `d5af05c` on `redesign/step-6-episode-player`, incl. later fixes: hide host, error debounce, in-app fullscreen) · [[Video-Playback]]
- 2026-11-08 · mobile · Step 5: tabs Home·Search·My List·Channels·Profile, kit tab bar (filled icon + indicator, a11y tabs), re-tap scroll-to-top, tab-bar ad removed (mobile commit `fd4a043` on `redesign/step-5-nav-shell`) · [[Mobile-Navigation]] [[Mobile-Ads]]
- 2026-11-08 · mobile · Step 4: central signOut (server logout, push unregister, cache clear), refresh only expires on 400/401/403, queryKeys + cache-sync (fixes Episode→Detail like/fav and ChannelDetail→Channels staleness), AuthPromptSheet with action replay (mobile commit `49db80c` on `redesign/step-4-session-cache-auth`) · [[Mobile-Auth]] [[Mobile-API]]
- 2026-11-08 · mobile · Step 3: toasts, friendly error copy, NetInfo/AppState → React Query, global OfflineBanner, root ErrorBoundary, user-pull-only refresh hook (mobile commit `8619cbb` on `redesign/step-3-feedback-offline`) · [[Mobile-UI-Kit]] [[Mobile-State]]
- 2026-11-08 · mobile · Step 2: UI kit (`src/components/ui`, 17 components) + icon set + dev-only UI Kit gallery (mobile commit `99eadc1` on `redesign/step-2-ui-kit`) · [[Mobile-UI-Kit]]
- 2026-11-08 · mobile · Step 1: Urbanist TTFs bundled, `src/theme/tokens.ts`, removed unused purple/light COLORS, hex-literal lint warning (mobile commit `0014890` on `redesign/step-1-fonts-tokens`) · [[Mobile-Theme]] [[Redesign-Roadmap]]
- 2026-11-08 · mobile/backend · Deletion: type DELETE for all users, no cancel, 7-day review; interstitial/app-open ads deferred · [[Redesign-Decision-Log]]
- 2026-11-08 · mobile/backend · Decisions: deletion = request + admin approval (reuses existing module), backend pagination sweep, ads kept with placement map; prototype Delete account updated · [[Redesign-Decision-Log]] [[Redesign-Strategy]] [[Redesign-Roadmap]]
- 2026-11-08 · mobile · Clickable redesign prototype published (14 screens + tokens + components); brand spelling MANHWAFLIX decided · [[Redesign-Visual-References]] [[Redesign-Decision-Log]]
- 2026-11-08 · mobile · UI/UX audit + redesign blueprint (12 notes in 35-Mobile-Redesign), ADR-002 red brand, ADR-003 artifact-first gate, new mobile gotchas. No code changed · [[Mobile-Redesign-MOC]] [[Redesign-Dashboard]] [[2026-11-08-mobile-redesign-audit]]
- 2026-11-08 · meta · Vault created + seeded (overview, backend, admin, mobile, pipelines, release, ADR-001, gotcha lists); CLAUDE.md + Stop hook enforce updates · [[Home]] [[Conventions]] [[2026-11-08-vault-setup]]
