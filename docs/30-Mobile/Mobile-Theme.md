---
type: note
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [mobile, ui, design-system]
related: ["[[Mobile-MOC]]", "[[Redesign-Design-System]]", "[[ADR-002-red-brand-primary]]"]
---
# Mobile Theme & Splash

## Tokens (new UI) — `src/theme/tokens.ts`
- Import `{ tokens, hitSlopFor } from '@/theme'`. Spec: [[Redesign-Design-System]].
- `tokens.color` (bg/border/text/brand/success/warning/danger/info/overlay/rank), `tokens.font`, `tokens.type` (display/title/heading/body/label/caption, fontFamily only), `tokens.typeScaleLimit` (maxFontSizeMultiplier per step), `tokens.space`, `tokens.radius`, `tokens.motion`, `tokens.touch.min` (48), `tokens.iconSize`.
- Brand: `brand.fg #FF3142` for text/icons on dark; `brand.fill #E11D2E` for filled buttons with white label (white on `#FF3142` fails AA).
- ESLint (`.eslintrc.js` override, warn): hex literals in `src/screens/**` + `src/components/**` → use tokens. ~258 legacy warnings, cleared per screen.

## Legacy (deprecated, still used by existing screens)
- `src/theme/colors.ts` `COLORS`: `ACCENT_RED #FF3142`, `DARK_BG #050507`, `DARK_SURFACE #0C0D11`, `DARK_CARD #14151A`, `DARK_MUTED #8B909B`, `DARK_BORDER #1C1E24`, `WHITE`, `SUCCESS #00DF80`, `ERROR #EF4444`. Removed 2026-11-08 (unused): `PRIMARY` purple, `SECONDARY`, `BLACK`, `GREY`, `BORDER`, `BACKGROUND`.
- `FONT` Urbanist Regular/Medium/SemiBold/Bold/ExtraBold; `SIZES` XS 10 … XL 24.

## Fonts
- Urbanist static TTFs (OFL, upstream `github.com/coreyhu/Urbanist` `fonts/ttf/`) in `src/assets/fonts/` + `OFL.txt`; copied to `android/app/src/main/assets/fonts/` (Android resolves `fontFamily` by file name). Added 2026-11-08 (redesign R-01).
- Gotcha: `fontWeight` + custom `fontFamily` on Android can pick wrong face — use the per-weight family, no `fontWeight`.
- Adding a weight: drop TTF in both folders with exact name `Urbanist-<Weight>.ttf`.

## Splash
- Custom JS `src/screens/splash/SplashScreen.tsx` — animated red "M" on `#090909`. `react-native-bootsplash` installed but **not wired** (R-51).
- Android `AppTheme` DayNight.NoActionBar, launcher bg `#150D0D`.
