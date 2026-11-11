---
type: decision
area: mobile
status: accepted
created: 2026-11-08
updated: 2026-11-08
tags: [adr, mobile, design-system, brand]
related: ["[[Redesign-Design-System]]", "[[Mobile-Theme]]", "[[Mobile-Redesign-MOC]]"]
---
# ADR-002 Red is the brand primary

## Context
- `src/theme/colors.ts` declares `PRIMARY #5030E5` (purple) and `SECONDARY #4069E1` (blue). Neither is used on screens.
- The app and Play Store screenshots use red, but inconsistently: `ACCENT_RED #FF3142` plus `#F23645` (×14), `#CC1111` (splash) and others.
- Purple leftovers persist in fallback palettes, the Channels glow and the player.

## Decision
- Red is the single brand colour. User confirmed 2026-11-08.
- Two tokens:
  - `brand.fg #FF3142` for text, icons and progress on dark (5.6:1).
  - `brand.fill #E11D2E` for filled buttons with a white label (4.75:1, AA).
- Purple and blue are removed from the palette.

## Consequences
- Store screenshots stay valid.
- All red variants migrate to tokens ([[Redesign-Design-System#7. Migration map (existing literal → token)]]).
- Don't reintroduce purple or blue accents.

## Alternatives rejected
- Purple primary (follows the theme file): it would conflict with the store listing and the current look, and require re-shooting the screenshots.
