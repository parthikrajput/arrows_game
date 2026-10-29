# Phase 9 — Levels 4001–4500 (Swarm Splits)
> Ants & Bees: Garden Trails ના Phase 9 update નું scope, signature system (Split & Merge: Swarm Splits), 4 નવા base mechanics (M401–M404), 45 variants, on-device deterministic generation, release prerequisites અને Phase 9 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 8 index](../phase_8/README.md) · [Phase 10 index](../phase_10/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 9 = **Swarm Splits (Split & Merge) update** (કીડીઓ અને મધમાખીઓની લાઈનોનું વિભાજન અને જોડાણ, મર્જ પેડ્સ, ફોર્ક ટ્વિગ્સ, સેગમેન્ટ ક્લેસ્પ અને રીયૂનિયન ગેટ્સ). Phase 8 ના 4000 levels ક્લિયર કરનાર players માટે **L4001–4500** content:
1. **Signature System:** Split & Merge (Swarm Splits — લાઈનોનું બે શાખાઓમાં વિભાજન, મર્જ પેડ પર રી-કમ્પોઝિશન, સેગમેન્ટ લોકીંગ).
2. **4 New Base Mechanics:** M401 Honey Merge Pad, M402 Fork Twig, M403 Segment Clasp, M404 Reunion Arch.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 9 Value | Source |
|---|---|---|
| Levels | 4001–4500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Split & Merge: Swarm Splits (Line splitting, path convergence) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M401 (L4011), M402 (L4131), M403 (L4251), M404 (L4371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L4491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L4500 "Great Swarm Reunion" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P9-A (4001–4250) · P9-B (4251–4500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Queen's Gift Box | 49 (L4010 … L4490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L4500: 1,000 coins + 2 of each booster + "Swarm Conductor" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L4025, 4050 … 4500), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 8
| Area | Phase 8 | Phase 9 |
|---|---|---|
| Core Focus | Expanding vines & pruning tiles | **Dynamic Line Splitting & Path Merging (Swarm Splits)** |
| Line Identity | Fixed length lines throughout life | Lines dynamically divide into sub-groups or merge into larger caravans |
| Exit Preconditions | Simple clear exits / Pollination counts | **Reunion Arches (Requires both split halves to exit before opening)** |
| Seed Metadata | `phase_8_meta.bin` | Shipped `phase_9_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Split/Merge Solver Verification:** L4001–4500 ના તમામ 500 levels split/merge solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_9_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Split Routing Determinism:** Fork Twig પર લાઈનનું ડાબી અને જમણી શાખામાં 90° વિભાજન તમામ પ્લેટફોર્મ્સ પર એકસમાન રીતે થવું જોઈએ.
4. **Remote Config Flag:** `maxPhase = 9` સેટ થતાં Phase 9 અનલૉક થાય.
5. **Tutorial Assets:** M401–M404 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_9_SCOPE_AND_RULES.md](./01_PHASE_9_SCOPE_AND_RULES.md) | Split & merge rules, simultaneous branch clearing, clasp release, limits |
| 02 | [02_LEVEL_PLAN_4001_4500.md](./02_LEVEL_PLAN_4001_4500.md) | 50-block slot map (L4001–4500), base intros, 45 variants, L4491 review, L4500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md) | Swarm Splits rules, M401–M404 cards, fork collision check, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_9.md](./04_VARIANTS_AND_MODIFIERS_PHASE_9.md) | 45 variant slot definitions (Split/Merge mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_9.md](./05_REWARDS_AND_ECONOMY_PHASE_9.md) | Economy inflow/outflow, Gift Boxes, L4500 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_9.md](./06_UI_AND_QA_PHASE_9.md) | Split path indicators, merge snap visuals, swarm VFX, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P9-01:** Fork split dual-line animation timing: synchronous vs 50 ms staggered exit.

