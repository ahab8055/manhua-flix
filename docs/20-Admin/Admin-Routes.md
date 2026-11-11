---
type: note
area: admin
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [admin, routes]
related: ["[[Admin-MOC]]"]
---
# Admin Routes

Protected pages wrap in `<AdminShell>` (`src/components/admin-shell.tsx`). List pages wrap in `<Suspense>` (needed by `useSearchParams`).

| Route | Roles | Purpose |
|---|---|---|
| `/login` | public | email/password → `POST /auth/login`; rejects non admin/uploader |
| `/delete-account` | public | server component; deletion policy + request form (Play Store data-deletion URL) |
| `/` | admin | dashboard: stats + analytics (top chapters, favorites, search keywords, trending, progression, notif delivery, failed, activity); 15s refetch |
| `/users` | admin | paginated users; role/moderation filters; activate/restrict/suspend (optimistic), delete |
| `/delete-account-requests` | admin | approve (hard-delete user) / reject with note (reactivates in-app requests); pending badge; Due column (7 days, red when overdue); matched user links to `/users?q=email` ([[Account-Deletion]]) |
| `/manhuas` | admin, uploader | list; filters status/published/featured/channel/genre |
| `/manhuas/new` | admin, uploader | create; cover + title image via Cloudinary; → edit page |
| `/manhuas/import` | admin, uploader | 4-step CSV import wizard; sequential `createManhua` per row; one channel for all rows |
| `/manhuas/[id]/edit` | admin, uploader | full edit incl. featured order, counts; delete (cascades chapters); resend notification |
| `/manhuas/[id]/chapters` | admin, uploader | chapter form (number, title, Dailymotion URL + preview, one image = `pageUrls[0]`); table |
| `/upload-jobs` | admin (nav shows uploader — see [[Admin-Gotchas]]) | video pipeline UI → [[Upload-Jobs]] |
| `/channels` | admin, uploader (read-only) | list; sort `subscriberCount desc` |
| `/channels/new`, `/channels/[id]/edit` | admin | `ChannelForm` + owner (uploader) assignment |
| `/comments` | admin | moderation feed; optimistic delete |
| `/notifications` | admin | delivery overview, content notification (new_manhua/new_chapter), broadcast composer (allUsers / userIds / channelSubscribers), process pending, failed/activity logs; URL prefixes `b_`,`f_`,`a_` |
| `/ad-analytics` | admin | banner impressions, rewarded completions, points; top placements; daily (7/14/30d) |
| `/progression` | admin | singleton progression config (points, levels, ranks, RPG stats, `requireAdSsv`); PUT |
| `/settings/genres` | admin | genre CRUD inline |
