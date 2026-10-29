# Phase 4 — Levels 1501–2000 (Garden Terraces)
> Ants & Bees: Garden Trails ના Phase 4 update નું scope, signature system (Multi-floor: Garden Terraces), 4 નવા base mechanics (M151–M154), 45 variants, on-device deterministic generation, release prerequisites અને Phase 4 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 3 index](../phase_3/README.md) · [Phase 5 index](../phase_5/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 4 = **Multi-floor Garden Terraces update** (3 વર્ટિકલ ફ્લોર્સ: Lower Terrace, Main Garden, Upper Canopy). Phase 3 ના 1500 levels ક્લિયર કરનાર players માટે **L1501–2000** content:
1. **Signature System:** Garden Terraces (Multi-floor — 2 થી 3 ફ્લોર્સ, ફ્લોર ટેબ્સ + ઇન્ટરેક્ટિવ મિનિ-મેપ, વર્ટિકલ લેન નેવિગેશન).
2. **4 New Base Mechanics:** M151 Root Stairs, M152 Dew-Glass Terrace, M153 Rabbit Hole, M154 Acorn Lift.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 4 Value | Source |
|---|---|---|
| Levels | 1501–2000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Garden Terraces (Up to 3 floors, Floor Tabs, Mini-map) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M151 (L1511), M152 (L1631), M153 (L1751), M154 (L1871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L1991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L2000 "Sky Garden Gala" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P4-A (1501–1750) · P4-B (1751–2000) | SCALING §3.5 |
| Max Grid | 10×10 થી 12×12 per floor (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all active floors | SCALING §3.5 |
| Obstacle Instances | 8–14 instances across floors | SCALING §3.5 |
| Queen's Gift Box | 49 (L1510 … L1990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L2000: 1,000 coins + 2 of each booster + "Terrace Master" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L1525, 1550 … 2000), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 3
| Area | Phase 3 | Phase 4 |
|---|---|---|
| Board Architecture | Single board with Cycles A/B | **Multi-Floor (2–3 Terraces)** with floor switching & stairs |
| Signature System | Day & Night Cycles (every 5 moves) | **Garden Terraces (Stairs, Drop Holes, Glass Floors, Lifts)** |
| Verticality | 3 insect altitude layers | 3 physical garden floors × 3 insect altitude layers |
| Navigation | Viewport zoom/pan | Viewport zoom/pan + Floor Switcher Tab Bar + Mini-Map |
| Seed Metadata | `phase_3_meta.bin` | Shipped `phase_4_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Multi-Floor Validation:** L1501–2000 ના તમામ 500 levels multi-floor solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_4_meta.bin` અને `seed_overrides.json` asset bundle માં ઉપલબ્ધ હોવા જોઈએ.
3. **Cross-Platform Parity:** Multi-floor floor-switching અને stairs transitions તમામ ડિવાઇસ પર byte-identical રહેવા જોઈએ.
4. **Remote Config Flag:** `maxPhase = 4` સેટ થતાં Phase 4 અનલૉક થાય.
5. **Tutorial Assets:** Floor tab switcher અને M151–M154 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_4_SCOPE_AND_RULES.md](./01_PHASE_4_SCOPE_AND_RULES.md) | Multi-floor rules, vertical lane transitions, floor camera navigation, limits |
| 02 | [02_LEVEL_PLAN_1501_2000.md](./02_LEVEL_PLAN_1501_2000.md) | 50-block slot map (L1501–2000), base intros, 45 variants, L1991 review, L2000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md) | Garden Terraces rules, M151–M154 cards, vertical raycasting, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_4.md](./04_VARIANTS_AND_MODIFIERS_PHASE_4.md) | 45 variant slot definitions (Terrace mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_4.md](./05_REWARDS_AND_ECONOMY_PHASE_4.md) | Economy inflow/outflow, Gift Boxes, L2000 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_4.md](./06_UI_AND_QA_PHASE_4.md) | Floor tabs UI, mini-map, terrace VFX, performance budgets, QA checklist |

---

## 6. Open Decisions
- **OD-P4-01:** Floor switch transition animation duration: 200 ms slide-vertical vs 250 ms fade-cross dissolve.

