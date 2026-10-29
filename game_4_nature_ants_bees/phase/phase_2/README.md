# Phase 2 — Levels 501–1000 + LiveOps (ફેઝ 2)
"Ants & Bees: Garden Trails II" નો scope: L501–1000, 49 નવા mechanics (M051–M099), L1000 Finale, LiveOps (Album, Star Race, Honeycomb Bank, Cosmetics, Cloud Sync), backend prerequisites અને Phase 2 docs નો index.

**Related docs:** [Game README](../../README.md) · [Shared Core Standard](../../SHARED_CORE_STANDARD.md) · [Phase 1 README](../phase_1/README.md) · [Scaling to 10,000](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Scope Summary (સારાંશ)

| Item | Phase 2 value |
|---|---|
| Levels | **501–1000** (bundled `assets/levels/phase_2.json.gz`) |
| Onboarding | **L501–510**: 12×12 boards, pinch-zoom/pan tutorial, **no new mechanic** |
| Mechanics | **49** (M051–M099 at L511, 521 … 991) + **L1000 Queen's Midsummer Jubilee** finale (Great Stag Beetle M098 + ≥ 10 mechanics) |
| Tiers | P2-A L501–750 (10×10–13×13, 24–34 lines, D 45–60) · P2-B L751–1000 (12×12–14×14, 28–40 lines, D 52–70) |
| Layers | Ground (ants, 0) + Air (bees, 1) + **Canopy (Canopy Scout Bees, 2) from L691 (M069)** |
| New rule systems | Pinch-zoom/pan (≥ 12×12) · diagonal lines (L511) · push blocks (L531) · sunbeams & dew prisms (L841) |
| Rewards | Queen's Gift Box **300** (L510–990) · **Royal Honey Chest** at L1000 · Golden Nectar Rush 30 lines |
| LiveOps | Flora & Fauna Compendium (100 stickers, 5 volumes) · Weekly Star Race · Golden Honeycomb Bank (₹49) · Garden Wardrobe (800–4,000) · Cloud Sync |
| Platforms / languages | Phase 1 જેવું: Android + iOS portrait; en / ગુજરાતી / हिन्दी |

## 2. What's New vs Phase 1 (નવું શું છે)

| Area | Phase 1 | Phase 2 |
|---|---|---|
| Board size | ≤ 11×11, no zoom | ≤ 14×14, pinch-zoom + pan at ≥ 12×12 |
| Directions | U/D/L/R | + UL/UR/DL/DR (ants, bees, canopy) |
| Layers | 2 (ants, bees) | 3 (+ canopy); `tall` blocks all flyers |
| Interactivity | Levers, daisies, switches, rotors | + push blocks, swap pads, compass lever, ivy lever, 3×3 rotor |
| Light | — | Sunbeams per layer, mirrors, prisms, receivers, Royal Hive Door |
| Boss | Great Orb Spider (static) | Great Stag Beetle (patrolling) |
| Economy | Gift Box 150–300, Chest L500 | Gift Box 300, Chest L1000, Honeycomb Bank IAP, cosmetics sink, Star Race rewards |
| Save | Device-only (Hive) | Hive + Firebase cloud save (op-log, conflict rules) |
| Social | Platform leaderboards | + Weekly Star Race (5-player async cohorts) |

Rules ([01](./01_PHASE_2_SCOPE_AND_RULES.md)) Phase 1 rules ને **extend** કરે છે; Phase 1 નો કોઈ number બદલાતો નથી.

## 3. Release Prerequisites (Backend + store)

| # | Prerequisite | Owner / note |
|---|---|---|
| R1 | Firebase **Auth** (anonymous + Google + Apple providers; Sign in with Apple configured) | Standard §13 |
| R2 | **Cloud Firestore** (`users/{uid}/state`, `ops`, `keys`; `races/...`) + security rules (client write deny) + TTL policy on `ops` | [05 §3](./05_OFFLINE_AND_CLOUD_SYNC.md) |
| R3 | **Cloud Functions**: `applyOps`, `raceJoin`, `raceGhostTick`, `raceFinalize`, `raceClaim`, `deleteAccount`, `verifyPurchase` (+ `piggy_bank` SKU) | [04](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md), [05](./05_OFFLINE_AND_CLOUD_SYNC.md) |
| R4 | **App Check** (Play Integrity / App Attest) enforced on callables | anti-cheat for race & ledger |
| R5 | Server level index (tag, par_moves per level 1–1000) deployed with functions | ledger coin validation, race plausibility |
| R6 | Store: new IAP SKU `piggy_bank` (₹49 consumable); privacy policy + Data Safety / App Privacy updated (account id, gameplay data) | |
| R7 | **Account deletion**: in-app + web URL | Google Play / App Store policy |
| R8 | Remote Config: `maxPhase = 2`, LiveOps keys ([04 §6](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)) | staged rollout |
| R9 | Firestore + Functions emulator test suite green | [06 §10](./06_FRONTEND_AND_QA_PHASE_2.md) |
| R10 | Load test: race finalize for expected weekend cohorts; functions cold-start budget | |

Phase 2 build Phase 1 players પર update થાય ⇒ first launch: anonymous sign-in, `migrate` op, retroactive stickers; `maxPhase = 2` હોય ત્યારે L500 Phase Complete screen પરથી L501 unlock.

## 4. Doc Index (દસ્તાવેજ સૂચિ)

| # | Doc | Covers |
|---|---|---|
| 01 | [Phase 2 Scope & Rules](./01_PHASE_2_SCOPE_AND_RULES.md) | Rule changes: zoom/pan, diagonals, canopy layer, push blocks, sunbeams, tick order, tap priority, P2 tier table, economy changes, edge cases |
| 02 | [Level Progression 501–1000](./02_LEVEL_PROGRESSION_0501_1000.md) | Tiers, block pattern, layer/diagonal schedule, L501–510 level-by-level, 50-row block table, reward order, L1000 Finale |
| 03 | [Obstacle Catalog Phase 2](./03_OBSTACLE_CATALOG_PHASE_2.md) | Summary + 49 cards (Ants/Bees/Tall, JSON v3, edge cases) + Finale card + CI rules + edge-case index |
| 04 | [LiveOps: Album, Star Race, Bank, Cosmetics](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) | Flora & Fauna Compendium, Weekly Star Race, Golden Honeycomb Bank, Garden Wardrobe, Remote Config, analytics |
| 05 | [Offline & Cloud Sync](./05_OFFLINE_AND_CLOUD_SYNC.md) | Auth, Firestore model, op-log, Dart sync code, conflict rules, internet matrix, account deletion |
| 06 | [Frontend & QA Phase 2](./06_FRONTEND_AND_QA_PHASE_2.md) | BLoCs, puzzle_core Phase 2 code, viewport, rendering, save fields, performance, QA checklist (all "Not run") |

Phase 3+ (L1001–10,000): [SCALING_TO_10000_LEVELS.md](../../SCALING_TO_10000_LEVELS.md).

## 5. Phase 2 Exit Criteria (રિલીઝ માપદંડ)
- QA checklist ([06 §9](./06_FRONTEND_AND_QA_PHASE_2.md)) ના બધા items run થઈ pass (હાલ બધા **"Not run"**).
- CI validator: 500/500 Phase 2 levels pass (0 hearts / 0 boosters, D band, Phase 2 rules).
- Performance: 14×14 / 40 lines / 3 layers @ 60 fps low-tier, raster p95 < 8 ms mid-tier.
- Backend R1–R10 complete; emulator suites green; account deletion verified.
- Store compliance: Families policy, UMP, Spin odds, subscription wording "while active", Star Race ghost disclosure, no free-text names.
