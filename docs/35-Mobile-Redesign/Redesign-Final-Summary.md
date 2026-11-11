---
type: note
area: mobile
status: draft
created: 2026-11-08
updated: 2026-11-08
tags: [mobile, redesign, summary]
related: ["[[Mobile-Redesign-MOC]]", "[[Redesign-Dashboard]]", "[[Redesign-Roadmap]]"]
---
# Final Summary

## Verdict
- The app's core idea and visual mood (dark, cover-led, red accent) are good, and match the store listing.
- The problems are reliability and consistency, not aesthetics:
  - Broken or dead-end flows.
  - Silent failures.
  - Missing policy items.
  - A design system that exists only on paper (fonts not bundled, 290 hex literals).
- Fix the foundation and the core watch loop first. The visual polish then follows almost for free.

## Major findings
1. **Policy risk:** no in-app account deletion (the backend already supports it), and a generic privacy policy that omits the SDKs in use.
2. **Core loop breaks:**
   - Auto-play next runs only once.
   - Resume takes 2–3 taps.
   - The WebView-fallback player can't be controlled.
   - Search has no results page.
3. **Dead ends:** 7+ controls do nothing or are hidden for guests. That loses conversion moments (Subscribe, favorite, save search).
4. **No feedback layer:** no toasts, no offline detection, no error boundary; most mutation errors are silent.
5. **Hidden data:** pagination caps (24 favorites, 20 comments, 50 notifications) with totals shown that users can't reach.
6. **Design drift:** Urbanist isn't bundled, 2 reds plus purple leftovers, 28 font sizes, 35 radii, 8 header variants, 11 button variants.
7. **Accessibility:** 11 labels app-wide, targets down to 20dp, text down to 7px.

## Redesign direction
- **Cinematic Dark** with one red, a tokenised system, and a 20-component UI kit ([[Redesign-Design-System]]).
- **IA:** Home first; My List merges Favorites, Continue and History; Settings is split from Profile ([[Redesign-Strategy]]).
- **Watch first:**
  - Hero Play.
  - Detail CTA "Continue Ep N".
  - Sticky player with prev/next, an episodes drawer and persistent auto-play.
- **No dead ends:** an AuthPromptSheet with action replay.
- **Feedback everywhere:** skeletons, toasts with undo, offline banner, friendly errors.

## Roadmap at a glance
- **P0 Foundation:** fonts, tokens, UI kit, toast, offline (~2 weeks).
- **P1 Critical:** delete account, legal, player, search, sign-out, dead ends, pagination (~2 weeks).
- **P2 Screens:** Episode, Detail, Home, nav/My List, Settings/Profile/Auth, channels, notifications (~4 weeks).
- **P3 Polish:** a11y, copy, perf, deep links, splash, update, tests (~1.5 weeks).

Details and acceptance criteria are in [[Redesign-Roadmap]]; validation is in [[Redesign-QA-Strategy]].

## Next steps
1. The user reviews the blueprint and answers the open questions in [[Redesign-Decision-Log]] (Q-01 to Q-09). The most urgent are brand spelling, the Google-only delete path, the privacy URL and the search endpoint.
2. The user approves with: **"I approve the redesign. Start implementation"**.
3. Start P0 (R-01 → R-06), updating each task's status here and in [[Redesign-Dashboard]].
