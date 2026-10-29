# Phase 17 — Levels 8001–8500 (Garden Guardians)
> Ants & Bees: Garden Trails ના Phase 17 update નું scope, signature system (Guardians: Garden Guardians), 4 નવા base mechanics (M801–M804), 45 variants, on-device deterministic generation, release prerequisites અને Phase 17 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 16 index](../phase_16/README.md) · [Phase 18 index](../phase_18/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 17 = **Garden Guardians (Guardians) update** (વિશાળ બોસ ગાર્ડિયન્સ, ટ્વિન હોર્નેટ્સ, આર્મર્ડ રાઇનો બીટલ શિલ્ડ્સ, ભમરી નેસ્ટ સ્પોનર્સ અને હાર્ટ-સીડ કોર લૉક્સ). Phase 16 ના 8000 levels ક્લિયર કરનાર players માટે **L8001–8500** content:
1. **Signature System:** Guardians (Garden Guardians — મલ્ટિ-સેલ બોસ બ્લોકર્સ, શિલ્ડ મિકેનિક્સ, મૂવ-આધારિત બ્લોકર સ્પોનિંગ).
2. **4 New Base Mechanics:** M801 Twin Hornets, M802 Armored Rhino Beetle, M803 Wasp Nest Guardian, M804 Heart-Seed Guardian.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 17 Value | Source |
|---|---|---|
| Levels | 8001–8500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Guardians: Garden Guardians (Multi-cell boss blockers with HP pools) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M801 (L8011), M802 (L8131), M803 (L8251), M804 (L8371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L8491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L8500 "Royal Hive Defense Gala" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P17-A (8001–8250) · P17-B (8251–8500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Queen's Gift Box | 49 (L8010 … L8490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L8500: 1,000 coins + 2 of each booster + "Hive Protector" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L8025, 8050 … 8500), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 16
| Area | Phase 16 | Phase 17 |
|---|---|---|
| Core Focus | Complex key networks & lock crafting | **Multi-Tile Boss Guardians & Active Spawners (Garden Guardians)** |
| Blocker Nature | 1-cell or small static gates/blocks | **Large 2×2 Bosses with Shared HP, Armor Shells, and Periodic Spawning** |
| Damage Protocol | Direct clear upon exit | Multiple linked line exits or core-piercing lanes required to deplete HP |
| Seed Metadata | `phase_16_meta.bin` | Shipped `phase_17_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Guardian Solver Verification:** L8001–8500 ના તમામ 500 levels guardian HP solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_17_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Guardian HP Pool Determinism:** Twin Hornet shared HP decrement તમામ પ્લેટફોર્મ્સ પર એકસમાન રીતે હેન્ડલ થવું જોઈએ.
4. **Remote Config Flag:** `maxPhase = 17` સેટ થતાં Phase 17 અનલૉક થાય.
5. **Tutorial Assets:** M801–M804 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_17_SCOPE_AND_RULES.md](./01_PHASE_17_SCOPE_AND_RULES.md) | Guardian rules, shared HP pools, armor stripping, spawner limits |
| 02 | [02_LEVEL_PLAN_8001_8500.md](./02_LEVEL_PLAN_8001_8500.md) | 50-block slot map (L8001–8500), base intros, 45 variants, L8491 review, L8500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md) | Garden Guardians rules, M801–M804 cards, boss defeat sequences, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_17.md](./04_VARIANTS_AND_MODIFIERS_PHASE_17.md) | 45 variant slot definitions (Guardians mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_17.md](./05_REWARDS_AND_ECONOMY_PHASE_17.md) | Economy inflow/outflow, Gift Boxes, L8500 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_17.md](./06_UI_AND_QA_PHASE_17.md) | Guardian HP bar HUD, armor shell crack visuals, boss defeat VFX, QA checklist |

---

## 6. Open Decisions
- **OD-P17-01:** Guardian defeat dissolve animation duration: 300 ms vs 350 ms.

