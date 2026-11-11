---
type: feature
area: backend
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [feature, account, deletion, play-policy]
related: ["[[Backend-Auth]]", "[[Mobile-Settings]]", "[[Admin-Routes]]", "[[Redesign-Roadmap]]"]
---
# Account Deletion

## What it does
- In-app deletion **request** (D-19, D-22): user types `DELETE` → account disabled at once (signed out everywhere) → admin approves (hard delete) or rejects (reactivate) within **7 days**. User cannot cancel.
- Public web form (`/delete-account`, Play data-deletion URL) still exists, unauthenticated, matches by email+username, does **not** disable the account.

## Touches
- Backend: `POST /account-deletion-requests/me` (AuthGuard only), login checks, reject reactivates.
- Admin: `/delete-account-requests` Due column + user link; users page `pending_deletion` badge/filter.
- Mobile: Settings → Delete account (3 steps), Login/Signup message. See [[Mobile-Settings]].

## Key files
- `apps/backend/src/account-deletion-requests/account-deletion-requests.me.controller.ts`, `…service.ts` `requestOwnDeletion` / `rejectRequest`, `dto/request-my-account-deletion.dto.ts` (`@Equals("DELETE")`, reason ≤500).
- `apps/backend/src/auth/auth.service.ts` `assertNotPendingDeletion` (login + Google).
- `apps/admin/src/app/delete-account-requests/page.tsx` (`dueLabel`, `REVIEW_DAYS`).
- `apps/mobile/src/screens/app/settings/DeleteAccountScreen.tsx`, `src/api/users.ts` `requestAccountDeletion`, `src/utils/api-error.ts`.

## Flow
1. `requestOwnDeletion(userId)` in one transaction: admin → 403; existing pending row for user → reuse (idempotent); insert row; `users.isActive=false`, `moderation_status='pending_deletion'`; deactivate all `device_push_tokens`.
2. Returns `{id, status, createdAt, dueAt, reviewDays}`.
3. Other sessions die on next request: `AuthGuard` → `resolveAccessStatus` rejects `!isActive`; `/auth/refresh` rejects too.
4. Login (password ok) / Google → 401 body `{ code: "ACCOUNT_PENDING_DELETION", message }`.
5. Admin approve → existing `usersService.deleteUserAccount(..., {isAdminAction})` (FK cascades). Reject → user back to `isActive=true`, `active` (only if still `pending_deletion`).

## Gotchas
- **No migration**: `moderation_status` is varchar(20), `user_id` column already existed. Type `UserModerationStatus` now includes `pending_deletion`; admin list filter DTO accepts it.
- Not behind `RolesGuard` on purpose: `restricted` users get 403 on writes there, but must still be able to delete.
- Refresh tokens are stateless JWTs (no table) → nothing to revoke; disable flag is the kill switch.
- Pending check runs **after** password check (no account-state leak to wrong passwords).
- Review window constant duplicated: backend `ACCOUNT_DELETION_REVIEW_DAYS`, admin `REVIEW_DAYS`, mobile `src/config/legal.ts`. Change all three + privacy policy copy together.
- Old `DELETE /users/me` (password hard delete) still exists; mobile does not use it.
