---
type: note
area: release
status: active
created: 2026-11-08
updated: 2026-11-08
tags: [release, screenshots]
related: ["[[Release-MOC]]"]
---
# Play Store Screenshots

`play-store-screenshots/` — HTML mockups rendered headless Chrome, not device captures.

## `_generator/`
- `shot.html?d=<phone|tab7|tab10>&n=<1..8>` — recreated app UI (dark, red accent, Urbanist) in device frame + caption + optional floats (`rank`, `upnext`, `continue`, `notif`). Sets `body.dataset.ready` when fonts loaded.
- `data.js` — `window.M` (22 manhua), `window.C` (5 channels), `window.G` genres.
- `render.sh device n` — Chrome `--headless=new --force-device-scale-factor=2 --screenshot`. **Hardcodes old scratchpad paths — edit before rerun.** `img/` covers missing from repo.
- `sheet.py dev [divisor]` — PIL contact sheet preview.

## Shots
1 home "Watch manhua animated" · 2 detail "Binge every chapter" · 3 profile/rank "Rank up from F to SSS" · 4 episode "Smooth HD player" · 5 search · 6 favorites · 7 channels · 8 comments.

## Outputs (8 PNGs each, `01-home` … `08-community`)
| Folder | Size |
|---|---|
| `phone/` | 1080×1920 |
| `tablet-7in/` | 1440×2560 |
| `tablet-10in/` | 2560×1440 landscape |
