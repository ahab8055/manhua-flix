---
type: note
area: mobile
status: draft
created: 2026-11-08
updated: 2026-11-08
tags: [mobile, redesign, wireframes]
related: ["[[Mobile-Redesign-MOC]]", "[[Redesign-Strategy]]", "[[Redesign-Design-System]]", "[[Play-Store-Screenshots]]"]
---
# Visual References

## Clickable prototype (source of truth for visuals)
- Design canvas: https://claude.ai/artifact/Jw9ugkXM5PPhUDDWcc28JR (private; share from its Share menu).
- 14 phone screens (390×844) in 4 flow rows + Tokens + Components + shared TabBar. Press Play on Home; every screen linked.
- Interactive states: Detail (My List toast + undo, sort, guest tweak → auth sheet), Episode (play/pause, autoplay, episodes drawer, settings sheet, error tweak), Search (idle → typing → results), My List (segments, remove + undo), ChannelDetail (guest sheet, subscribe, alerts, unsubscribe confirm), Settings (dependent switches, logout confirm), DeleteAccount (3 steps), Login (password eye, error), SignUp (consent), Forgot (sent state), Notifications (mark all read).
- Review loop: user comments on canvas → revise → repeat until mobile flow approved → coding ([[Redesign-Decision-Log]] D-18).

## Current-state references
- Play Store marketing screenshots: `play-store-screenshots/phone/01-home.png` … `08-community.png` ([[Play-Store-Screenshots]]). Their look is what we're aiming for: near-black, red accent, bold Urbanist, cover-led cards.
- Gap: the screenshots show elements that don't exist in the app (Share chip on the player, "Up Next autoplay", consistent fonts). The redesign closes that gap, so the store listing stops overpromising.

## Wireframes (360dp wide, ASCII)
Legend:
- `[▶ Play]` primary button.
- `( )` secondary or ghost button.
- `▒` image.
- `━` progress bar.
- `⋯` overflow menu.

### Home
```
┌──────────────────────────────────┐
│ MANHWAFLIX                 🔔(3) │ AppHeader brand
├──────────────────────────────────┤
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│ HeroCard 16:9 + scrim
│▒ Tomb Raider King              ▒│
│▒ Action · Fantasy · 400 eps     ▒│
│▒ [▶ Play]  ( + My List )        ▒│
│            • ○ ○ ○ ○             │
│ Continue Watching          See all›│
│ ┌▒▒▒▒▒▒▒▒┐ ┌▒▒▒▒▒▒▒▒┐ ┌▒▒▒        │ WideCard
│ │━━━━──── │ │━━────── │           │
│ └Ep 12·8m┘ └Ep 3·15m┘            │
│ New Episodes               See all›│
│ ┌▒▒┐┌▒▒┐┌▒▒┐┌▒▒                    │ PosterCard 2:3
│ │NEW││  ││  ││                     │
│ Title Title Title                 │
│ ┌────────── Ad (inline) ────────┐ │
│ Recently Added · Popular …        │
├──────────────────────────────────┤
│ ⌂Home  ⌕Search  ♥My List  ◎Ch  ☺Me│ indicator on active
└──────────────────────────────────┘
```

### Detail
```
┌──────────────────────────────────┐
│ ←                        ⇪  🔔    │ transparent header over cover
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│
│ ┌▒▒▒┐ Tomb Raider King            │
│ │▒▒▒│ Action · Fantasy            │
│ └▒▒▒┘ 400 episodes · Ongoing      │
│ [▶ Continue Ep 12           ]     │ full-width primary
│ (♥ My List) (👍 2.1K) (⇪) (💬 312) │ labelled icon chips
│ Synopsis… 3 lines        More     │
│ ┌ Episodes ┐  About               │ tabs (Episodes first)
│ Sort: Oldest ▾   1–50 51–100 …  #│ range chips + jump
│ ┌▒▒┐ Ep 1 · The Tomb      ✓ 21m  │ EpisodeRow watched
│ ┌▒▒┐ Ep 2 · Gold Dragon  ━━──    │ in progress
│ ┌▒▒┐ Ep 3 · …                    │ virtualized
│ Comments (312)       View all ›   │ preview 3
└──────────────────────────────────┘
```

### Episode
```
┌──────────────────────────────────┐
│▒←▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒⚙ ⛶▒│ sticky player 16:9
│▒    ⟲10     ▶     10⟳          ▒│
│ 07:42 ━━━━━━━●────────── 20:15   │ draggable 24dp
├──────────────────────────────────┤
│ Ep 2 · Chapter 21–40             │
│ S-Class Hunter Heals…  ›         │ series link
│ (⏮ Prev)            (Next ⏭)     │
│ (♥) (👍 2.1K) (⇪ Share) (☰ Eps)  │ ☰ opens Episodes drawer
│ ┌ Up Next ──── Autoplay [on] ──┐ │
│ │ ▒▒ Ep 3 · Chapter 41–60  ◔5s │ │ ring countdown
│ │ [▶ Play now]     (Cancel)    │ │
│ └──────────────────────────────┘ │
│ ┌ 🎁 Bonus +50 XP  (Watch ad) ┐  │ auth only
│ Synopsis… More                   │
│ Comments preview                 │
└──────────────────────────────────┘
Error overlay: [ ⚠ Video unavailable ] [Retry] (Open in Dailymotion)
```

### My List
```
┌──────────────────────────────────┐
│ My List                          │
│ [Continue | Favorites | History] │ SegmentedControl
│ 42 titles           Sort: Recent▾│
│ ┌▒▒┐┌▒▒┐┌▒▒┐                       │ infinite grid
│ Title⋯ Title⋯ Title⋯              │ ⋯ → Remove (Undo toast)
└──────────────────────────────────┘
History segment: Today / Yesterday / Earlier groups, swipe ⋯ remove, (Clear all)
Guest: [♥ icon] "Sign in to save your list" [Continue with Google] (Use email)
```

### Search
```
┌──────────────────────────────────┐
│ ⌕ Search titles…             ✕  │ sticky
│ (All)(Action)(Romance)(Isekai)… │ genre chips
├──────────── typing ──────────────┤
│ ⌕ Search for "hunter"        ↵  │
│ ▒ S-Class Hunter Heals…          │ in-flow suggestions
├──────────── results ─────────────┤
│ 23 results  (Genre▾)(Status▾)(Sort▾)│
│ ┌▒▒┐┌▒▒┐┌▒▒┐ …                    │
└──────────────────────────────────┘
```

### Profile + Settings
```
Profile                              Settings
┌─────────────────────────────┐     ┌─────────────────────────────┐
│ (avatar✎)  Ahab             │     │ ← Settings                  │
│ @ahab · [A] Rank · Lv 12    │     │ NOTIFICATIONS               │
│ ━━━━━━━──── 340 XP to Lv 13 │     │  Push notifications   [on]  │
│ ▸ Stats (collapsible)       │     │  New releases         [on]  │
│ ♥ My List               ›   │     │  Channel alerts         ›   │
│ 🔔 Notifications        ›   │     │ PLAYBACK                    │
│ ⚙ Settings              ›   │     │  Auto-play next       [on]  │
└─────────────────────────────┘     │ ACCOUNT                     │
                                    │  Change password        ›   │
                                    │  Delete account (red)   ›   │
                                    │ ABOUT                       │
                                    │  Privacy · Terms · Licences │
                                    │  Contact support · Rate app │
                                    │  Version 1.0.4 (5)          │
                                    │ (Log out)                   │
                                    └─────────────────────────────┘
```

### Auth (Login)
```
┌──────────────────────────────────┐
│ ←                                │
│ MANHWAFLIX                       │
│ Welcome back                     │ display
│ Sign in to sync your list & XP   │
│ [ G  Continue with Google      ] │ first
│ ───────────── or ─────────────── │
│ Email                            │
│ [✉ you@example.com             ] │
│ Password                Forgot?  │
│ [🔒 ••••••••               👁 ]  │
│ [        Sign in               ] │
│ New here? Create account         │
└──────────────────────────────────┘
```

### Overlays
```
AuthPromptSheet                  ConfirmSheet (destructive)
┌──────────────────────────┐     ┌──────────────────────────┐
│ ─── (grabber)            │     │ Remove from My List?     │
│ Sign in to subscribe     │     │ "Tomb Raider King" will  │
│ Get alerts when X uploads│     │ be removed.              │
│ [G Continue with Google] │     │ [ Remove ] (red)         │
│ ( Use email )            │     │ ( Cancel )               │
│ Not now                  │     └──────────────────────────┘
└──────────────────────────┘
Toast:  ┌ ✓ Removed "Tomb Raider King"   UNDO ┐  (bottom, above tab bar)
Offline:┌ ⚠ You're offline — showing saved content ┐ (top banner)
```

## Component anatomy
```
PosterCard (width w, 2:3)          EpisodeRow (h ≥ 64)
┌──────────┐                       ┌──────┐ Ep 2 · Gold Dragon     ✓
│▒▒▒▒▒▒▒▒▒▒│ radius md            │ 16:9 │ 21 min · 3 days ago
│▒▒ [NEW] ▒│ badge caption        └──────┘ ━━━━━━──── (if progress)
│▒━━━━──── │ ProgressBar xs (opt)
└──────────┘
Title max 2 lines (body/label)
Ep 12 · Action (caption, muted)
```

## Mockup tooling (optional, after approval)
- High-fidelity mockups can be produced as a published HTML artifact or a Figma file once the direction is approved. ASCII stays the source of truth for structure.
