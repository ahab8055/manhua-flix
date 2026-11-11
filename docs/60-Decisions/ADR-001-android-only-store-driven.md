---
type: decision
area: mobile
status: accepted
created: 2026-10-30
updated: 2026-11-08
tags: [adr, mobile, android]
related: ["[[Mobile-MOC]]", "[[In-App-Update]]"]
---
# ADR-001 Android-only, store-driven config

## Context
iOS app not on store yet. Force-update originally proposed as backend/admin-stored min-version table.

## Decision
- Mobile scope = **Android only** until told otherwise.
- Prefer **Play Store as source of truth** over backend-stored config when the store can answer (e.g. app version).
- Force update implemented via custom Kotlin `InAppUpdate` module using Play In-App Updates (`IMMEDIATE`). See [[In-App-Update]].

## Consequences
- Don't propose iOS work or backend config tables for things the store answers.
- Scope mobile plans to Android.

## Alternatives rejected
- Backend/admin-managed `app_versions` table — rejected: manual version bookkeeping.
