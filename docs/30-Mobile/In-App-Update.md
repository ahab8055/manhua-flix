---
type: module
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-11
tags: [mobile, android, update]
related: ["[[Mobile-MOC]]", "[[ADR-001-android-only-store-driven]]"]
---
# In-App Update (force update)

Decision: [[ADR-001-android-only-store-driven]] — Play Store is source of truth, no backend version table.

- Kotlin `android/app/src/main/java/com/manhuamobile/InAppUpdateModule.kt` + `InAppUpdatePackage.kt`, registered in `MainApplication.kt`. Dep `com.google.android.play:app-update:2.1.0`.
- Module `InAppUpdate`: `checkUpdate()` → `{available, inProgress, availableVersionCode}`; `startImmediateUpdate()` (IMMEDIATE, request 4217). Errors `E_UPDATE_CHECK`, `E_NO_ACTIVITY`, `E_UPDATE_START`.
- JS `src/services/app-update.ts` `checkForUpdate()`: Android, not `__DEV__`, 5s timeout, **fails open**. **Since Step 21 (D-15):** release priority ≥ `BLOCKING_PRIORITY` (4) or immediate in progress → `updateRequired=true` → `ForceUpdateScreen` + immediate flow; lower priority → FLEXIBLE background download once per session (`startFlexibleUpdate`), `InAppUpdateStatus` events (`DOWNLOADING`/`DOWNLOADED`/`FAILED`/`CANCELED`) → store `updateReady` + toast → `components/UpdateReadyBanner.tsx` (floating above tab bar, **Restart** = `completeUpdate()`, ✕ hides for the session). Already-downloaded update on launch → banner straight away.
- Native `InAppUpdateModule.kt`: `checkUpdate` returns `available`, `inProgress`, `immediateAllowed`, `flexibleAllowed`, `downloaded`, `priority`, `availableVersionCode`; `startImmediateUpdate`, `startFlexibleUpdate`, `completeUpdate`.
- **Setting priority:** Play Console UI can't; use Play Developer API `inAppUpdatePriority` on the track release (0–5, default 0 = flexible) or fastlane `supply(in_app_update_priority: 5)`. Test via internal testing track (not sideloads).
- Older legacy behaviour (pre-Step 21): fallback `market://details?id=com.manhuamobile` → https (`openPlayStore`, exported).
- `ForceUpdateScreen` (Step 16): Wordmark, kit card, **Update now** shows loading while `startImmediateUpdate()` runs; if still on screen afterwards → hint to use Google Play; secondary **Open Google Play**. Hardware back blocked.
- Runs at startup + every foreground. Only testable with Play-installed builds (internal testing track).
