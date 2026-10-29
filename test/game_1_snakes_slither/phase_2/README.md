# Phase 2 — Levels 501–1000 + LiveOps
> Snakes Slither ના Phase 2 update માં શું ઉમેરાય છે (500 નવા levels, 49 નવા jungle mechanics, LiveOps, cloud save), Phase 1 સામે શું બદલાય છે, release પહેલાં backend માં શું તૈયાર હોવું જોઈએ, અને Phase 2 ના દરેક document નો index.

**Related docs:** [Game overview](../README.md) · [Shared Core Standard](../../SHARED_CORE_STANDARD.md) · [Phase 1 index](../phase_1/README.md) · [Scaling to 10,000](../SCALING_TO_10000_LEVELS.md)

---

## 1. Goal (લક્ષ્ય)
Phase 2 = પહેલો મોટો content + LiveOps update. Phase 1 ના 500 levels પૂરા કરનાર players માટે **L501–1000** (bigger boards, diagonal snakes, 3 layers, push physics, sunbeams) અને બધા players માટે **LiveOps** features: Jungle Sticker Album, Weekly Star Race, Piggy Bank, Cosmetics Shop અને Cloud Sync. Core rules (standard §2–§8) **બદલાતા નથી** — માત્ર standard §9.1 અને §10 Phase 2 ના rules ઉમેરાય છે.

## 2. Content Summary
| Item | Phase 2 value | Source |
|---|---|---|
| Levels | 501–1000 (`assets/levels/phase_2.json.gz`, schema v3) | Standard §9.1, §12 |
| Onboarding | L501–510: pinch-zoom + pan tutorial, 12×12 boards, **કોઈ નવું mechanic નહીં** | Standard §10 |
| Mechanics | 49: M051 (L511) … M099 (L991), દરેક block ના x1 slot પર | Standard §10 |
| Finale | L1000 "Mongoose Emperor's Sun Temple" (M098 Prowling Mongoose + 11 mixed mechanics) | Standard §10, §16.20 |
| Tiers | P2-A (501–750) · P2-B (751–1000) | Standard §9.3 |
| Max grid | 14×14, max 40 snakes, pinch-zoom + pan (≥ 12×12) | Standard §9.3 |
| Hand-tuned | L501–510, દરેક x1 intro, દરેક x9 Hard, L1000 Finale | Standard §12 |
| Jungle Gift Basket | 49 (L510 … L990) × **300 coins** + 1 booster | Standard §6.1 |
| Jungle Treasure Chest | L1000: 1,000 coins + 2 of each booster + Phase 2 badge | Standard §6.1 |
| Golden Slither Rush | 20 rounds (after L525, 550 … 1000), 30 snakes each | Standard §6.1, §16.9 |
| Biomes | Waterfall Gorge · Sunbeam Rainforest · Treetop Village · Ancient Ruins · Crystal Caves · Sun Temple | [02 §2](./02_LEVEL_PROGRESSION_0501_1000.md#2-tier-table--biomes) |

## 3. What's New vs Phase 1
| Area | Phase 1 | Phase 2 |
|---|---|---|
| Board size | 4×4 … 11×11, auto-fit, zoom નહીં | 10×10 … 14×14; **≥ 12×12 પર pinch-zoom + pan** (auto-fit start) |
| Snake directions | `U, D, L, R` | + `UL, UR, DL, DR` (M051 Sidewinder Snake થી) |
| Layers | 1 અથવા 2 (M032 Canopy & Ground) | 3 સુધી: Ground / Canopy / Treetop (M069) |
| New systems | Static/stateful obstacles | Push Blocks (Rolling Coconut, M053), Sunbeams (M084–M089), board-wide rotation (M070, M079), periodic gates (M057, M090) |
| Moves-based ticks | M007 … M041 | + M057, M058, M063, M067, M068, M075, M079, M082, M090, M096 (standard §16.17 order) |
| Economy | Phase 1 inflow/outflow | Inflow numbers એ જ; Gift Basket Phase 2 = 300; નવો sink = Cosmetics (800–4,000); નવો IAP = Piggy Bank ₹49 |
| LiveOps | Daily + Streak + Lucky Lily Wheel | + Jungle Sticker Album, Weekly Star Race, Piggy Bank, Cosmetics Shop |
| Save | Local only (uninstall = progress જાય) | Local-first + **Cloud Sync** (Firebase Auth anonymous → Google/Apple link, Firestore) |
| Backend | `verifyPurchase` only | + `syncPush`, `raceJoin`, `raceProgress`, `raceFinalize`, `deleteAccount` Cloud Functions + Firestore |

## 4. Release Prerequisites (Backend)
Phase 2 app build store માં મોકલતા પહેલાં નીચેના બધા production માં deployed અને tested હોવા જોઈએ:

| # | Prerequisite | Detail | Doc |
|---|---|---|---|
| R1 | Firebase Auth | Anonymous provider ON; Google + Apple providers configured (SHA-1/SHA-256 Android, Sign in with Apple capability iOS) | [05 §3](./05_OFFLINE_AND_CLOUD_SYNC.md#3-identity-firebase-auth) |
| R2 | Cloud Firestore | `users/{uid}/…`, `races/…`, `ghostPool/…` collections; **security rules: client read-own only, no client writes to ledger/snapshot** | [05 §5](./05_OFFLINE_AND_CLOUD_SYNC.md#5-firestore-data-model) |
| R3 | Cloud Functions | `syncPush`, `deleteAccount`, `verifyPurchase` (Piggy SKU + cosmetics ledger), `raceJoin`, `raceProgress`, `raceFinalize` (scheduled, every 15 min) | [04 §3](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md#3-weekly-star-race) · [05](./05_OFFLINE_AND_CLOUD_SYNC.md) |
| R4 | Level data on server | `phase_2.json.gz` ના `par_moves` (Star Race plausibility માટે) functions bundle માં | [04 §3.7](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md#37-server-plausibility-validation) |
| R5 | Ghost pool seed | Beta/soft-launch races માંથી ≥ 200 anonymized runs per level band (ghost fill માટે) | [04 §3.5](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md#35-ghost-fill-historical-runs) |
| R6 | IAP products | `piggy_bank` (consumable, ₹49) Play Console + App Store Connect માં approved | [04 §4](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md#4-piggy-bank) |
| R7 | Remote Config | `maxPhase = 2` (rollout flag), Phase 2 economy keys, `featureFlags{album, race, piggy, cosmetics, cloudSync}` | [01 §9](./01_PHASE_2_SCOPE_AND_RULES.md#9-remote-config-keys-phase-2) |
| R8 | Privacy | Data safety form / App Privacy labels update (account id, gameplay data, purchase history), Privacy Policy update, **in-app account deletion** | [05 §10](./05_OFFLINE_AND_CLOUD_SYNC.md#10-account-deletion) |
| R9 | Monitoring | Functions error alerts, Firestore quota alerts, Crashlytics velocity alerts | [06 §9](./06_FRONTEND_AND_QA_PHASE_2.md#9-monitoring--rollout) |
| R10 | CI | Validator L501–1000 all pass, Rush seeds L525…L1000, Phase 2 QA P0 rows Pass | [06 §10](./06_FRONTEND_AND_QA_PHASE_2.md#10-qa-checklist) |

**Rollout:** app update સાથે `maxPhase = 1` ship; staged rollout (5% → 20% → 100%) પછી Remote Config `maxPhase = 2`. `maxPhase = 1` હોય ત્યાં સુધી L500 પછી "More levels coming soon" card. LiveOps features `featureFlags` થી અલગ-અલગ ON થઈ શકે; Cloud Sync પહેલાં ON (બાકીના features server ledger પર આધાર રાખે છે).

## 5. Unlocks in Phase 2
| Feature | Unlock | Note |
|---|---|---|
| Piggy Bank | L30 clear | Phase 2 update પછી `highestCleared ≥ 30` હોય તો તરત |
| Jungle Sticker Album | Update પછી તરત (પહેલો sticker L10) | Retroactive grant |
| Cosmetics Shop | Update પછી તરત (Shop → **Style** tab) | — |
| Weekly Star Race | `highestCleared ≥ 60` | Online + sign-in (anonymous ચાલે) |
| Cloud Sync | પહેલી online launch | Anonymous auto; Google/Apple link optional |
| L501+ | L500 clear + `maxPhase ≥ 2` | — |

## 6. Out of Scope (Phase 3+ / ક્યારેય નહીં)
| Feature | ક્યારે |
|---|---|
| L1001–10,000 (on-device generation) | Phase 3+ — [SCALING_TO_10000_LEVELS.md](../SCALING_TO_10000_LEVELS.md) |
| Real-time multiplayer / chat | ક્યારેય નહીં (Star Race async છે) |
| Custom global leaderboard backend | નહીં — `games_services` જ (standard §8.3) |
| Premium currency (gems) | નહીં — એક જ soft currency (Coins) |
| Loot boxes / paid random rewards | ક્યારેય નહીં |
| Lives / energy | ક્યારેય નહીં |

## 7. Document Index
| # | Document | શું છે |
|---|---|---|
| 01 | [01_PHASE_2_SCOPE_AND_RULES.md](./01_PHASE_2_SCOPE_AND_RULES.md) | Rule additions: zoom & pan, diagonal snakes, 3 layers, push blocks, sunbeams (lanes vs beams), P2 tier table, Phase 2 economy changes, Remote Config |
| 02 | [02_LEVEL_PROGRESSION_0501_1000.md](./02_LEVEL_PROGRESSION_0501_1000.md) | L501–510 onboarding, પૂરું 50-block table, L1000 Finale |
| 03 | [03_OBSTACLE_CATALOG_PHASE_2.md](./03_OBSTACLE_CATALOG_PHASE_2.md) | M051–M099 summary + એક card per mechanic + Finale card + combo rules |
| 04 | [04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) | Jungle Sticker Album, Weekly Star Race, Piggy Bank, Cosmetics Shop |
| 05 | [05_OFFLINE_AND_CLOUD_SYNC.md](./05_OFFLINE_AND_CLOUD_SYNC.md) | Offline-first, Auth, Firestore, op-log, conflict rules, Dart sync service, account deletion |
| 06 | [06_FRONTEND_AND_QA_PHASE_2.md](./06_FRONTEND_AND_QA_PHASE_2.md) | Architecture additions, zoom/pan, diagonal & beam rendering, 3 layers, save fields, performance, QA checklist |
| — | [../SCALING_TO_10000_LEVELS.md](../SCALING_TO_10000_LEVELS.md) | 500 → 10,000 levels pipeline, generator, Phases 3–20 |

## 8. Phase 2 Exit Criteria
| # | Criterion |
|---|---|
| X1 | CI validator: L501–1000 બધા pass (0 hearts / 0 boosters solvable, D in band, combo bans, Phase 2 cell rule [01 §2.4](./01_PHASE_2_SCOPE_AND_RULES.md#24-cell-size-rule-phase-2)) |
| X2 | [06 §10](./06_FRONTEND_AND_QA_PHASE_2.md#10-qa-checklist) ના બધા P0 rows run અને Pass |
| X3 | Performance: 14×14 / 40 snakes board પર low-tier device 60 fps (measured) |
| X4 | Sync conflict test matrix (2 devices, offline/online combos) Pass |
| X5 | R1–R10 prerequisites production માં |
| X6 | Account deletion flow store reviewers માટે reachable (Settings → Account → Delete) |
