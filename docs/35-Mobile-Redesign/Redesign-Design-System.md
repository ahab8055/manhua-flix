---
type: note
area: mobile
status: draft
created: 2026-11-08
updated: 2026-11-08
tags: [mobile, redesign, design-system, tokens, a11y]
related: ["[[Mobile-Redesign-MOC]]", "[[Mobile-Theme]]", "[[ADR-002-red-brand-primary]]", "[[Redesign-Strategy]]"]
---
# Design System: "Cinematic Dark"

Replaces the ad-hoc `src/theme` ([[Mobile-Theme]]). Proposed location: `src/theme/tokens.ts` + `src/components/ui/*`. Dark only.

## 1. Color
Contrast ratios below are WCAG 2.1, computed 2026-11-08.

### Neutrals
| Token | Hex | Use | Contrast |
|---|---|---|---|
| `bg.canvas` | `#050507` | screen background | — |
| `bg.surface` | `#0C0D11` | sheets, tab bar, headers | — |
| `bg.card` | `#14151A` | cards, inputs | — |
| `bg.elevated` | `#1C1E24` | pressed, chips, skeleton base | — |
| `border.subtle` | `rgba(255,255,255,0.06)` | card hairlines | — |
| `border.default` | `#1C1E24` | dividers, inputs | — |
| `text.primary` | `#FFFFFF` | titles, body | 20.4:1 on canvas, 18.2:1 on card |
| `text.secondary` | `#C4C7CE` | supporting text | 12.0:1 |
| `text.muted` | `#8B909B` | meta, captions (≥12px) | 6.4:1 canvas · 5.7:1 card · 5.2:1 elevated |
| `text.disabled` | `#6B7080` | disabled only (exempt) | 4.1:1 |
| `overlay.scrim` | gradient `rgba(5,5,7,0)→rgba(5,5,7,0.92)` | text over imagery | — |
| `overlay.backdrop` | `rgba(0,0,0,0.6)` | sheet/modal backdrop | — |

### Brand ([[ADR-002-red-brand-primary]])
| Token | Hex | Use | Contrast |
|---|---|---|---|
| `brand.fg` | `#FF3142` | red text, icons, active tab, progress, links on dark | 5.6:1 canvas · 5.0:1 card ✅ |
| `brand.fill` | `#E11D2E` | filled primary buttons with white label | white on it 4.75:1 ✅ |
| `brand.fillPressed` | `#C81A29` | pressed primary | — |
| `brand.tint` | `rgba(255,49,66,0.14)` | selected chip bg, liked state bg | — |

> White on `#FF3142` is only 3.64:1, which fails AA for normal text. That's why filled buttons use `brand.fill`, not `brand.fg`. This also retires `#F23645`, `#CC1111`, `#FF3E3E`, `#FF5E3E`, `#FF6C32` and `rgba(242,54,69,…)`.

### Semantic
| Token | Hex | Contrast on canvas |
|---|---|---|
| `success` | `#22C55E` | 8.9:1 |
| `warning` / `gold` (rewards, XP) | `#F59E0B` | 9.5:1 |
| `danger.fg` | `#F87171` | 7.4:1 (error text) |
| `danger.fill` | `#E11D2E` (= brand.fill) | destructive buttons; always with a label, never colour only |
| `info` | `#60A5FA` | links in rich text only |

- Rank colours (F→SSS) stay as a dedicated `rank.*` palette, moved from `RankBadge.tsx` into tokens.
- **Removed:** `PRIMARY #5030E5`, `SECONDARY #4069E1`, `BLACK`, `GREY`, `BORDER #E8ECF4`, `BACKGROUND #F7F8F9`, the purple fallback palettes (`#1B1030/#6E38C8`, `#8B5CF6`), and the inline error shades (`#7F1D1D`, `#FCA5A5`, `#4C1D24` …).

## 2. Typography
- Family: **Urbanist** (Regular 400, Medium 500, SemiBold 600, Bold 700), bundled under `src/assets/fonts` (OFL licence).
- Never combine `fontWeight` with `fontFamily`.
- The minimum size anywhere is **12px**.

| Token | Size / line | Weight | Use |
|---|---|---|---|
| `display` | 28 / 34 | Bold | hero titles, auth titles |
| `title` | 22 / 28 | Bold | screen titles, Detail title |
| `heading` | 18 / 24 | SemiBold | section headers, sheet titles |
| `body` | 15 / 22 | Medium | paragraphs, rows |
| `label` | 14 / 20 | SemiBold | buttons, tabs, chips |
| `caption` | 12 / 16 | Medium | meta, badges, timestamps |

- Font scaling: `allowFontScaling` stays on. Set `maxFontSizeMultiplier` to 1.5 on `body` and smaller, and 1.3 on `display`/`title`.
- Cards size to their content (no fixed text heights).
- The numerals in timers and counters use `fontVariant: ['tabular-nums']`.

## 3. Spacing, radius, elevation, layout
- **Spacing (4-pt):**
  - `space.1`=4, `2`=8, `3`=12, `4`=16, `5`=20, `6`=24, `8`=32, `10`=40.
  - Screen gutter: 16. Section gap: 24. Card padding: 12–16.
- **Radius:**
  - `xs` 4: progress bars, badges.
  - `sm` 8: chips, thumbnails.
  - `md` 12: cards, posters, inputs, buttons.
  - `lg` 16: sheets, hero.
  - `full` 999: pills, avatars.
  - This replaces 35 distinct values.
- **Elevation:** a hairline border + bg step only. One shadow, `shadow.sheet`, for bottom sheets.
- **Touch targets:** 48×48dp minimum (use `hitSlop` when the visual is smaller).
- **Icon sizes:** 16 (inline), 20 (chips), 24 (buttons/nav).
- **Poster ratio:** 2:3. Hero: 16:9. Channel banner: 3:1.
- **Grid:** columns = `floor((width − 32 + 12) / (minCard 104 + 12))`. Card width is computed (no `30%` widths).

## 4. Motion
| Token | ms | Easing |
|---|---|---|
| `motion.fast` | 120 | `out(cubic)` |
| `motion.base` | 220 | `inOut(cubic)` |
| `motion.slow` | 320 | `out(cubic)` |
| `motion.spring` | — | damping 18, stiffness 220 |

- Reanimated only.
- `useReducedMotion()` disables scale, confetti and shimmer (falls back to a static `bg.elevated`).

## 5. Components (`src/components/ui/`)
Every component must:
- Use tokens only.
- Set `accessibilityRole` + `accessibilityLabel` (or visible text).
- Expose `testID`.
- Support `disabled` + `loading` where relevant.
- Provide a pressed state.

| Component | Variants / props | Replaces |
|---|---|---|
| `Screen` | `edges`, `scroll`, `refreshing`/`onRefresh`, `offlineBanner` | ad-hoc SafeArea/ScrollView |
| `AppHeader` | `variant: brand \| back \| title`, `title`, `subtitle`, `right[]` (IconButtons), `transparent` (over hero) | `Header` + 8 custom back bars |
| `Wordmark` | `size: sm \| md \| lg` | 5 copies; one spelling, pending Q-01 in [[Redesign-Decision-Log]] |
| `Button` | `primary \| secondary \| ghost \| destructive`; `size: md(48) \| sm(36 + hitSlop)`; `icon`, `loading`, `fullWidth` | 11 button copies |
| `IconButton` | 48dp target, `label` (required, a11y), `badge` | glyph buttons (‹, ✕, ♥, ✎, ⚙) |
| `TextField` | label, leading icon, `secure` (eye toggle), `error`, `helper`, autofill props, `returnKeyType` | 8 auth input copies |
| `Chip` | `filter \| choice \| tag`; selected state announced | genre/sort chips |
| `SegmentedControl` | 2–4 segments | My List, sort toggles |
| `Switch` / `SwitchRow` | role switch, `checked` state, `pending`, description | custom toggles, Profile switches |
| `ListRow` | leading icon, title, subtitle, trailing (chevron/value/switch), `destructive` | menu rows |
| `PosterCard` | 2:3 cover, title (2 lines), meta caption, optional progress, badge (`New`, `Ep N`) | `ManhuaPosterCard`, Favorites card |
| `WideCard` | 16:9 + progress + "Ep N · time left" | Continue Watching cards |
| `HeroCard` | full-bleed, scrim, CTAs | `FeaturedManhuaCard` |
| `Rail` | header (title + See all), horizontal `FlatList`, skeleton, inline error | Home/Detail/Search rails |
| `EpisodeRow` | thumb, title, duration, state (new / in-progress bar / watched ✓) | Detail episode rows |
| `Skeleton` | `box \| text \| poster \| row`, one shared shimmer driver | 3 different skeletons |
| `EmptyState` | icon, title, body, action | 6 copies |
| `ErrorState` | friendly copy, Retry, optional details | dev-copy errors |
| `OfflineBanner` | NetInfo-driven | — (new) |
| `Toast` | `success \| error \| info \| undo(action)` via `react-native-toast-message` (already installed) | — (new) |
| `BottomSheet` | title, content, backdrop, drag to close | modals |
| `ConfirmSheet` | title, body, confirm label, `destructive` | none today |
| `AuthPromptSheet` | `reason` text, Google + Email, `redirectTo`, `onAuthed` replay | dead ends, locked rows |
| `Icon` | one SVG set (`src/components/icons`), outline + filled pairs | 49 inline icons, emoji |
| `ProgressBar` | `value`, `size: xs(3) \| sm(5)`, `color` | 4 bar styles |
| `RankBadge`, `LevelProgress` | tokenised; `max` state | progression widgets |

### Button anatomy
- Height: 48 (md) / 36 (sm).
- Padding: 16 horizontal.
- Radius: `md`.
- Label: `label` token.
- Icon: 20, with 8 gap.
- Primary:
  - Default: `brand.fill` with white text.
  - Pressed: `brand.fillPressed`.
  - Disabled: `bg.elevated` with `text.disabled`.
  - Loading: spinner replaces the label and the width stays the same.

### Input anatomy
- Label: caption, `text.secondary`, sitting above the field.
- Field: 48 tall, `bg.card`, 1px `border.default` (focus → `brand.fg`, error → `danger.fg`).
- Error: helper text below in `danger.fg`, with an alert icon.

## 6. Accessibility rules
- Every touchable must have a label, a role and a state (`selected`, `checked`, `disabled`, `busy`).
- Images: decorative → `accessible={false}`; covers → label = the title.
- Live regions: toasts, level-up and "Up next in 5s" use `accessibilityLiveRegion="polite"` / `announceForAccessibility`.
- Focus order follows visual order. The player controls are grouped.
- Never convey state by colour alone (active tab gets indicator + filled icon; unread gets dot + "Unread" label).
- Test with TalkBack and at font scale 1.3 / 1.5 ([[Redesign-QA-Strategy]]).

## 7. Migration map (existing literal → token)
| Existing | → Token |
|---|---|
| `#F23645`, `#FF3142`, `rgba(242,54,69,*)`, `#CC1111`, `#FF3E3E` | `brand.fg` / `brand.fill` / `brand.tint` |
| `#050507`, `#090909`, `#0A0810` | `bg.canvas` |
| `#0A0B11`, `#0B0C12`, `#10131A`, `#100B1E`, `#0C0D11` | `bg.surface` |
| `#14151A`, `#151824`, `#151320` | `bg.card` |
| `#1C1E24`, `#2A2A32`, `#1C1A28`, `#201B2F` | `bg.elevated` |
| `#D7D8DE`, `#D1D5DB`, `#D4D8E1`, `#C8CDD8`, `#C4C7CE`, `#A8AAB8` | `text.secondary` |
| `#8B909B`, `#9AA0AC`, `#535866`, `#5E616A` | `text.muted` |
| `#FCA5A5`, `#F87171`, `#7F1D1D`, `#4C1D24`, `#210B0E`… | `danger.fg` / `danger` tints |
| `#FBC02D`, `#F5A623`, `#FBBC05` (non-Google) | `warning` |
| `#3B82F6`, `#2D7CFF`, `#5030E5`, `#4069E1`, purples | removed or `info` |
| Font sizes 7–11 | `caption` (12) |
| 13–14 | `label` / `body` |
| 15–16 | `body` |
| 18–20 | `heading` |
| 22–24 | `title` |
| 28–32 | `display` |
| Radius 2/4 | `xs` |
| 7/8/10 | `sm` |
| 12/14 | `md` |
| 16/18/19/20/22 | `lg` |
| 25+/999 | `full` |

Enforcement: an ESLint rule (`no-restricted-syntax` on hex literals in `src/screens/**`) after migration.
