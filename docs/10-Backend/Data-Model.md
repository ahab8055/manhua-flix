---
type: note
area: backend
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [backend, db]
related: ["[[Backend-MOC]]"]
---
# Data Model

Drizzle models `apps/backend/src/db/models/*.ts`, re-exported by `src/db/schema.ts`. **No pgEnums, no `relations()`** — enum-like values are varchar + TS unions. PK `serial id`; timestamps without tz, `defaultNow()`. FK delete = cascade unless noted.

## Content
- **manhuas**: title, slug (unique), channel_id→channels (set null), description, cover_url, title_image_url, author, status (`ongoing|completed|hiatus|dropped`), total_chapters, view/like/dislike/favorite counts, genres jsonb string[], is_published, is_featured, featured_order
- **chapters**: manhua_id, chapter_number (unique per manhua), title, dailymotion_video_url/_id/_embed_url, page_urls jsonb[], is_published
- **genres**: name, slug (unique)
- **channels**: name, handle, description, avatar_url, banner_url, uploader_user_id (set null), verified, subscriber_count
- **channel_owners** (channel_id, user_id unique), assigned_by_user_id
- **channel_subscriptions** (channel_id, user_id unique), notifications_enabled, pinned_order, pinned_at
- **channel_upload_notifications** (subscription_id, manhua_id unique), read_at

## Users & engagement
- **users**: full_name, email/username unique, password_hash, role (`user|uploader|admin`), is_active, moderation_status (`active|restricted|suspended`) + reason/updated_at, points, level, rank ('F'), hp/mp/atk/def/luck, total_chapters_read, total_manhwas_read, avatar_url
- **favorites**, **manhua_likes**, **manhua_views** — unique (user, manhua)
- **comments**: parent_comment_id self-FK; **comment_reactions** (comment, user unique) like/dislike
- **watch_progress** (user, manhua unique): chapter_id, progress_percentage numeric(5,2), progress_seconds, last_read_at
- **watch_history** (user, chapter unique): chapter_id **no FK**, progress_percentage **text**
- **search_history** (user, normalized_query unique), search_count
- **chapter_completions** (user, chapter unique), points_awarded
- **account_deletion_requests**: user_id (set null), email, username, reason, status `pending|completed|rejected`, admin_note, processed_by. In-app requests set `users.moderation_status='pending_deletion'` + `is_active=false` ([[Account-Deletion]])

## Ads & progression
- **ad_rewards**: external_reward_id unique, provider, placement_id, points_awarded
- **ad_events**: ad_type, event_type, placement_id, metadata jsonb
- **progression_config** single row: points_chapter_completion 10, points_rewarded_ad 5, rewarded_ad_daily_limit 5, require_ad_ssv false, completion_threshold_percent 90, level_base_threshold 100, level_growth_per_level 25, rank_thresholds `F:0,E:100,D:250,C:1000,B:2500,A:5000,S:8000,SS:12000,SSS:20000`, rpg base/growth/divisor cols
- **progression_events**, **rank_progression_history** — audit, unique per source

## Notifications
- **device_push_tokens**: token unique, provider fcm, platform, app_version, is_active, failure_count
- **notification_preferences** (user unique): push/channel_uploads/channel_subscriptions/engagement enabled
- **notification_broadcasts**: title, body, event_type, target_type, target_config jsonb
- **push_notification_deliveries**: status pending…, attempt_count, max_attempts 3, next_attempt_at, broadcast_id, device_token_id

## Pipeline
- **colab_jobs**: kind (`legacy|youtube_to_drive|drive_to_dailymotion`), parent_job_id self, status (`pending|running|done|failed|paused`), youtube_url, quality, playlist fields, drive_* fields, drive_files jsonb, split_hours/minutes (1/55), start_part_number, resume_at_seconds, dailymotion_channel/tags, result_urls jsonb, progress_*, log_tail, claimed_at
- **youtube_cookies** single row id=1: cookies_txt, cookie_count, expires_at

## Migrations `apps/backend/drizzle/`
49 SQL (`0000_thick_mimic` … `0048_colab_jobs_log_tail`). Later ones hand-written (`ADD COLUMN IF NOT EXISTS`). **Snapshots missing for 0046–0048** → `drizzle-kit generate` may re-diff. `drizzle.config.ts`: schema `./src/db/models/*.ts`, out `./drizzle`.
