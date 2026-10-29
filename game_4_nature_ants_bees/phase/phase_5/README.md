# Phase 5 — Levels 2001–2500 (Acorn Physics)
> Ants & Bees: Garden Trails ના Phase 5 update નું scope, signature system (Push Physics+: Acorn Physics), 4 નવા base mechanics (M201–M204), 45 variants, on-device deterministic generation, release prerequisites અને Phase 5 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 4 index](../phase_4/README.md) · [Phase 6 index](../phase_6/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 5 = **Acorn Physics (Push Physics+) update** (ખસેડી શકાય તેવા પઝલ બ્લોક્સ, ખાડા પૂરીને રસ્તો બનાવવો, સ્લાઇડિંગ માર્બલ્સ, કી પોડ્સ અને હેવી સ્ટોન પમ્પકિન્સ). Phase 4 ના 2000 levels ક્લિયર કરનાર players માટે **L2001–2500** content:
1. **Signature System:** Acorn Physics (Push Physics+ — બ્લોક પુશિંગ ચેઇન્સ, સ્લાઇડિંગ ઇનર્શિયા, સોકેટ ઇન્ટરલોક્સ).
2. **4 New Base Mechanics:** M201 Mole Hole, M202 Dewdrop Marble, M203 Seed Key Pod, M204 Stone Pumpkin.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 5 Value | Source |
|---|---|---|
| Levels | 2001–2500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Push Physics+: Acorn Physics (Push chains, friction, sockets) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M201 (L2011), M202 (L2131), M203 (L2251), M204 (L2371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L2491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L2500 "Great Harvest Gala" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P5-A (2001–2250) · P5-B (2251–2500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Queen's Gift Box | 49 (L2010 … L2490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L2500: 1,000 coins + 2 of each booster + "Heavy Harvester" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L2025, 2050 … 2500), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 4
| Area | Phase 4 | Phase 5 |
|---|---|---|
| Core Focus | Multi-floor vertical transitions | **Advanced Push Physics (Holes, Marbles, Key Pods, Heavy Weights)** |
| Interactive Blocks | Basic push blocks (M053) | Specialized physics blocks: Mole Holes, Sliding Marbles, Heavy Stone Pumpkins |
| Block-to-Block Chains| Single block push | Block pushing block chains, fills holes to create traversable terrain |
| Seed Metadata | `phase_4_meta.bin` | Shipped `phase_5_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Push Solver Verification:** L2001–2500 ના તમામ 500 levels push solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_5_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Cross-Platform Determinism:** Block collision અને sliding friction ફિઝિક્સ تمام પ્લેટફોર્મ્સ પર એકસમાન પરિણામ આપવા જોઈએ.
4. **Remote Config Flag:** `maxPhase = 5` સેટ થતાં Phase 5 અનલૉક થાય.
5. **Tutorial Assets:** M201–M204 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_5_SCOPE_AND_RULES.md](./01_PHASE_5_SCOPE_AND_RULES.md) | Push physics+ rules, friction, hole filling, weight requirements, limits |
| 02 | [02_LEVEL_PLAN_2001_2500.md](./02_LEVEL_PLAN_2001_2500.md) | 50-block slot map (L2001–2500), base intros, 45 variants, L2491 review, L2500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md) | Acorn Physics rules, M201–M204 cards, momentum resolution, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_5.md](./04_VARIANTS_AND_MODIFIERS_PHASE_5.md) | 45 variant slot definitions (Physics mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_5.md](./05_REWARDS_AND_ECONOMY_PHASE_5.md) | Economy inflow/outflow, Gift Boxes, L2500 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_5.md](./06_UI_AND_QA_PHASE_5.md) | Weight indicators, rolling animations, physics VFX, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P5-01:** Stone Pumpkin push impact dust duration: 150 ms vs 200 ms.

