---
type: note
area: admin
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [admin, ui]
related: ["[[Admin-MOC]]"]
---
# Admin Shared UI & Conventions

## Components `src/components/`
- `admin-shell.tsx` sidebar, role-filtered nav, logout
- `channel-form.tsx` shared create/edit channel
- `image-uploader.tsx` file → base64 → `POST /cloudinary/upload` immediately (passes `oldUrl`); remove → delete immediately
- `multi-select-chips.tsx` genres by **name**, not id
- `dailymotion-preview.tsx` embed iframe
- `delete-account-policy-view.tsx`, `delete-account-request-form.tsx`
- `list/` barrel: `SearchInput`, `FilterSelect` (+ `BOOLEAN_FILTER_OPTIONS`, `booleanFilterValue`), `SortableHeader`, `PaginationBar`, `ListToolbar`

## Hooks
- `src/hooks/use-list-params.ts` — `useListParams({prefix, defaultSortBy, defaultSortOrder, defaultLimit=20, filters})` syncs page/limit/q/sort/filters to URL (`router.replace`), 300ms search debounce, `prefix` for multiple lists per page. `useClampPage` steps back when page empties.

## React Query
- Defaults (`src/providers/query-provider.tsx`): `staleTime 60s`, `retry 1`, no refetch on focus; Devtools always mounted.
- Keys: lists `[entity, "list", params]`; single `["manhua", id]`, `["channel", id]`; analytics `["admin-analytics"]`, `["admin-notifications", sub, …]`, `["admin-ad-analytics", …]`; `["progression-config"]`, `["colab-job-logs", id]`. Paginated use `placeholderData: keepPreviousData`.
- Polling: dashboard/notifications/ad-analytics 15s (background too); upload jobs + logs 5s while in flight.

## Style
Dark gray-950 + indigo/purple, hand-styled Tailwind. tsconfig strict (`exactOptionalPropertyTypes`, `noUncheckedIndexedAccess`).
