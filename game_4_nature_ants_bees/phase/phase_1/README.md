# Phase 1 — Launch Scope, Levels 1–500 (ફેઝ 1)
"Ants & Bees: Garden Trails" ના launch release (L1–500) નો scope, in/out features અને Phase 1 docs નો index.

**Related docs:** [Game README](../../README.md) · [Shared Core Standard](../../SHARED_CORE_STANDARD.md) · [Phase 2](../phase_2/README.md) · [Scaling to 10,000](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Scope Summary (સારાંશ)

| Item | Phase 1 value |
|---|---|
| Levels | **1–500** (bundled `assets/levels/phase_1.json.gz`) |
| Mechanics | **49** (M001–M049 at L11, 21 … 491) + **L500 Queen's Garden Gala** finale |
| Layers | Ants (ground) L1+; **Bees (air) L41+** (M004 slot); Key & Lock L321 (M032 slot) — Standard §10 exception |
| Max grid | 11×11 (no zoom) |
| Boosters | Nectar Glow Hint, Queen's Royal Shield, Leaf Blower + free Scent Trail Preview |
| Platforms | Android + iOS, portrait, phones 16:9–21:9 + 4:3 tablets |
| Languages | English, ગુજરાતી, हिन्दी |

## 2. Features In Scope (સમાવિષ્ટ)

- Core rules + **layer rule** (ants never collide with bees; tall obstacles block both) — [01](./01_GAME_CONCEPT_AND_RULES.md)
- 500 levels: FTUE L1–10, 10-level block pattern, Hard x9, Gift Box x0 — [02](./02_LEVEL_PROGRESSION_0001_0500.md)
- 49 mechanics + finale, CI validator — [03](./03_OBSTACLE_CATALOG_PHASE_1.md)
- Hearts (3), ad revive (1/level), Honey Heart Refill (120, max 2/attempt), stars
- 3 boosters, coins, Queen's Gift Box, Royal Honey Chest, Golden Nectar Rush, Sunflower Spin, Shop, Starter Pack, Beekeeper VIP Pass (₹20/month) — [04](./04_BOOSTERS_COINS_SHOP.md)
- AdMob interstitial / rewarded / banner with Families + UMP compliance, neutral age gate — [04 §11–12](./04_BOOSTERS_COINS_SHOP.md)
- Daily Garden Almanac (L15+), weekday modifiers, 7-day streak, Queen's Favor saver, anti-cheat — [05](./05_DAILY_CHALLENGE_AND_STREAK.md)
- Leaderboards: Highest Level, Total Stars, Total Streak Days (`games_services`)
- All screens (Splash → Phase Complete) — [06](./06_UI_UX_SCREENS.md)
- Offline play (levels, daily, spin), Hive save, Firebase Analytics / Crashlytics / Remote Config — [07](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

## 3. Out of Scope (Phase 2 અથવા પછી)

| Feature | Where |
|---|---|
| Levels 501–1000, M051–M099, pinch-zoom/pan, diagonal lines | [Phase 2](../phase_2/README.md) |
| Sticker Album (milestone-based volumes + separate Daily silhouettes page), Weekly Star Race, Piggy Bank | Phase 2 |
| Firebase Auth + Cloud Sync, Firestore | Phase 2 |
| Cosmetics (board themes, insect skins, 800–4,000 coins) | Phase 2 |
| Levels 1001–10,000 (on-device generation) | [Scaling](../../SCALING_TO_10000_LEVELS.md) |
| Dark theme, landscape orientation | Not planned for Phase 1 |
| Custom backend leaderboards, real-time multiplayer | Not planned |

## 4. Doc Index (દસ્તાવેજ સૂચિ)

| # | Doc | Covers |
|---|---|---|
| 01 | [Game Concept & Rules](./01_GAME_CONCEPT_AND_RULES.md) | Concept, art direction, core loop, layer rule, tap/exit/bump/win, moves, locked taps, tap priority, preview, hearts/revive/fail, stars, edge cases, glossary |
| 02 | [Level Progression 1–500](./02_LEVEL_PROGRESSION_0001_0500.md) | Tiers, block pattern, layer schedule & swap, FTUE L1–10, booster tutorials, 50-row block table, reward order, L500 finale |
| 03 | [Obstacle Catalog Phase 1](./03_OBSTACLE_CATALOG_PHASE_1.md) | Summary table + 49 cards (Ants/Bees/Tall fields, JSON) + finale + CI rules |
| 04 | [Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md) | Boosters, Heart Refill, inflow/outflow, Gift Box, Rush, Spin, Shop catalog, ads, compliance |
| 05 | [Daily Challenge & Streak](./05_DAILY_CHALLENGE_AND_STREAK.md) | Daily rules, modifiers, seed, silhouettes, streak, saver, anti-cheat, offline, leaderboards |
| 06 | [UI/UX Screens](./06_UI_UX_SCREENS.md) | Tokens, accessibility, responsive, 18 screens with wireframes |
| 07 | [Frontend Implementation & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md) | Architecture, BLoCs, renderer code, input, audio, ads/IAP, persistence, analytics, perf, QA checklist, validator |

## 5. Launch Exit Criteria (રિલીઝ માપદંડ)
- QA checklist ([07 §13](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)) ના બધા items run થઈ pass (હાલ બધા "Not run").
- CI validator 500/500 levels pass, daily seeds pre-validated.
- Performance budget device matrix પર પૂરો (60 fps low-tier, 120 fps ProMotion, raster p95 < 8 ms).
- Store compliance: Families policy, UMP, Spin odds disclosure, subscription wording "while active".
