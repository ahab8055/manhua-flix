---
type: note
area: overview
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [overview, tooling]
related: ["[[Repo-Layout]]"]
---
# Shared Config Packages

`packages/*` — built by root `build` script but **used by nothing**: admin + backend inline copies in their own `eslint.config.ts` / `prettier.config.ts` / `tsconfig.json` (submodules must build standalone).

| Package | Contents |
|---|---|
| `@manhua-flix/config-eslint` | tsup build; `base` (js+tseslint+prettier, `no-explicit-any: error`, `consistent-type-imports`), `react`, `nestjs` |
| `@manhua-flix/config-prettier` | raw TS: semi, double quotes, width 100, trailingComma all, lf |
| `@manhua-flix/config-typescript` | `base.json`, `nextjs.json`, `nestjs.json` |
