---
type: feature
area: mobile
status: active
created: 2026-11-11
updated: 2026-11-11
tags: [feature, mobile, comments, redesign]
related: ["[[Backend-API]]", "[[Mobile-Profile]]", "[[Redesign-Roadmap]]", "[[Redesign-Decision-Log]]", "[[Mobile-UI-Kit]]"]
---
# Mobile Comments (redesign Step 15)

R-33 + CM-01..06 ([[Redesign-UI-UX-Audit]] §9). Decisions: D-38 in [[Redesign-Decision-Log]].

## Layout
- **Preview** `src/screens/app/comments/CommentsPreview.tsx` on Detail (footer) and Episode (below synopsis): "Comments (N)", View all, fake "Add a comment…" input, top 3 rows (votes, ⋯ Edit/Delete, author sheet work inline), "View N replies" / "View all N comments" → full screen.
- **Full screen** `CommentsScreen.tsx`, route `Comments { manhuaId, manhuaTitle?, placement, compose? }` (`types/routes`). `compose` = new / reply (`parentId, name, prefill`) / edit (`commentId, content`) — the preview hands off Reply/Edit through it.
  - Top / Newest `SegmentedControl` → server sort (`?sort=`), separate infinite cache per sort.
  - Virtualized `FlatList` + `usePagedList`, `LoadMoreFooter`, pull-to-refresh (`useRefreshControl`), `RowSkeletons` / `ErrorState` / `EmptyState`.
  - `AdBanner` row every **8** comments (was 5), route `placement` (Detail/Episode banner ids). No NativeAdCard yet (R-18).
  - Sticky `CommentComposer` in `KeyboardAvoidingView behavior="height"` (same as AuthLayout). Guests see "Sign in to join the discussion" → `useRequireAuth` (replays focus). Counter from 1800/2000 chars.
- `CommentRow.tsx` (memo): avatar (new `author.avatarUrl`), name, compact `RankBadge` (removes the old local `getRankBadgeCode`), relative time + "edited", 5-line clamp + Read more, like (`thumb`) / dislike (`thumbDown`) / Reply / ⋯ (own only). Action targets 36dp + `hitSlopFor` → 48dp.
- `ReplyThread.tsx`: collapsed "View N replies" → replies paged oldest-first. **One level**: replying to a reply posts under its parent with `@username ` prefilled (`replyTargetFor` in `use-comment-interactions.tsx`). Legacy deeper replies still render at the same indent.
- `AuthorCardSheet.tsx`: `BottomSheet` (replaces RN Modal); real level bar from `levelProgress` (no more hardcoded 42%), icon stats.

## Cache (`comment-cache.ts`, `use-comments.ts`)
- Keys (`api/query-keys.ts`): prefix `comments(id)` → `commentsList(id, sort)` (infinite) + `commentsPreview(id)` (plain page, limit 3; Detail count shares it via `commentsPreviewQuery`). Replies `commentRepliesOf(id, cid)` under `commentReplies(id)`.
- Helpers handle both cache shapes (infinite + plain page).
- Vote: optimistic `applyVote` (same toggle rule as server), then server summary; failure → restore snapshot + toast.
- Create: top-level prepended to loaded lists (+total); reply bumps parent `replyCount` + invalidates that thread; preview invalidated.
- Edit: patch content/updatedAt. Delete: `ConfirmSheet` (warns replies go too — hard delete) → optimistic remove, 404 = done, failure → restore.

## Gotchas
- Requires backend `feat/comments-v2` for real `myReaction`, `sort`, toggle-off, `author.level/avatarUrl`. Against an old backend: sort ignored (always top), highlights reset on refetch, second tap of same vote doesn't remove it.
- `useIsOwnComment` compares `String(comment.userId)` to auth store `user.id` (string).

## Links
- Backend routes: [[Backend-API#comments]]
