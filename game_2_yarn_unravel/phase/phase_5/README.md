# Phase 5 — Levels 2001–2500 (Crate Workshop)
> Purpose: Yarn Unravel ના Phase 5 update નું scope, signature system (Push Physics+: Crate Workshop — pushable notions crates, crate pits, sliding satin crates, charm crates, heavy iron crates), 4 નવા base mechanics (M201–M204), 45 variants, ઑન-ડિવાઇસ જનરેશન અને Phase 5 docs નો index.

**Related docs:** [Game overview](../../README.md) · [Phases overview](../README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 4 index](../phase_4/README.md) · [Phase 6 index](../phase_6/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 5 players માટે **L2001–2500** content લાવે છે:
1. **Signature System: Push Physics+ (Crate Workshop):** લાકડાના ક્રાફ્ટ બોર્ડ પર ફરતી ક્રેઇટ્સ (notions crates) જેને દોરાઓની પુલ લાઇન દ્વારા આગળ ધકેલી શકાય છે.
2. **4 New Base Mechanics:** M201 Crate Pit (Crate Holes), M202 Satin Crate (Sliding Ice Crates), M203 Charm Crate (Crate Keys), M204 Iron Crate (Heavy Crate).
3. **45 Variants:** Base mechanics × 10 craft modifiers (`Knotted`, `Dyed`, `Fluffed`, `Ribbon-Tied`, વગેરે).
4. **Difficulty Band:** Fixed plateau **D 67–83** (standard §17.24).
5. **Phase Finale:** L2500 "Master Workshop Tapestry" + Grand Sewing Chest.

## 2. Content Summary
| Item | Phase 5 Value | Source |
|---|---|---|
| Levels | 2001–2500 (On-device generated via seed) | Standard §11; SCALING §6, §7 |
| Signature System | Push Physics+ (Pushable sewing crates) | Standard §11, SCALING §7 |
| Base Mechanics | 4: M201 (L2011), M202 (L2131), M203 (L2251), M204 (L2371) | Standard §11, §17.38; SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §8 |
| Review Level | L2491 (Block 50 x1 — "Crate Workshop Mastery") | Standard §17.34, §17.38 |
| Finale | L2500 "Master Workshop Tapestry" (Finale target D ≈ 100) | SCALING §3.5, §7 |
| Tiers | P5-A (2001–2250) · P5-B (2251–2500) | SCALING §3.5, §6 |
| Grid Bounds | 12×12–14×14 | SCALING §3.5 |
| Total Threads | 28–40 threads | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Craft Basket (Gift Box) | 49 (L2010 … L2490) × **300 coins** + 1 booster | Standard §6.1, SCALING §7 |
| Grand Sewing Chest | L2500: 1,000 coins + 2 of each booster + Phase 5 badge | Standard §6.1, SCALING §7 |
| Golden Bobbin Rush | 20 rounds (after L2025, 2050 … 2500), 30 threads each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 4
| Area | Phase 4 | Phase 5 |
|---|---|---|
| Signature System | Multi-Floor (Sewing Room Floors) | **Push Physics+ (Crate Workshop)** — dynamic pushable blocks |
| Board Dynamics | Vertical floor traversal | **In-plane block pushing**, crate pits, and sliding kinetics |
| Base Mechanics | M151–M154 (Stairs, Elevators, Organza) | **M201–M204 (Crates, Pits, Charm Boxes)** |
| Difficulty Model | D Band 64–80 | **D Band 67–83** (target $D_{\text{finale}} \approx 100$) |

## 4. Release Prerequisites
1. **CI Validation:** L2001–2500 ના 500 levels CI validator દ્વારા pre-validated હોવા જોઈએ.
2. **Metadata Asset:** `phase_5_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ હોવા જોઈએ.
3. **Remote Config Flag:** `maxPhase = 5` set થયેલ હોવું જોઈએ.
4. **Tutorial Cards:** Crate pushing અને M201–M204 localized tutorials.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_5_SCOPE_AND_RULES.md](./01_PHASE_5_SCOPE_AND_RULES.md) | Crate push physics rules, sliding kinetics, pit filling, limits |
| 02 | [02_LEVEL_PLAN_2001_2500.md](./02_LEVEL_PLAN_2001_2500.md) | 50-block slot map (L2001–2500), base intros, 45 variants, L2500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md) | Crate Workshop rules, M201–M204 catalog cards, push tick order |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_5.md](./04_VARIANTS_AND_MODIFIERS_PHASE_5.md) | 45 variant slot definitions, push-modifier combinations |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_5.md](./05_REWARDS_AND_ECONOMY_PHASE_5.md) | Economy inflow/outflow, Craft Baskets, L2500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_5.md](./06_UI_AND_QA_PHASE_5.md) | Crate visuals, sliding VFX, tier limits, performance budgets, QA checklist |

