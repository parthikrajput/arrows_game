# Phase 1 — Levels 1–500 (Launch)
> Purpose: Phase 1 (launch build) નો scope, in/out-of-scope features અને Phase 1 docs નો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) · [../phase_2/README.md](../phase_2/README.md) · [../../SCALING_TO_10000_LEVELS.md](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Scope Summary

| Item | Phase 1 value |
|---|---|
| Levels | **1–500**, bundled offline (`assets/levels/phase_1.json.gz`, schema v3) |
| Mechanics | 49 — M001 Wooden Button (L11) … M049 Grand Pincushion Guardian (L491), દર 10 levels એ x1 slot પર એક નવું |
| Finale | L500 "The Grand Quilt" + Grand Sewing Chest (Phase Chest) |
| Boards | 4×4 → 11×11 (no zoom) |
| Boosters | Needle Glow Hint (Hint), Thimble Shield (Shield), Golden Scissors (Hammer) + free Thread Peek (Path Preview) |
| Hearts | 3 per attempt; revive by ad once per level; Heart Refill 120 Coins (max 2/attempt) |
| Backend | No custom backend. Firebase: Analytics, Crashlytics, Remote Config, Cloud Function `verifyPurchase` |
| Platforms | Android 8.0+, iOS 14+, portrait, phones + tablets |
| Languages | English, ગુજરાતી, हिन्दी |

## 2. Features In Scope

| Area | Included |
|---|---|
| Core | Tap/exit/snag rules, Move counter, locked taps, tap priority (layers), Thread Peek, deterministic engine |
| Progression | 500 levels, tiers FTUE–T5, 10-level block pattern, Hard x9, Level Map |
| FTUE | L1–10 tutorials; booster tutorials L3 / L8 / L15 / L25 |
| Economy | Coins, first-clear + ★★★ bonus, 2X Win, Craft Basket (Gift Box), Grand Sewing Chest, Golden Bobbin Rush (Coin Rush), Spinning Wheel (Lucky Spin), Shop |
| Daily | Daily Stitch (unlock L15), weekday modifiers, silhouettes, 7-day streak, Darning Patch (Streak Saver), Thimble Trophy, anti-cheat |
| Social | Leaderboards via `games_services` (Highest Level, Total Stars, Total Streak Days) |
| Monetization | AdMob interstitial / rewarded / banner per standard; IAP coin packs, Starter Pack, VIP No-Ads Pass ₹20/month |
| Compliance | Neutral age gate, UMP consent, Families policy, spin odds disclosure |
| Accessibility | Thread pattern + icon per colour, 48 dp targets, text scale 1.3×, reduce motion |

## 3. Out of Scope (Phase 2 or later)

| Feature | Where |
|---|---|
| Levels 501–1000, M051–M099, pinch-zoom boards ≥ 12×12 | [../phase_2/README.md](../phase_2/README.md) |
| Sticker Album, Weekly Star Race, Piggy Bank (₹49), Cloud Sync, cosmetic thread skins / board themes | Phase 2 |
| Firebase Auth / Firestore | Phase 2 |
| Levels 1001–10,000 (on-device generation) | [../../SCALING_TO_10000_LEVELS.md](../../SCALING_TO_10000_LEVELS.md) |
| Lives / energy system | Never (Retry always free) |
| Real-time timers in puzzles | Never (only Coin Rush 30 s) |
| True over/under thread weaving | Never — overlaps only via M015 / M032 layer mechanics |

## 4. Document Index

| # | Doc | Covers |
|---|---|---|
| 01 | [01_GAME_CONCEPT_AND_RULES.md](./01_GAME_CONCEPT_AND_RULES.md) | Concept, art direction, core loop, all gameplay rules, hearts/revive/fail, stars, edge cases, theme glossary |
| 02 | [02_LEVEL_PROGRESSION_0001_0500.md](./02_LEVEL_PROGRESSION_0001_0500.md) | Tiers, block pattern, FTUE L1–10, booster tutorials, 50-block table, L500 Finale |
| 03 | [03_OBSTACLE_CATALOG_PHASE_1.md](./03_OBSTACLE_CATALOG_PHASE_1.md) | M001–M049 cards (all standard §10 fields, JSON) |
| 04 | [04_BOOSTERS_COINS_SHOP.md](./04_BOOSTERS_COINS_SHOP.md) | Boosters, Heart Refill, Coins in/out, Gift Box, Coin Rush, Lucky Spin, Shop, IAP/VIP, ads, compliance |
| 05 | [05_DAILY_CHALLENGE_AND_STREAK.md](./05_DAILY_CHALLENGE_AND_STREAK.md) | Daily Stitch, modifiers, streak, anti-cheat, offline, leaderboards |
| 06 | [06_UI_UX_SCREENS.md](./06_UI_UX_SCREENS.md) | Design tokens, accessibility, responsive, all 18 screens |
| 07 | [07_FRONTEND_IMPLEMENTATION_AND_QA.md](./07_FRONTEND_IMPLEMENTATION_AND_QA.md) | Architecture, BLoCs, renderer code, input, audio, ads/IAP, persistence, analytics, performance, QA checklist |

## 5. Launch Exit Criteria
1. All 500 levels pass the CI validator ([07 §13](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)).
2. QA checklist ([07 §14](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)) executed on the device matrix with no open blocker.
3. Performance budget met on DM-1 (60 fps, 30 threads).
4. Store compliance: Families policy form, UMP configured, subscription disclosure, spin odds.
