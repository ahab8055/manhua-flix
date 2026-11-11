---
type: module
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [mobile, video, dailymotion]
related: ["[[Mobile-MOC]]", "[[Drive-to-Dailymotion]]"]
---
# Video Playback

`src/components/dailymotion-player-card.tsx`, used by `EpisodeScreen`.

- Native: `react-native-dailymotion-sdk` (GitHub `Dailymotion-Pro-Services/react-native-integration-dailymotion-sdk#main`), `require` on Android only; Maven `mvn.dailymotion.com` in `android/build.gradle`; iOS disabled in `react-native.config.js`.
- Native used when: Android + SDK present + `DAILYMOTION_PLAYER_ID` (`src/config/dailymotion.ts`) + video id resolved (from `dailymotionVideoId` or URL regex `video|embed/video|dai.ly`).
- Params: `startTime`, `mute`, `scaleMode fit`, fullscreen `landscapeLeft`. Ref: play/pause/seekTo/setMute/setSubtitles/setQuality/setPlaybackSpeed.
- Params fixed per `playerKey` (SDK reads them once at creation): `startTime`, `scaleMode fit`, fullscreen `landscapeLeft`. Ref: play/pause/seekTo/setSubtitles/setQuality/setPlaybackSpeed/setFullscreen.

## Since redesign Step 6 (2026-11-08)
- **Props:** `playerHeight`, video fields, `initialPlaybackSeconds`, `onProgressChange` (read via ref — identity changes never re-run effects), `onEnded`, `onBack`, `title`. `showChrome`/`chapter` removed (mockup branch deleted).
- **Native overlay controls** (kit, 48dp, labelled): back · settings · fullscreen; −10s / play-pause / +10s; draggable seek bar (RNGH `Gesture.Pan`, 24dp touch, a11y adjustable). Auto-hide 3s while playing; tap video toggles. Buffering spinner (`onVideoBuffering`/`onVideoPlaying`). Blocker kept **native only**.
- **Settings sheet:** Speed (`Normal (1×)`…), Quality (`Auto`, `720p`…), Captions (`Off`/code) via kit BottomSheet.
- **Fullscreen (in-app, since 2026-11-08):** the SAME native player view grows to window size (no remount/reload); our overlay controls stay (exit button + back button top-left, hardware back exits). Android module `android/app/src/main/java/com/manhuamobile/PlayerFullscreenModule.kt` (`NativeModules.PlayerFullscreen.enter/exit`, registered in `InAppUpdatePackage.kt`) sets `SCREEN_ORIENTATION_SENSOR_LANDSCAPE` + hides system bars (immersive, swipe to reveal); exit restores `UNSPECIFIED` + bars; also restored on unmount. JS: `src/services/player-fullscreen.ts`; card prop `onFullscreenChange` → Episode hides scroll content + top inset. **SDK `setFullscreen` is NOT used** — its dialog shows host controls + Dailymotion logo (D-30). Requires native rebuild (`yarn android`).
- **Errors (debounced, 2026-11-08 fix):** `onPlayerError`, WebView `onError`, or **25s no-sign-of-life timeout** (SDK swallows `onPlayerSetupFailed`) only *report* an error; it becomes visible after a **4s grace** with no playback activity. Any alive event (start, play/playing, time change, WebView `onLoad`) cancels the pending error **and hides a shown one** (self-heal). Reason: SDK fires non-fatal `onPlayerError` (e.g. ads) while video keeps playing → overlay covered a playing video. `onHttpError` dropped (sub-resource noise). WebView navigation allows `/embed/` + `geo.dailymotion.com/player` redirects, blocks other top-level pages. Then → overlay "Video unavailable right now" + Retry (remount via key). No external link (D-30). No source at all → "This episode isn't available yet".
- **WebView fallback:** no blocker; embed's own controls (`controls=true&ui-logo=false&ui-start-screen-info=false&sharing-enable=false&queue-enable=false&queue-autoplay-next=false&start=`); loads **embed URLs only** (never the host watch page; raw `dailymotionVideoUrl` only used to extract the id); `onShouldStartLoadWithRequest` blocks navigation away from `/embed/` (logo/title/ad clicks); embed fullscreen via `allowsFullscreenVideo`. **Limitation:** no progress events → resume/sync don't advance on this path (needs Dailymotion player JS + postMessage; not built).
- `onEnded` → Episode Up Next.

## Episode screen integration
- Logic in `src/screens/app/episode/`: `use-episode-progress.ts` (resume capture, throttled sync, 15s/background/unmount/90% triggers, cache writes — unchanged), `use-rewarded-bonus.ts` (AdMob SSV + claim retry — unchanged; guests → AuthPromptSheet), `use-episode-chapters.ts` (`queryKeys.chapters` shared with Detail → prev/next from any entry point; legacy `next*` params as fallback while loading).
- `navigateToChapter` → `navigation.replace('Episode', …)` built from the `Chapter` object (real title + video ids), so the binge chain never breaks.
- Up Next: shows on first 90% crossing (any user) or `onEnded`; 5s countdown; autoplay persisted MMKV `autoplay_next` (default true, `AUTOPLAY_NEXT_STORAGE_KEY` exported from `EpisodeScreen.tsx`).
- `onProgressChange` → watch progress ([[Points-Progression]]) + continue-watching cache.

## Hosting provider is hidden from users (D-30, 2026-11-08)
- User rule: never show or tell users the videos are hosted on Dailymotion — no "Open in Dailymotion", no links, no branding.
- Code side done: no external-link button; embed-only WebView with branding/sharing/queue params off; navigation away from the embed blocked; no user-visible strings name the provider.
- **Native player branding is configured in Dailymotion Partner HQ** (the player behind `DAILYMOTION_PLAYER_ID`), not in app code: turn off logo/watermark, title & owner info, sharing, "watch on Dailymotion"/endscreen & related videos, and PiP/menu links. Applies to inline and SDK fullscreen.
