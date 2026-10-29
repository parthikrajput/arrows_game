# Phase 15 — Levels 7001–7500 (Brook & Rails)
> Ants & Bees: Garden Trails ના Phase 15 update નું scope, signature system (Conveyors & Tracks: Brook & Rails), 4 નવા base mechanics (M701–M704), 45 variants, on-device deterministic generation, release prerequisites અને Phase 15 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 14 index](../phase_14/README.md) · [Phase 16 index](../phase_16/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 15 = **Brook & Rails (Conveyors & Tracks) update** (પાણીના ઝરણાંના પ્રવાહો, બ્રૂક ફોર્ક જંક્શન્સ, ટાઈડ બ્રૂક રીવર્સલ, સ્લુઈસ લીવર્સ અને લેઝી રીવર પરિભ્રમણ લૂપ્સ). Phase 14 ના 7000 levels ક્લિયર કરનાર players માટે **L7001–7500** content:
1. **Signature System:** Conveyors & Tracks (Brook & Rails — જળપ્રવાહ દ્વારા લાઈનોનું ડ્રિફ્ટિંગ, ટ્રેક જંક્શન્સ, મૂવ-આધારિત દિશા પલટો).
2. **4 New Base Mechanics:** M701 Brook Fork, M702 Tide Brook, M703 Sluice Lever, M704 Lazy River.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 15 Value | Source |
|---|---|---|
| Levels | 7001–7500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Conveyors & Tracks: Brook & Rails (Water current conveyor tiles) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M701 (L7011), M702 (L7131), M703 (L7251), M704 (L7371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L7491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L7500 "Rushing Waters Gala" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P15-A (7001–7250) · P15-B (7251–7500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Queen's Gift Box | 49 (L7010 … L7490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L7500: 1,000 coins + 2 of each booster + "River Master" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L7025, 7050 … 7500), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 14
| Area | Phase 14 | Phase 15 |
|---|---|---|
| Core Focus | Bilateral mirror reflection physics | **Continuous Flow & Conveyor Currents (Brook & Rails)** |
| Movement Nature | Static till tapped, twin mirrors | **Passive Drifting: Ants resting on brook cells drift 1 cell/Move with current** |
| Layer Interaction| Affects ground and air twins | **Ants drift in streams; Bees fly freely above brook cells without drifting** |
| Seed Metadata | `phase_14_meta.bin` | Shipped `phase_15_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Conveyor Solver Verification:** L7001–7500 ના તમામ 500 levels conveyor drift solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_15_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Drift Settlement Determinism:** દરેક Move પછી પાણીના પ્રવાહ પર રહેલી તમામ કીડીઓનું 1 સેલ ડ્રિફ્ટિંગ تمام પ્લેટફોર્મ્સ પર એકસમાન રીતે ટિક થવું જોઈએ.
4. **Remote Config Flag:** `maxPhase = 15` સેટ થતાં Phase 15 અનલૉક થાય.
5. **Tutorial Assets:** M701–M704 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_15_SCOPE_AND_RULES.md](./01_PHASE_15_SCOPE_AND_RULES.md) | Brook flow rules, fork routing, sluice toggle, ant-only drift, limits |
| 02 | [02_LEVEL_PLAN_7001_7500.md](./02_LEVEL_PLAN_7001_7500.md) | 50-block slot map (L7001–7500), base intros, 45 variants, L7491 review, L7500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md) | Brook & Rails rules, M701–M704 cards, drift loop order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_15.md](./04_VARIANTS_AND_MODIFIERS_PHASE_15.md) | 45 variant slot definitions (Conveyors mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_15.md](./05_REWARDS_AND_ECONOMY_PHASE_15.md) | Economy inflow/outflow, Gift Boxes, L7500 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_15.md](./06_UI_AND_QA_PHASE_15.md) | Brook flow water animation, fork switch indicators, river VFX, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P15-01:** Brook water conveyor texture scroll speed: 32 dp/s vs 48 dp/s.

