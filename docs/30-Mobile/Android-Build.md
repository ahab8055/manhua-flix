---
type: note
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [mobile, android, build]
related: ["[[Mobile-MOC]]", "[[Play-Store-Release]]"]
---
# Android Build

- `android/build.gradle`: buildTools 36, minSdk 24, compile/target 36, NDK 27.1.12297006, Kotlin 2.1.20, google-services 4.4.2.
- `android/app/build.gradle`: `applicationId com.manhuamobile`, **versionCode 5 / versionName 1.0.4** (as of 2026-11-08), no flavors, proguard off, Hermes.
- Signing: release config from gradle props `MYAPP_UPLOAD_STORE_FILE`, `MYAPP_UPLOAD_STORE_PASSWORD`, `MYAPP_UPLOAD_KEY_ALIAS`, `MYAPP_UPLOAD_KEY_PASSWORD` (`android/gradle.properties` gitignored; template `gradle.properties.example`). Keystore `android/app/upload-keystore.jks` gitignored. **Debug also signed with release config.**
- Environments by `ENVFILE=.env.prod|.env.stage` at bundle time, not flavors.
- Manifest: INTERNET, POST_NOTIFICATIONS; `allowBackup=false`; MainActivity `singleTask`, `adjustResize`.
- Output: `android/app/build/outputs/bundle/release/app-release.aab` (gradle `bundleRelease`; no npm script).
- Bump versionCode + versionName every release → [[Play-Store-Release]].
