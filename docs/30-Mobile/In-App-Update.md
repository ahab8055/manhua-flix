---
type: module
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [mobile, android, update]
related: ["[[Mobile-MOC]]", "[[ADR-001-android-only-store-driven]]"]
---
# In-App Update (force update)

Decision: [[ADR-001-android-only-store-driven]] — Play Store is source of truth, no backend version table.

- Kotlin `android/app/src/main/java/com/manhuamobile/InAppUpdateModule.kt` + `InAppUpdatePackage.kt`, registered in `MainApplication.kt`. Dep `com.google.android.play:app-update:2.1.0`.
- Module `InAppUpdate`: `checkUpdate()` → `{available, inProgress, availableVersionCode}`; `startImmediateUpdate()` (IMMEDIATE, request 4217). Errors `E_UPDATE_CHECK`, `E_NO_ACTIVITY`, `E_UPDATE_START`.
- JS `src/services/app-update.ts` `checkForUpdate()`: Android, not `__DEV__`, 5s timeout, **fails open**. Available/in-progress → `updateRequired=true` → `ForceUpdateScreen` + immediate flow; fallback `market://details?id=com.manhuamobile` → https.
- Runs at startup + every foreground. Only testable with Play-installed builds (internal testing track).
