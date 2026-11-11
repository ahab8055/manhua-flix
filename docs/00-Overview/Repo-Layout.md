---
type: note
area: overview
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [overview, repo]
related: ["[[Architecture]]", "[[Shared-Config-Packages]]"]
---
# Repo Layout

| Path | What | Notes |
|---|---|---|
| `apps/backend` | API | submodule `ahab8055/manhua-flix-backend` → [[Backend-MOC]] |
| `apps/admin` | admin panel | submodule `ahab8055/manhua-flix-admin` → [[Admin-MOC]] |
| `apps/mobile` | Android app | submodule `ahab8055/manhua-mobile`, Yarn, not in pnpm workspace → [[Mobile-MOC]] |
| `packages/config-*` | shared lint/ts configs | unused → [[Shared-Config-Packages]] |
| `kaggle/` | older worker notebook copies + `gdrive_oauth.py` | → [[Pipelines-MOC]] |
| `colab/` | legacy Colab notebooks | → [[Colab-Notebooks]] |
| `play-store-screenshots/` | store assets + generator | → [[Play-Store-Screenshots]] |
| `docs/` | this vault | → [[Conventions]] |
| `CLAUDE.md`, `.claude/` | Claude rules + Stop hook | |

Submodules: commit inside submodule first, then bump pointer in root (`Update subproject commits…`). Root `cookies.txt` gitignored — never commit.
