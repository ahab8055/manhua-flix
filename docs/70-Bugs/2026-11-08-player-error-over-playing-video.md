---
type: bug
area: mobile
status: fixed
created: 2026-11-08
updated: 2026-11-08
tags: [bug, mobile, video]
related: ["[[Video-Playback]]", "[[Bugs-MOC]]"]
---
# "Video unavailable" overlay shown over a playing video

## Symptom
Episode screen showed "Video unavailable right now" while the video kept playing behind the overlay (reported by user on device, redesign Step 6 branch).

## Root cause
- Dailymotion SDK emits `onPlayerError` for **non-fatal** issues (e.g. ad errors) while content keeps playing; the card treated any error as fatal and showed the overlay immediately.
- Setup timeout (15s) relied only on `onPlayerStart`/`onVideoStart`; if those didn't arrive the timeout fired even with playback running.
- WebView `onHttpError` fires for sub-resources too.

## Fix (`src/components/dailymotion-player-card.tsx`)
- Errors are *reported*, shown only after a 4s grace with no playback activity; timeout raised to 25s and also routed through the grace.
- Any alive event (start, play/playing, time change, WebView `onLoad`) cancels pending errors and clears a shown one (self-heal).
- Dropped `onHttpError`; WebView uses `onLoad` (success only) instead of `onLoadEnd`.

## Lesson
Third-party player error events ≠ playback failure. Gate error UI on absence of progress, not on error events.
