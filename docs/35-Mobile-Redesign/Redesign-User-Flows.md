---
type: note
area: mobile
status: draft
created: 2026-11-08
updated: 2026-11-08
tags: [mobile, redesign, flows, mermaid]
related: ["[[Mobile-Redesign-MOC]]", "[[Redesign-Strategy]]", "[[Mobile-Navigation]]"]
---
# User Flows

Red nodes = current pain points (issue IDs from [[Redesign-UI-UX-Audit]]).

## 1. Resume watching
**Current: 3 taps, chain breaks**
```mermaid
flowchart LR
  A[Home] -->|tap Continue card| B[Detail]:::bad
  B -->|Details tab → Continue card / Episodes tab| C[Episode]
  C -->|auto-play next| D[Episode N+1]
  D -.->|no next params| X[Dead end: no Next, no Up Next]:::bad
  classDef bad fill:#4c1d24,stroke:#FF3142,color:#fff
```
**Improved: 1 tap, endless chain**
```mermaid
flowchart LR
  A[Home / My List → Continue] -->|tap| C[Episode at saved position]
  C -->|Up Next 6s or Next| D[Episode N+1]
  D -->|chapters cache drives next/prev| E[Episode N+2 …]
  C -->|Episodes drawer| F[Any episode]
```

## 2. Discover → watch
```mermaid
flowchart TD
  H[Home hero] -->|▶ Play| EP[Episode 1]
  H -->|tap card| DT[Detail]
  DT -->|▶ Continue Ep N primary CTA| EP2[Episode N]
  DT -->|Episodes tab first, sort, jump| EP3[Episode k]
  S[Search results] --> DT
  CH[ChannelDetail uploads] --> DT
```

## 3. Search
**Current**
```mermaid
flowchart LR
  T[Type query] --> SG[6 suggestions dropdown, top:120]:::bad
  T -->|press Search key| N[Nothing happens: history saved only]:::bad
  classDef bad fill:#4c1d24,stroke:#FF3142,color:#fff
```
**Improved**
```mermaid
flowchart LR
  T[Type] --> SG[In-flow suggestions + 'Search for q']
  SG -->|tap title| DT[Detail]
  SG -->|Search for q / submit| R[Results grid, infinite]
  R --> F[Filter chips: Genre · Status · Sort]
  R -->|0 results| E[Empty: clear filters / popular]
  R -->|error| ER[ErrorState + Retry]
```

## 4. Guest → account (gated action)
**Current: dead ends**
```mermaid
flowchart TD
  G[Guest] --> P[Profile locked row]:::bad --> N1[No-op]:::bad
  G --> CD[ChannelDetail] --> N2[No Subscribe button]:::bad
  G --> SR[Search 'Sign in to save'] --> N3[No button]:::bad
  G --> FV[Favorites tab] --> L[Login] --> PF[Profile tab, not back to Favorites]:::bad
  classDef bad fill:#4c1d24,stroke:#FF3142,color:#fff
```
**Improved: AuthPromptSheet + action replay**
```mermaid
sequenceDiagram
  actor U as Guest
  participant S as Any screen
  participant A as AuthPromptSheet
  participant L as Google / Email
  U->>S: tap Subscribe / ♥ / Comment / Reward
  S->>A: open(reason, redirectTo, pendingAction)
  alt Google
    A->>L: Google sign-in
  else Email
    A->>L: Login screen (redirectTo)
  end
  L-->>S: back to origin screen
  S->>S: replay pendingAction
  S-->>U: Toast "Subscribed to X"
```

## 5. Notification → content
```mermaid
flowchart LR
  P[Push tap] --> R{resolve payload}
  R -->|chapter| EP[Episode]
  R -->|manhua| DT[Detail]
  R -->|channel| CD[ChannelDetail]
  R -->|fail| T[Toast 'Content unavailable' + Notifications list]
  NL[Notifications row tap] -->|navigate immediately, mark read in bg| R
```

## 6. Share / deep link (new)
```mermaid
flowchart LR
  S[Share on Detail/Episode] --> U["https://<domain>/m/:slug (?ep=n)"]
  U -->|app installed, verified App Link| A[Detail / Episode]
  U -->|not installed| W[Web landing → Play Store]
```

## 7. Account management & deletion request (D-19)
```mermaid
flowchart TD
  ST[Settings → Account → Delete account] --> EX[Step 1: what gets deleted, reviewed within 7 days]
  EX --> TY[Step 2: type DELETE — all account types]
  TY --> API["POST /account-deletion-requests/me"]
  API --> DIS[Account isActive=false, status pending_deletion, tokens + push revoked]
  DIS --> OUT[Step 3: Request received → signOut → Home as guest]
  DIS --> ADM[Admin: delete-account-requests page]
  ADM -->|approve| DEL[Hard delete all user data → email user]
  ADM -->|reject| REA[Reactivate account → email user]
  LOGIN[User tries to sign in while pending] --> MSG[“Deletion pending” message — no cancel]
```

## 8. Logout & session expiry
```mermaid
flowchart LR
  LO[Settings → Log out] --> C[ConfirmSheet] --> CL[clear store + query cache + push token] --> H[Home guest]
  RF[401 + refresh fails] --> CL2[same clear routine] --> TS[Toast 'Session expired, sign in again'] --> H
```

## 9. Onboarding (first launch)
- **Current:** splash goes straight to Home. No orientation.
- **Proposed (minimal):** splash → Home. Add a one-time dismissible coach card on Home: "Tap ▶ to watch · ♥ to save · earn XP by watching". No forced signup, no multi-screen carousel (rejected in [[Redesign-Product-Gaps]]).
