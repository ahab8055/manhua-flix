---
type: bug
area: meta
status: open
created: 2026-11-11
updated: 2026-11-11
tags: [bug, security, git, malware]
related: ["[[Bugs-MOC]]", "[[ADR-004-graphify-auto-sync]]"]
---
# Machine compromise: stealer + malicious git hooks

## Symptom
- Found while planning commit-time graphify sync: `.git/hooks/{post-checkout,commit-msg,pre-push}` silently `curl … | sh` a remote script (`cleverstack-*.vercel.app`) on every checkout/commit/push.
- 78 hooks in 26 repos under `~` (Documents, Desktop), all written 2026-06-02 08:32:12–18 PKT.

## Trace (2026-11-11, read-only forensics)
| Time 2026-06-02 PKT | Event |
|---|---|
| 08:27:05 | VS Code first opens `~/Documents/devRock/Healthcare-Medical-Supply-Plan` (non-GitHub git repo, "Medical Supply Web Project" spec docs; folder since deleted) |
| 08:28 | Copilot Chat in that folder — only read docs, ran no commands (not the trigger) |
| 08:31:28 | Copies of Chrome "Login Data" password DBs staged as `~/Library/Application Support/Google/Chrome/ld_*` (6 SQLite files) |
| 08:31:30 | Payload `npm install`s ~300 pkgs into hidden `~/.npm/.vscode/node_modules` (hardhat, ethers, solc, clipboardy, ps-node, archiver, fake `fs`/`crypto`/`child_process`) → crypto-wallet / credential stealer profile |
| 08:31:39 | Persistence: obfuscated JS at `~/Library/Metadata/metadata` + crontab `0 */23 * * * node ~/Library/Metadata/metadata` (runs 00:00 & 23:00 daily) |
| 08:32:12 | Git hooks written into every repo found |
- 2026-10-28 01:26: `~/.npm/.vscode` and `~/Library` dir entries changed again → malware likely still active.

## Root cause
- Most likely: the Healthcare-Medical-Supply-Plan repo (fake client / job "take-home" project pattern) auto-ran code on open (e.g. VS Code `folderOpen` task after workspace trust). Exact file unrecoverable — repo deleted, Chrome history >90 days pruned.
- Ruled out: editor extensions, browser downloads, git clone that morning, Copilot actions. Steam `steamclean` LaunchAgent is genuine (Valve-signed).

## Fix / status
- Open. Nothing removed yet. Containment order: crontab entry → `~/Library/Metadata/metadata` → `~/.npm/.vscode` → Chrome `ld_*` copies → git hooks (quarantine, don't delete — evidence).
- Rotate from clean device: Chrome saved passwords, GitHub/SSH, all `.env` secrets (names in each app's `.env`), Play Console, cloud, any crypto wallets. Consider OS reinstall.
- Avoid checkout/commit/push until hooks removed. Commit-time graphify sync on hold.

## Links
- [[Bugs-MOC]]
