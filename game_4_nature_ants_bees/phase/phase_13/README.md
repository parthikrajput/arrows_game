# Phase 13 — Levels 6001–6500 (Mystery Meadow)
> Ants & Bees: Garden Trails ના Phase 13 update નું scope, signature system (Hidden Info: Mystery Meadow), 4 નવા base mechanics (M601–M604), 45 variants, on-device deterministic generation, release prerequisites અને Phase 13 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 12 index](../phase_12/README.md) · [Phase 14 index](../phase_14/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 13 = **Mystery Meadow (Hidden Info) update** (ઝાકળ-ધુમ્મસથી છવાયેલા બગીચા વિસ્તારો, સ્કાઉટ એન્ટ્સ, મિરાજ મિસ્ટ, પેઇન્ટેડ પેબલ ભ્રામક દીવાલો અને સનલિટ રીવીલ પ્લેટ્સ). Phase 12 ના 6000 levels ક્લિયર કરનાર players માટે **L6001–6500** content:
1. **Signature System:** Hidden Info (Mystery Meadow — પાર્શિયલ વિઝિબિલિટી, ફોગ ક્લિયરિંગ સ્કાઉટ્સ, ભ્રામક અવરોધોનું અનાવરણ).
2. **4 New Base Mechanics:** M601 Scout Ant, M602 Mirage Mist, M603 Painted Pebble, M604 Sunlit Plate.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 13 Value | Source |
|---|---|---|
| Levels | 6001–6500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Hidden Info: Mystery Meadow (Fog of war, dynamic reveals, scout trails) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M601 (L6011), M602 (L6131), M603 (L6251), M604 (L6371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L6491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L6500 "Solstice Dawn Gala" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P13-A (6001–6250) · P13-B (6251–6500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Queen's Gift Box | 49 (L6010 … L6490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L6500: 1,000 coins + 2 of each booster + "Meadow Clairvoyant" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L6025, 6050 … 6500), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 12
| Area | Phase 12 | Phase 13 |
|---|---|---|
| Core Focus | Gravity settlement and falling debris | **Information Concealment, Perception & Reconnaissance (Mystery Meadow)** |
| Board State | Fully visible layout affected by wind | Portions of the garden concealed by dynamic fog, requiring scouting |
| Obstacle Nature | Real physical stone and acorn blockers | **Illusionary Obstacles (Painted Pebbles that look solid but allow passage)** |
| Seed Metadata | `phase_12_meta.bin` | Shipped `phase_13_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Hidden Info Solver Verification:** L6001–6500 ના તમામ 500 levels fog simulation solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_13_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Fog Mask Determinism:** Chebyshev distance 2 fog clearance તમામ પ્લેટફોર્મ્સ પર એકસમાન રીતે ટ્રેસ થવું જોઈએ.
4. **Remote Config Flag:** `maxPhase = 13` સેટ થતાં Phase 13 અનલૉક થાય.
5. **Tutorial Assets:** M601–M604 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_13_SCOPE_AND_RULES.md](./01_PHASE_13_SCOPE_AND_RULES.md) | Hidden info rules, fog clearing radius, false wall detection, limits |
| 02 | [02_LEVEL_PLAN_6001_6500.md](./02_LEVEL_PLAN_6001_6500.md) | 50-block slot map (L6001–6500), base intros, 45 variants, L6491 review, L6500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md) | Mystery Meadow rules, M601–M604 cards, reveal state management, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_13.md](./04_VARIANTS_AND_MODIFIERS_PHASE_13.md) | 45 variant slot definitions (Hidden Info mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_13.md](./05_REWARDS_AND_ECONOMY_PHASE_13.md) | Economy inflow/outflow, Gift Boxes, L6500 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_13.md](./06_UI_AND_QA_PHASE_13.md) | Fog shaders, false wall "?" indicators, sunlit plate highlight, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P13-01:** Fog dissipation dissolve animation duration: 200 ms vs 250 ms.

