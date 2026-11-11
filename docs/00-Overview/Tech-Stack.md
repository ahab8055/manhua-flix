---
type: note
area: overview
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [overview, stack]
related: ["[[Architecture]]"]
---
# Tech Stack

| Area | Stack |
|---|---|
| Monorepo | pnpm 9 workspace (admin, backend, packages); Node ≥ 20; TS 5 strict |
| Backend | NestJS 10, Fastify 4, Drizzle 0.31 + postgres-js, class-validator, Swagger, firebase-admin, cloudinary, node-mailjet, google-auth-library, bcryptjs |
| Admin | Next.js 15 App Router, React 18, TanStack Query 5, axios, js-cookie, Tailwind 3, lucide-react |
| Mobile | React Native 0.83 (New Arch, Hermes), React 19, React Navigation 7, TanStack Query 5, Zustand 5, MMKV 3, react-hook-form + zod, reanimated 4, Firebase messaging + notifee, google-mobile-ads, Dailymotion SDK, Google Sign-In; Yarn 1 |
| Pipelines | Kaggle notebooks (Python): yt-dlp + Deno, ffmpeg, Google Drive v3, Dailymotion API v2 |
| Hosting | Backend Vercel serverless or Node server; admin `next build/start` |
