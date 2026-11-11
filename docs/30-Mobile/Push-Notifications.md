---
type: module
area: mobile
status: active
created: 2026-11-08
updated: 2026-11-11
tags: [mobile, push]
related: ["[[Mobile-MOC]]", "[[Notifications]]"]
---
# Push Notifications (mobile)

FCM (`@react-native-firebase/messaging`) + notifee. Backend side: [[Notifications]].

- Config `android/app/google-services.json` (plugin applied only if file exists).
- Channel `manhua_notifications` — created natively in `MainApplication.kt` + by notifee; default FCM channel in manifest.
- Topic **`new_releases`** (must match backend `RELEASE_TOPIC`); subscribed for guests too per `release_alerts_enabled` (Profile toggle).
- `setupPushNotifications` (`src/services/push-notifications.ts`): POST_NOTIFICATIONS perm → channel → topic sync → logged in: `getToken` → `POST /notifications/devices` (retry 2/8/30s); logged out: `POST /notifications/devices/unregister` + `deleteToken()`.
- Listeners: `onMessage` → local inbox (skipped when `data.notificationId` set: server inbox has it) + `onInboxChange` (invalidates `queryKeys.notifications.all()`) + notifee display; `onNotificationOpenedApp`, `getInitialNotification`, `onTokenRefresh`, notifee foreground/background (`index.js`).
- `displayRemoteMessage` (`release-notifications.ts`): `data.notificationTitle/Body`, `data.tag` id, imageUrl → BIGPICTURE else BIGTEXT; `chapter_release`/`channel_upload` add actions `read`, `series`.
- Deep links `src/services/notification-deeplink.ts`: broadcast → Notifications; chapter → Episode; `manhuaId` → Detail; `channelId` → ChannelDetail; `series` action → Detail; else Notifications. Navigation retries 40×250ms until ready.
- Unread badge `hooks/use-unread-notifications.ts`: `GET /notifications/unread-count` + unread local inbox items; 0 for guests. Legacy `components/Header.tsx` uses the same hook.

## Inbox screen (Step 13, `screens/app/notifications/`)
- `NotificationsScreen.tsx`: auth-gated (guest EmptyState → AuthPromptSheet); AppHeader back + "Mark all read" (hidden at 0 unread).
- States exclusive: RowSkeletons / ErrorState / EmptyState "You're all caught up". SectionList Today/Yesterday/Earlier (`utils/group-by-day.ts`, shared with My List History). Infinite `usePagedList` 20/page.
- Keys: `queryKeys.notifications.{all,list,local,unreadCount}` (old array key `['notifications','history']` removed). Local inbox exposed as query `useLocalInbox()`.
- `model.ts`: `mergeNotifications` (server + local, drop local copies by `broadcastId`/`notificationId`, hold local items older than loaded server page while more pages), `resolveCategory` (release/channel/comment/favorite/announcement/system → icon), `relativeTime`. Tests `__tests__/model.test.ts`.
- Tap: navigate first, mark read in background (optimistic page patch + count −1). Announcements or payloads resolving to the inbox → BottomSheet with full text. Deep link fails → toast "This content is no longer available".
- Mark all: optimistic (pages, count 0, local inbox), restore + toast on failure.
- ⋯ / long-press → Remove with 5s Undo (`undoableRemove`); server → `DELETE /notifications/:id` (404 = done), local → `removeLocalInboxNotification`.
- No ad slot yet (R-18).
