# Phase 4 — Levels 1501–2000 (Sewing Room Floors)
> Purpose: Yarn Unravel ના Phase 4 update નું scope, signature system (Multi-Floor: Sewing Room Floors — up to 3 floors, stairs, glass floor, elevators), 4 નવા base mechanics (M151–M154), 45 variants, ઑન-ડિવાઇસ જનરેશન અને Phase 4 docs નો index.

**Related docs:** [Game overview](../../README.md) · [Phases overview](../README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 3 index](../phase_3/README.md) · [Phase 5 index](../phase_5/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 4 players માટે **L1501–2000** content લાવે છે:
1. **Signature System: Multi-Floor (Sewing Room Floors):** એક જ પઝલમાં 3 વર્ટિકલ કાપડ ફ્લોર્સ (Floor 1: Embroidery Table, Floor 2: Cutting Table, Floor 3: Attic Loom).
2. **4 New Base Mechanics:** M151 Spiral Spool Stair, M152 Organza Floor, M153 Drop Hole, M154 Bobbin Lift.
3. **45 Variants:** Base mechanics × 10 craft modifiers (`Knotted`, `Dyed`, `Fluffed`, `Ribbon-Tied`, વગેરે).
4. **Difficulty Band:** Fixed plateau **D 64–80** (standard §17.24).
5. **Phase Finale:** L2000 "The Three-Tier Quilt" + Grand Sewing Chest.

## 2. Content Summary
| Item | Phase 4 Value | Source |
|---|---|---|
| Levels | 1501–2000 (On-device generated via seed) | Standard §11; SCALING §6, §7 |
| Signature System | Multi-Floor (Up to 3 stacked floors, HUD switcher) | Standard §11, SCALING §7 |
| Base Mechanics | 4: M151 (L1511), M152 (L1631), M153 (L1751), M154 (L1871) | Standard §11, §17.38; SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §8 |
| Review Level | L1991 (Block 50 x1 — "Multi-Floor Mastery") | Standard §17.34, §17.38 |
| Finale | L2000 "The Three-Tier Quilt" (Finale target D ≈ 96) | SCALING §3.5, §7 |
| Tiers | P4-A (1501–1750) · P4-B (1751–2000) | SCALING §3.5, §6 |
| Grid Bounds | 12×12–14×14 per floor | SCALING §3.5 |
| Total Threads | 28–40 threads across all floors | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Craft Basket (Gift Box) | 49 (L1510 … L1990) × **300 coins** + 1 booster | Standard §6.1, SCALING §7 |
| Grand Sewing Chest | L2000: 1,000 coins + 2 of each booster + Phase 4 badge | Standard §6.1, SCALING §7 |
| Golden Bobbin Rush | 20 rounds (after L1525, 1550 … 2000), 30 threads each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 3
| Area | Phase 3 | Phase 4 |
|---|---|---|
| Signature System | Day & Night Loom (Cycles A/B) | **Multi-Floor (3 Stacked Craft Floors)** with vertical traversal |
| Board Structure | 1 Flat 2D grid with 3 layers | **Up to 3 independent floors** with stairs, holes, and elevators |
| Camera & View | Single view with pinch-zoom/pan | **Floor Switcher Buttons (F1/F2/F3)** + camera glide transition |
| Base Mechanics | M101–M104 (Loom Cycle series) | **M151–M154 (Vertical Sewing notions)** |
| Difficulty Model | D Band 60–76 | **D Band 64–80** (target $D_{\text{finale}} \approx 96$) |

## 4. Release Prerequisites
1. **CI Validation:** L1501–2000 ના 500 levels CI validator દ્વારા pre-validated હોવા જોઈએ.
2. **Metadata Asset:** `phase_4_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ હોવા જોઈએ.
3. **Remote Config Flag:** `maxPhase = 4` set થયેલ હોવું જોઈએ.
4. **Tutorial Cards:** Multi-floor switching અને M151–M154 localized tutorials.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_4_SCOPE_AND_RULES.md](./01_PHASE_4_SCOPE_AND_RULES.md) | Multi-Floor rules, vertical traversal, camera switching, limits |
| 02 | [02_LEVEL_PLAN_1501_2000.md](./02_LEVEL_PLAN_1501_2000.md) | 50-block slot map (L1501–2000), base intros, 45 variants, L2000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md) | Multi-Floor system rules, M151–M154 catalog cards, vertical tick order |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_4.md](./04_VARIANTS_AND_MODIFIERS_PHASE_4.md) | 45 variant slot definitions, vertical modifiers combinations |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_4.md](./05_REWARDS_AND_ECONOMY_PHASE_4.md) | Economy inflow/outflow, Craft Baskets, L2000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_4.md](./06_UI_AND_QA_PHASE_4.md) | Floor switcher HUD, vertical VFX, tier limits, performance budgets, QA checklist |

