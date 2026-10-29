# Phase 1 (Launch) — Levels 1–500 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 1 નો scope (Levels 1–500, launch build), in/out-of-scope features અને Phase 1 docs નો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard](../../SHARED_CORE_STANDARD.md) · [Phase 2 README](../phase_2/README.md) · [Scaling to 10,000](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Scope

| Item | Phase 1 value |
|---|---|
| Levels | **1–500** (bundled `assets/levels/phase_1.json.gz`, offline generator + hand-tuning) |
| Mechanics | **49** (M001–M049), one new at every x1 (L11, 21 … 491) + **L500 Grand Central Finale** |
| Tiers | FTUE (1–10), T1 (11–100), T2 (101–200), T3 (201–300), T4 (301–400), T5 (401–500) |
| Max grid | 11×11 (no zoom; min cell 29 dp) |
| Platforms | Android + iOS, Flutter 3.x / Dart 3, offline-first |
| Languages | English, ગુજરાતી, हिन्दी |

## 2. In Scope (Launch)

- Core rules: tap → exit, bump (−1 heart), locked taps, interactive Moves, Route Peek (01).
- 3 hearts, Second Chance (ad revive 1/level, Heart Refill 120 coins ×2/attempt), stars.
- 3 boosters: **Green Signal Hint (Hint)**, **Cowcatcher Shield (Shield)**, **Track Crane (Hammer)** + free **Route Peek (Path Preview)**.
- Coins economy, **Conductor's Gift Crate** every x0, **Grand Central Chest** L500, **Golden Express Coin Rush** after every 25 levels.
- **Daily Timetable Run** (L15+), weekday modifiers, **Express Streak** 7-day ladder + Streak Saver.
- **Lucky Turntable** (1 free + 1 ad per day, odds disclosed).
- Shop: boosters (single + 3-pack), coin packs IAP, Starter Pack, **VIP Conductor Pass** ₹20/month auto-renewing.
- Ads: interstitial (every 5 wins, rules), rewarded, banners; UMP consent; neutral age gate; Families policy.
- Leaderboards via Play Games / Game Center (Highest Level, Total Stars, Total Streak Days).
- Firebase Analytics, Crashlytics, Remote Config; local Hive save.

## 3. Out of Scope (Phase 2+)

| Feature | Where |
|---|---|
| Levels 501–1000, M051–M099, zoom/pan, ≥ 12×12 boards, diagonal trains | [Phase 2](../phase_2/README.md) |
| Sticker Album (uses daily silhouettes), Weekly Star Race, Piggy Bank, Cloud Sync, cosmetics (train liveries / board themes 800–4,000 coins) | [Phase 2](../phase_2/README.md) |
| Firebase Auth / Firestore backend | Phase 2 |
| Levels 1001–10,000 (on-device generation, variants) | [Scaling doc](../../SCALING_TO_10000_LEVELS.md) |
| Free-running loops / figure-8 circuits | **Never** (only M046 Loop Line Train with its exact rule) |

## 4. Doc Index

| # | Doc | Covers |
|---|---|---|
| 01 | [Game Concept & Rules](./01_GAME_CONCEPT_AND_RULES.md) | Concept, art direction, core loop, all gameplay rules, hearts/revive, stars, edge cases, glossary |
| 02 | [Level Progression 0001–0500](./02_LEVEL_PROGRESSION_0001_0500.md) | Tiers, block pattern, FTUE L1–10, booster tutorials, 50-block table, L500 Finale |
| 03 | [Obstacle Catalog Phase 1](./03_OBSTACLE_CATALOG_PHASE_1.md) | M001–M049 + Finale cards (rules, hammerable, JSON, design usage) |
| 04 | [Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md) | Boosters, Heart Refill, coin flows, Gift Crate, Coin Rush, Lucky Turntable, Shop, ads, compliance |
| 05 | [Daily Challenge & Streak](./05_DAILY_CHALLENGE_AND_STREAK.md) | Daily rules, modifiers, silhouettes, streak, saver, anti-cheat, offline, leaderboards |
| 06 | [UI/UX Screens](./06_UI_UX_SCREENS.md) | Tokens, accessibility, responsive rules, all 18 screens |
| 07 | [Frontend Implementation & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md) | Architecture, BLoCs, renderer, input, ads/IAP, persistence, performance, QA checklist |

## 5. Launch Exit Criteria

- `tools/levelgen validate`: 500/500 levels pass (07 §12).
- QA checklist (07 §13) executed on the device matrix; all blocking items pass.
- Performance budget met (60 fps low-tier, p95 raster < 8 ms mid-tier).
- Store compliance: Families policy, UMP, odds disclosure, subscription disclosure.
