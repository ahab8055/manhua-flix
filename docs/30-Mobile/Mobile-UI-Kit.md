---
type: module
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-11
tags: [mobile, ui, design-system, a11y]
related: ["[[Mobile-MOC]]", "[[Mobile-Theme]]", "[[Redesign-Design-System]]", "[[Redesign-Roadmap]]"]
---
# Mobile UI Kit

Shared components for the redesign (R-03). Import from `@/components/ui` and `@/components/icons`. Tokens only (`tokens` from `@/theme`), no hex/fontSize literals. Screens adopt the kit in Steps 6–15; legacy `Header`, `AppIcons`, `HeaderIcons` remain until then.

## Components (`src/components/ui/`)
| Component | Use |
|---|---|
| `AppText` | All text. `variant` (display/title/heading/body/label/caption), `tone`, `align`; caps font scale per step |
| `Wordmark` | MANHWA + FLIX brand mark (D-16) |
| `Button` | primary / secondary / ghost / destructive; md 48 / sm 36 (+hitSlop); `icon`, `loading` (keeps width, busy state), `fullWidth` |
| `IconButton` | 48dp icon control; **`accessibilityLabel` required**; `badge`, `variant` plain/filled/overlay, `filled`/`selected` |
| `TextField` | label, icon, error/helper, `secure` (show/hide eye), `onClear` + `clearLabel` (48dp ✕ while text, Step 11); forwards ref + all TextInput props (autofill, returnKeyType) |
| `Chip` | pill (filters) / square (sort, ranges); `selected` announced |
| `SegmentedControl` | tablist/tab roles (My List segments) |
| `Switch`, `SwitchRow` | animated switch, role switch; `pending`, `disabledReason` |
| `ListRow` | settings/menu rows; `value`, trailing chevron/external, `destructive`, `divider` |
| `Skeleton`, `SkeletonLines` | pulse placeholders (static on reduce motion), hidden from a11y |
| `EmptyState`, `ErrorState` | friendly copy + action/Retry; `ErrorState compact` for inline section errors |
| `ProgressBar` | role progressbar, xs/sm |
| `BottomSheet` | Modal + Reanimated slide; backdrop/back close; `dismissible`; no drag yet |
| `ConfirmSheet` | destructive confirm on BottomSheet; `loading` blocks dismiss |
| `Screen` | safe-area + canvas bg; `scroll`, `refreshControl`, `padded`, `header` |
| `AppHeader` | brand / title / back; renders title+subtitle; `right` actions; `transparent` over imagery |

## Feedback & resilience (Step 3)
| Piece | Where | Use |
|---|---|---|
| `toast.success/info/error/undo/hide` | `src/utils/toast.ts` | App-wide toasts, usable outside React. error 4s (+`onRetry`), undo 5s (+`onUndo`), success 2s. One at a time |
| `ToastHost` + `toastConfig` | `src/components/ui/Toast.tsx` | Mounted last in `App.tsx`; sits above tab bar; live-region announced |
| `getFriendlyErrorMessage(err, fallback?)` | `src/utils/error-message.ts` | Axios/unknown → user copy (offline, timeout, 401/403/404/429/5xx, short server `message`). Use in every toast/error state; never show raw errors |
| `OfflineBanner` | `src/components/ui/OfflineBanner.tsx` | Global, mounted in `App.tsx`; non-blocking; "Back online" toast on reconnect |
| `useIsOffline()` | `src/hooks/use-is-offline.ts` | Same source as React Query `onlineManager` |
| `ErrorBoundary` | `src/components/ErrorBoundary.tsx` | Wraps `RootNavigation`; Restart remounts nav, keeps query cache; dev shows message |
| `useRefreshControl(refetchers)` + `AppRefreshControl` | `src/hooks/use-refresh-control.ts`, `src/components/ui/AppRefreshControl.tsx` | Spinner only during user pull; toast if all refetches fail |

Rule for screens (Steps 6–15): every mutation → pending state + `toast.*` result; reversible removes → `toast.undo`; pull-to-refresh → `useRefreshControl` (never OR `isFetching`).

## Media components (`src/components/media/`, Step 7)
- `PosterCard` (2:3, badge, progress), `WideCard` (16:9 resume card + ⋯), `Rail` (header + See all, skeleton, compact error, hides when empty), `HeroCarousel` (paged, 5s auto-advance paused on touch / reduce motion / screen reader), `EpisodeRow` (fixed 76dp, NEW / progress / watched), `ActionChip` (shared by Detail + Episode).

## Icons (`src/components/icons/`)
- `<Icon name size color filled />`, 24-box stroke set in `paths.ts` (~45 icons). Decorative by default; pass `accessibilityLabel` for standalone meaning. `filled` = active/selected state. Step 8 added `settings` (gear), `shield`, `info`; Step 10 `sword`, `bolt`; Step 12 `pin`; Step 15 `thumbDown` (thumb rotated 180°), `reply`, `send`. `utils/format.ts` `formatRelativeTime` (Step 15).
- Media (Step 12): `ChannelRow`, `Avatar` (moved from Profile).
- Media (Step 9): `MyListRow` (16:9 thumb + progress + ⋯, height `MY_LIST_ROW_HEIGHT`); `PosterCard` `onLongPress` + `longPressActionLabel` (TalkBack custom action).

## Rules
- Every interactive kit component sets role + label + state, has `testID`, min 48dp target (`hitSlopFor`).
- Never put white text on `brand.fg`; filled = `brand.fill`.
- Respect reduce motion (`useReducedMotion`).

## Dev gallery
- `src/screens/dev/UiKitScreen.tsx`, route `UiKit` registered only when `__DEV__` (`src/navigation/AppStack.tsx`, lazy `getComponent`). Open via **Dev Menu → "UI Kit"** (Feedback section: toasts, simulate offline, crash button, pull-to-refresh) (`DevSettings.addMenuItem` in `src/navigation/index.tsx`). Excluded from release bundle (verified 2026-11-08).

## Not yet (later steps)
- AuthPromptSheet (Step 4) · persisted query cache (not planned yet) · PosterCard/WideCard/EpisodeRow/Rail (with screens) · sheet drag-to-dismiss.
