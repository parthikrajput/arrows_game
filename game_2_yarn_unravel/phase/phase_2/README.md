# Phase 2 — Levels 501–1000 + LiveOps
> Purpose: Phase 2 (Levels 501–1000 અને LiveOps features) નો scope, Phase 1 થી શું નવું છે, release prerequisites (backend સહિત) અને Phase 2 docs નો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) (§9 Phases, §10 M051–M099, §12 Pipeline, §13 Tech, §14 Save) · [../phase_1/README.md](../phase_1/README.md) · [../../SCALING_TO_10000_LEVELS.md](../../SCALING_TO_10000_LEVELS.md)

> **Source of truth:** બધા rules, numbers, prices અને mechanic IDs [SHARED_CORE_STANDARD](../../SHARED_CORE_STANDARD.md) મુજબ. Phase 1 ના બધા rules ([../phase_1/01](../phase_1/01_GAME_CONCEPT_AND_RULES.md)) Phase 2 માં પણ યથાવત લાગુ પડે છે; આ folder ફક્ત **ઉમેરા** વર્ણવે છે.

---

## 1. Scope Summary

| Item | Phase 2 value |
|---|---|
| Levels | **501–1000**, bundled offline (`assets/levels/phase_2.json.gz`, schema v3) |
| Onboarding | **L501–510**: pinch-zoom + pan tutorial, 12×12 boards, કોઈ નવું mechanic નહીં |
| Mechanics | 49 — **M051 Bias-Cut Thread (L511) … M099 Master Jewel Clasp (L991)**, દરેક block ના x1 slot પર એક નવું |
| Finale | **L1000 "The Heirloom Tapestry"** — Wandering Pincushion Guardian (M098) + ≥ 10 mixed mechanics + Grand Sewing Chest (Phase Chest) |
| Tiers | **P2-A** (501–750) 10×10–13×13 · **P2-B** (751–1000) 12×12–14×14 |
| Boards | ≥ 12×12 પર pinch-zoom + pan, auto-fit start |
| LiveOps | Scrapbook Sticker Album · Weekly Star Race · Knitted Piggy Bank · Cloud Sync · Cosmetic Shop |
| Backend | Firebase **Auth** (anonymous → Google/Apple link), **Cloud Firestore**, **Cloud Functions** (+ Phase 1 નું Analytics/Crashlytics/Remote Config/`verifyPurchase`) |
| Boosters | યથાવત: Needle Glow Hint (Hint), Thimble Shield (Shield), Golden Scissors (Hammer) + free Thread Peek (Path Preview) |
| Release gate | Remote Config `maxPhase = 2` (app update + flag) |

## 2. What's New vs Phase 1

| Area | Phase 1 | Phase 2 addition |
|---|---|---|
| Directions | `U, D, L, R` | + diagonal `UL, UR, DL, DR` (M051 થી) |
| Layers | max 2 (M032) | max **3** (M069 Triple Fabric Layers) |
| New object classes | static / toggle / counter | **Push objects** (Bobbin Crate M053, Satin Glide M054, Dock Plate M055) અને **beams** (Sewing Lamp M084, Sun-Catcher M085, Vanity Mirror M086, Crystal Bead Prism M089) |
| Board view | fit-only, max 11×11 | pinch-zoom + pan, max 14×14 |
| Economy | Craft Basket 150–300 | Phase 2 Craft Basket **300** (L510–990) · L1000 Grand Sewing Chest · Golden Bobbin Rush 30 threads · cosmetics **800–4,000** Coins sink · Piggy Bank ₹49 |
| Meta | Daily Stitch, streak, leaderboards | + Sticker Album, Weekly Star Race, Piggy Bank, Cosmetic Shop |
| Save | local Hive only | + `album`, `piggy`, `cosmetics`, `syncQueue`, `race`, `account` (§17.37; `ageBand` device-local, never synced) + Firestore cloud save |
| Online | ads / IAP / leaderboards | + Star Race, cloud sync, account link |

Unchanged (standard): hearts 3, revive rules, stars, booster effects/caps/prices, clear coins (15/20/30/50), ★★★ +20, Daily Stitch + streak ladder, Spinning Wheel odds, interstitial rules, VIP ₹20/month, coin pack prices.

## 3. Release Prerequisites

### 3.1 Client
1. `phase_2.json.gz` ના બધા 500 levels CI validator pass ([06 §7](./06_FRONTEND_AND_QA_PHASE_2.md)).
2. `puzzle_core` માં M051–M099 implement + દરેક ID નો unit test (`m051_test.dart … m099_test.dart`).
3. Save schema migration v1 → v2 (new boxes) tested on real Phase 1 saves.
4. Zoom/pan input performance budget DM-1 પર pass (14×14, 40 threads).

### 3.2 Backend (Firebase)
| # | Item | Notes |
|---|---|---|
| B1 | Firebase Auth providers | Anonymous, Google, Apple (iOS માં Sign in with Apple ફરજિયાત જો Google offer કરીએ) |
| B2 | Cloud Firestore | Collections: `users`, `users/{uid}/ops`, `races`, `cohorts`, `ghostTraces`. Security rules: client માત્ર પોતાનું `users/{uid}` read; writes ફક્ત Functions દ્વારા ([05 §7](./05_OFFLINE_AND_CLOUD_SYNC.md)) |
| B3 | Cloud Functions | `applyOps`, `getCloudSave`, `joinStarRace`, `reportRaceClear`, `finalizeStarRaces` (scheduled), `verifyPurchase` (Piggy + cosmetics ledger), `deleteUserData` |
| B4 | App Check | Play Integrity (Android), App Attest / DeviceCheck (iOS); બધા callable Functions enforce |
| B5 | Remote Config | `maxPhase=2`, `star_race_*`, `piggy_*`, `album_*`, `cosmetic_prices`, `sync_*` keys |
| B6 | Store / policy | Privacy policy + Play Data safety + App Store privacy labels update (account ID, game progress); in-app account deletion; Families policy review (Star Race માં free-text names નહીં) |
| B7 | IAP | નવો consumable SKU `yarn_piggy_bank` ₹49 (Play Console + App Store Connect) |
| B8 | Monitoring | Functions error alerts, Firestore usage budget alerts |

### 3.3 Exit criteria
QA checklist ([06 §9](./06_FRONTEND_AND_QA_PHASE_2.md)) device matrix પર executed, no open blocker · sync conflict tests pass · Star Race 2-week internal dogfood (ghost fill સહિત).

## 4. Document Index

| # | Doc | Covers |
|---|---|---|
| 01 | [01_PHASE_2_SCOPE_AND_RULES.md](./01_PHASE_2_SCOPE_AND_RULES.md) | Rule additions: zoom/pan, 8-direction threads, 3 layers, push objects, lanes vs beams, tiers P2-A/P2-B, economy changes |
| 02 | [02_LEVEL_PROGRESSION_0501_1000.md](./02_LEVEL_PROGRESSION_0501_1000.md) | L501–510 onboarding, 50-block table, L1000 Finale |
| 03 | [03_OBSTACLE_CATALOG_PHASE_2.md](./03_OBSTACLE_CATALOG_PHASE_2.md) | M051–M099 cards + Finale card |
| 04 | [04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) | Sticker Album, Weekly Star Race, Piggy Bank, Cosmetic Shop |
| 05 | [05_OFFLINE_AND_CLOUD_SYNC.md](./05_OFFLINE_AND_CLOUD_SYNC.md) | Offline-first, Auth, Firestore, op-log, conflicts, Dart sync code, account/deletion |
| 06 | [06_FRONTEND_AND_QA_PHASE_2.md](./06_FRONTEND_AND_QA_PHASE_2.md) | Architecture additions, renderer/input code, performance, QA checklist |
| — | [../../SCALING_TO_10000_LEVELS.md](../../SCALING_TO_10000_LEVELS.md) | Phases 3–20, generator, modifiers, cadence |

## 5. Themed Names (Phase 2 additions)

| Generic | Yarn Unravel |
|---|---|
| Sticker Album | Scrapbook (Sticker Album) |
| Weekly Star Race | Weekly Star Race ("Cozy Cup") |
| Piggy Bank | Knitted Piggy Bank |
| Cosmetic shop | Wardrobe (Cosmetic Shop) |
| Phase 2 Finale | The Heirloom Tapestry |
| Phase 2 badge | "Heirloom Weaver" |
| Mechanics M051–M099 | [03 §2](./03_OBSTACLE_CATALOG_PHASE_2.md) |

Booster, Gift Box, Coin Rush, Phase Chest, Lucky Spin, Daily, Streak Saver ના નામ Phase 1 જેવા જ: Needle Glow Hint, Thimble Shield, Golden Scissors, Thread Peek, Craft Basket, Golden Bobbin Rush, Grand Sewing Chest, Spinning Wheel, Daily Stitch, Darning Patch.
