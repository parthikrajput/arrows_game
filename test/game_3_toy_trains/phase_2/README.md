# Phase 2 — Levels 501–1000 + LiveOps — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 2 નો scope (Levels 501–1000, mechanics M051–M099, L1000 Finale, LiveOps), Phase 1 ની સરખામણીમાં શું નવું છે, release prerequisites (backend) અને Phase 2 docs નો index.

**Related docs:** [Game README](../README.md) · [Shared Core Standard §9–§16](../../SHARED_CORE_STANDARD.md) · [Phase 1 README](../phase_1/README.md) · [Scaling to 10,000](../SCALING_TO_10000_LEVELS.md)

> ⚖️ Phase 2 ના બધા rules, numbers, IDs અને intro levels [SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) મુજબ છે. Phase 1 ના બધા rules ([01](../phase_1/01_GAME_CONCEPT_AND_RULES.md)) Phase 2 માં યથાવત્ લાગુ પડે છે; અહીં માત્ર **ઉમેરા** લખ્યા છે.

---

## 1. Scope

| Item | Phase 2 value |
|---|---|
| Levels | **501–1000** (bundled `assets/levels/phase_2.json.gz`, offline generator + hand-tuning) |
| Onboarding | **L501–510**: zoom/pan tutorial, 12×12 boards, **કોઈ નવું mechanic નહીં** |
| Mechanics | **49** (M051–M099), દરેક block ના x1 પર એક: L511, 521 … 991 |
| Finale | **L1000 Grand Terminus Finale** — M098 Marching Clock Tower + ≥ 10 mixed mechanics |
| Tiers | **P2-A** (501–750) · **P2-B** (751–1000) — [01 §6](./01_PHASE_2_SCOPE_AND_RULES.md) |
| Max grid | **14×14** (pinch-zoom + pan on ≥ 12×12, auto-fit start) |
| LiveOps | Depot Sticker Album · Weekly Star Race · Piggy Bank · Cloud Sync · Cosmetics (train liveries + board themes) |
| Backend | Firebase Auth (anonymous → Google/Apple link), Cloud Firestore, Cloud Functions |
| Release | એક app update + Remote Config `maxPhase = 2` ([Scaling doc §9](../SCALING_TO_10000_LEVELS.md)) |

## 2. What's New vs Phase 1

| Area | Phase 1 | Phase 2 |
|---|---|---|
| Board size | 4×4 – 11×11, zoom નહીં | 10×10 – 14×14; **≥ 12×12 પર pinch-zoom + pan** |
| Train directions | `U, D, L, R` | + **diagonal** `UL, UR, DL, DR` (M051 Diagonal Express થી) |
| Layers | 1–2 (M032 Viaduct Deck) | **3** (M069 Triple-Deck Viaduct) + layer-changing Viaduct Ramp (M056) |
| Physics | — | **Push Carts** (M053), Frosty Rails slide (M054), Cart Weighbridge (M055), Heavy Weighbridge (M083) |
| Light | — | **Signal Lamps & light beams** (M084–M086, M089, M099) |
| Board-wide | — | Roundhouse Lever (M070), Spinning Playmat (M079), Island Station (M078) |
| Tiers | FTUE, T1–T5 | **P2-A, P2-B** |
| Conductor's Gift Crate | 150 → 300 | **300** at every x0 (L510–990) + 1 booster |
| Grand Central Chest | L500 | **L1000** (1,000 coins + 2 of each booster + "Phase 2 Conductor" badge) |
| Shop | boosters, coin packs, Starter Pack, VIP | + **Cosmetics** tab (coin sink 800–4,000) + **Piggy Bank** ₹49 |
| Save | local Hive only | Hive + **Cloud Sync** (Firestore, op-log) |
| Social | leaderboards | + **Weekly Star Race** (5-player async cohort) |

Economy માં **માત્ર standard માં લખેલા ફેરફાર**: Conductor's Gift Crate Phase 2 = 300, L1000 Grand Central Chest (Phase Chest), cosmetics sink (800–4,000), Piggy Bank IAP ₹49 (max 1,000). બાકીના બધા numbers (boosters, Heart Refill, clear coins, Coin Rush, Daily, Streak, Lucky Turntable, ads, VIP) Phase 1 જેવા જ — [04 Boosters, Coins & Shop](../phase_1/04_BOOSTERS_COINS_SHOP.md).

## 3. LiveOps Unlock Levels

| Feature | Unlock | Needs internet? |
|---|---|---|
| Depot Sticker Album | L10 clear (પહેલું sticker); update પછી **retroactive** grant | No |
| Piggy Bank | L30 clear | Break (IAP) માટે હા; deposits offline |
| Weekly Star Race | L60 clear | **Yes** (join, progress submit, rewards) |
| Cosmetics tab | L10 clear (FTUE પૂરું થયા પછી) | Coins થી ખરીદી offline (queued sync) |
| Cloud Sync | પહેલી online launch પર anonymous account | Yes (sync); game offline ચાલે |

Album, Piggy, Race અને Cosmetics Phase 2 update સાથે **બધા players** માટે ship થાય (Phase 1 levels રમતા players માટે પણ) — માત્ર levels 501–1000 માટે L500 clear જરૂરી.

## 4. Release Prerequisites (Backend)

Phase 2 build store પર મૂકતાં પહેલાં નીચેનું બધું production માં તૈયાર હોવું જોઈએ:

| # | Item | Detail |
|---|---|---|
| 1 | Firebase Auth | Anonymous provider ON; Google (Android + iOS) અને Sign in with Apple (iOS) providers configured; account linking enabled |
| 2 | Cloud Firestore | `users/{uid}`, `users/{uid}/ops/{opId}`, `races/{raceId}`, `races/{raceId}/members/{uid}`, `ghosts/{band}` collections; **security rules: client writes deny** (બધા writes Cloud Functions થી) — [05 §5](./05_OFFLINE_AND_CLOUD_SYNC.md) |
| 3 | Cloud Functions | `applyOps`, `verifyPurchase` (Phase 1 થી, હવે ledger op પણ લખે), `joinRace`, `submitRaceClear`, `closeRace` (scheduled), `claimRaceReward`, `deleteAccount` |
| 4 | Replay validator | `puzzle_core` replay module `dart compile js` થી Node bundle માં — race clear plausibility ([04 §3.6](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)) |
| 5 | Ghost pool | દરેક level band માટે ≥ 200 historical race traces (internal QA + soft-launch data); pool ખાલી ⇒ synthetic ghosts from `par_moves` ([04 §3.4](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)) |
| 6 | IAP product | `piggy_bank_49` consumable (Play Console + App Store Connect), cosmetics coin-only (IAP નહીં) |
| 7 | Remote Config | `maxPhase = 2`, `piggy_*`, `race_*`, `album_rewards`, `cosmetic_prices` defaults = આ docs ના values |
| 8 | Privacy | Privacy policy update (account data, Firestore), Play Data Safety + App Store privacy labels, **in-app account deletion** (Apple 5.1.1(v)) + web deletion link (Play) |
| 9 | Level pack | `tools/levelgen validate` : **500/500** Phase 2 levels pass ([06 §8](./06_FRONTEND_AND_QA_PHASE_2.md)) |
| 10 | Load test | `applyOps` & `submitRaceClear` emulator load test (target concurrency soft-launch DAU પરથી નક્કી કરવો) |

## 5. Doc Index

| # | Doc | Covers |
|---|---|---|
| 01 | [Phase 2 Scope & Rules](./01_PHASE_2_SCOPE_AND_RULES.md) | Zoom/pan, diagonal trains, 3 layers, push carts, light beams (lanes vs beams), tick order, P2 tiers, economy deltas, cosmetics |
| 02 | [Level Progression 0501–1000](./02_LEVEL_PROGRESSION_0501_1000.md) | L501–510 onboarding, 50-block table, L1000 Finale |
| 03 | [Obstacle Catalog Phase 2](./03_OBSTACLE_CATALOG_PHASE_2.md) | M051–M099 + L1000 Finale cards, JSON schema v3 |
| 04 | [LiveOps: Album, Star Race, Piggy, Cosmetics](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) | Depot Sticker Album, Weekly Star Race, Piggy Bank, cosmetics shop |
| 05 | [Offline & Cloud Sync](./05_OFFLINE_AND_CLOUD_SYNC.md) | Offline-first, Auth, Firestore, op-log, conflict rules, Dart sync code, account deletion |
| 06 | [Frontend & QA Phase 2](./06_FRONTEND_AND_QA_PHASE_2.md) | New BLoCs, zoom/pan input, diagonal lanes, beam renderer, layers, save fields, performance, QA checklist |

## 6. Phase 2 Exit Criteria

- `tools/levelgen validate`: Phase 2 ના 500/500 levels pass (0 hearts / 0 boosters solvable, D in band, intro rule).
- QA checklist ([06 §10](./06_FRONTEND_AND_QA_PHASE_2.md)) device matrix પર execute; બધા blocking items pass.
- Performance: 14×14 board, 40 trains — 60 fps low-tier, p95 raster < 8 ms mid-tier.
- Sync: op-log idempotency + conflict test suite green (emulator).
- Store: account deletion, privacy labels, Piggy Bank product review approved.
