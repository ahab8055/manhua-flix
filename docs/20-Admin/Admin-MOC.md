---
type: moc
area: admin
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [moc, admin]
related: ["[[Home]]", "[[Backend-MOC]]"]
---
# Admin MOC

`apps/admin` — Next.js 15 App Router, React 18, TanStack Query 5, axios, js-cookie, Tailwind 3. Submodule `ahab8055/manhua-flix-admin`. All pages client-rendered (`"use client"`), alias `@/*` → `src/*`. Dev port 3000.

Roles: `admin` (everything) and `uploader` (manhuas + channels only).

- [[Admin-Routes]] — every page + what it does
- [[Account-Deletion]] — deletion request review (cross-app feature note)
- [[Admin-API-Client]] — axios instance, refresh, endpoints per feature
- [[Admin-Auth]] — login, cookies, middleware, role gating
- [[Admin-Shared-UI]] — components, `useListParams`, query keys
- [[Admin-Gotchas]] — known issues found on scan
- Related: [[Upload-Jobs]] (pipeline UI), [[Shared-Config-Packages]]

Env: `NEXT_PUBLIC_API_URL` (must include `/api`; build-time inlined). Scripts: `dev`, `build`, `start`, `lint` (`next lint`, deprecated), `type-check`.
