# Phase 6 — Levels 2501–3000 (Lamplight Atelier)
> Purpose: Yarn Unravel ના Phase 6 update નું scope, signature system (Light & Beams+: Lamplight Atelier — optical beams, tinted glass filters, prism clasps, hourglass lamps, shadow pockets), 4 નવા base mechanics (M251–M254), 45 variants, ઑન-ડિવાઇસ જનરેશન અને Phase 6 docs નો index.

**Related docs:** [Game overview](../../README.md) · [Phases overview](../README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 5 index](../phase_5/README.md) · [Phase 7 index](../phase_7/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 6 players માટે **L2501–3000** content લાવે છે:
1. **Signature System: Light & Beams+ (Lamplight Atelier):** ક્રાફ્ટ બોર્ડ પર દીવાઓમાંથી નીકળતા ઓપ્ટિકલ પ્રકાશ કિરણો (Light Beams) જે કલર ફિલ્ટર્સ અને પ્રિઝમ્સ સાથે જોડાય છે.
2. **4 New Base Mechanics:** M251 Tinted Glass (Color Filter), M252 Prism Clasp (Beam Splitter Lock), M253 Hourglass Lamp (Beam Timer), M254 Shadow Pocket (Dark Cells).
3. **45 Variants:** Base mechanics × 10 craft modifiers (`Knotted`, `Dyed`, `Fluffed`, `Ribbon-Tied`, વગેરે).
4. **Difficulty Band:** Fixed plateau **D 70–86** (standard §17.24).
5. **Phase Finale:** L3000 "Atelier Chandelier Tapestry" + Grand Sewing Chest.

## 2. Content Summary
| Item | Phase 6 Value | Source |
|---|---|---|
| Levels | 2501–3000 (On-device generated via seed) | Standard §11; SCALING §6, §7 |
| Signature System | Light & Beams+ (Lamplight Atelier, continuous ray casting) | Standard §11, SCALING §7 |
| Base Mechanics | 4: M251 (L2511), M252 (L2631), M253 (L2751), M254 (L2871) | Standard §11, §17.38; SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §8 |
| Review Level | L2991 (Block 50 x1 — "Atelier Mastery") | Standard §17.34, §17.38 |
| Finale | L3000 "Atelier Chandelier Tapestry" (Finale target D ≈ 103) | SCALING §3.5, §7 |
| Tiers | P6-A (2501–2750) · P6-B (2751–3000) | SCALING §3.5, §6 |
| Grid Bounds | 12×12–14×14 | SCALING §3.5 |
| Total Threads | 28–40 threads | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Craft Basket (Gift Box) | 49 (L2510 … L2990) × **300 coins** + 1 booster | Standard §6.1, SCALING §7 |
| Grand Sewing Chest | L3000: 1,000 coins + 2 of each booster + Phase 6 badge | Standard §6.1, SCALING §7 |
| Golden Bobbin Rush | 20 rounds (after L2525, 2550 … 3000), 30 threads each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 5
| Area | Phase 5 | Phase 6 |
|---|---|---|
| Signature System | Push Physics+ (Crate Workshop) | **Light & Beams+ (Lamplight Atelier)** — ray casting optical mechanics |
| Board Dynamics | Kinetic crate pushing | **Beam projection**, chromatic filters, and shadow locks |
| Base Mechanics | M201–M204 (Crates & Pits) | **M251–M254 (Lamps, Prisms, Filters, Shadows)** |
| Difficulty Model | D Band 67–83 | **D Band 70–86** (target $D_{\text{finale}} \approx 103$) |

## 4. Release Prerequisites
1. **CI Validation:** L2501–3000 ના 500 levels CI validator દ્વારા pre-validated હોવા જોઈએ.
2. **Metadata Asset:** `phase_6_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ હોવા જોઈએ.
3. **Remote Config Flag:** `maxPhase = 6` set થયેલ હોવું જોઈએ.
4. **Tutorial Cards:** Light beam projection અને M251–M254 localized tutorials.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_6_SCOPE_AND_RULES.md](./01_PHASE_6_SCOPE_AND_RULES.md) | Light & Beams rules, ray tracing order, shadow unlocking, limits |
| 02 | [02_LEVEL_PLAN_2501_3000.md](./02_LEVEL_PLAN_2501_3000.md) | 50-block slot map (L2501–3000), base intros, 45 variants, L3000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md) | Lamplight Atelier rules, M251–M254 catalog cards, ray tick order |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_6.md](./04_VARIANTS_AND_MODIFIERS_PHASE_6.md) | 45 variant slot definitions, beam-modifier combinations |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_6.md](./05_REWARDS_AND_ECONOMY_PHASE_6.md) | Economy inflow/outflow, Craft Baskets, L3000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_6.md](./06_UI_AND_QA_PHASE_6.md) | Optical beam shaders, chromatic VFX, tier limits, performance budgets, QA checklist |

