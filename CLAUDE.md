# manhua-flix

pnpm monorepo. Apps are git submodules:
- `apps/backend` — NestJS + Fastify + Drizzle (Postgres)
- `apps/admin` — Next.js admin panel
- `apps/mobile` — React Native app (**Android only** for now)
- `kaggle/`, `colab/` — video pipelines (YouTube → Google Drive → Dailymotion)
- `play-store-screenshots/` — Play Store assets
- `packages/config-*` — shared eslint/prettier/tsconfig

## Second brain: `docs/` Obsidian vault (MANDATORY)

`docs/` is your persistent project memory. Treat it as part of every task.

**Before work**
1. Read `docs/Home.md`, then the relevant area MOC (`docs/10-Backend/Backend-MOC.md`, etc.) and linked notes.
2. Check `docs/60-Decisions/` for past decisions — don't re-propose rejected approaches.

**After any change, discovery, or decision** (before ending the turn)
1. Update the existing note, or create one from `docs/_templates/` (search first; don't duplicate).
2. Set frontmatter `updated: YYYY-MM-DD`; link the note from its area MOC.
3. New decision or user preference on approach → ADR in `docs/60-Decisions/` + row in `Decisions-MOC.md`.
4. Non-obvious bug root cause → `docs/70-Bugs/`.
5. Append one line to `docs/_meta/Changelog.md` (newest first).
6. Durable user preferences/feedback also go to auto-memory, linking the vault note.

Rules: follow `docs/_meta/Conventions.md`. Terse bullets, cite file paths, `[[wikilinks]]`. **Never write secrets** (keys, tokens, cookies) into docs — env var names only.

A Stop hook (`.claude/hooks/vault-check.sh`) blocks once if code changed after the last docs update.
