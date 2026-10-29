# Phase 7 — Levels 3001–3500 (Turning Table)
> Purpose: Yarn Unravel ના Phase 7 update નું scope, signature system (Rotation: Turning Table — sub-board hoop rotors, rotating hem borders, twirl threads, ratchet pin locks), 4 નવા base mechanics (M301–M304), 45 variants, ઑન-ડિવાઇસ જનરેશન અને Phase 7 docs નો index.

**Related docs:** [Game overview](../../README.md) · [Phases overview](../README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 6 index](../phase_6/README.md) · [Phase 8 index](../phase_8/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 7 players માટે **L3001–3500** content લાવે છે:
1. **Signature System: Rotation (Turning Table):** ક્રાફ્ટ બોર્ડ પર ફરતી ગોળ રિંગ્સ, 4×4 હૂપ રોટર્સ અને દર મૂવે દિશા બદલતા ટ્વિર્લ દોરાઓ.
2. **4 New Base Mechanics:** M301 Hoop Rotor (Sub-board Rotor), M302 Turning Hem (Rotating Edges), M303 Twirl Thread (Spin Path), M304 Ratchet Pin (Rotation Lock).
3. **45 Variants:** Base mechanics × 10 craft modifiers (`Knotted`, `Dyed`, `Fluffed`, `Ribbon-Tied`, વગેરે).
4. **Difficulty Band:** Fixed plateau **D 73–89** (standard §17.24).
5. **Phase Finale:** L3500 "The Kaleidoscope Quilt" + Grand Sewing Chest.

## 2. Content Summary
| Item | Phase 7 Value | Source |
|---|---|---|
| Levels | 3001–3500 (On-device generated via seed) | Standard §11; SCALING §6, §7 |
| Signature System | Rotation (Turning Table, 90° CW mechanics) | Standard §11, SCALING §7 |
| Base Mechanics | 4: M301 (L3011), M302 (L3131), M303 (L3251), M304 (L3371) | Standard §11, §17.38; SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §8 |
| Review Level | L3491 (Block 50 x1 — "Turning Table Mastery") | Standard §17.34, §17.38 |
| Finale | L3500 "The Kaleidoscope Quilt" (Finale target D ≈ 107) | SCALING §3.5, §7 |
| Tiers | P7-A (3001–3250) · P7-B (3251–3500) | SCALING §3.5, §6 |
| Grid Bounds | 12×12–14×14 | SCALING §3.5 |
| Total Threads | 28–40 threads | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Craft Basket (Gift Box) | 49 (L3010 … L3490) × **300 coins** + 1 booster | Standard §6.1, SCALING §7 |
| Grand Sewing Chest | L3500: 1,000 coins + 2 of each booster + Phase 7 badge | Standard §6.1, SCALING §7 |
| Golden Bobbin Rush | 20 rounds (after L3025, 3050 … 3500), 30 threads each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 6
| Area | Phase 6 | Phase 7 |
|---|---|---|
| Signature System | Light & Beams+ (Lamplight Atelier) | **Rotation (Turning Table)** — dynamic angular transformations |
| Board Dynamics | Optical beam lines | **4×4 sub-board rotation**, rotating exit borders, twirling needles |
| Base Mechanics | M251–M254 (Beams, Clasps, Lamps) | **M301–M304 (Rotors, Turning Hems, Twirl Threads, Pins)** |
| Difficulty Model | D Band 70–86 | **D Band 73–89** (target $D_{\text{finale}} \approx 107$) |

## 4. Release Prerequisites
1. **CI Validation:** L3001–3500 ના 500 levels CI validator દ્વારા pre-validated હોવા જોઈએ.
2. **Metadata Asset:** `phase_7_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ હોવા જોઈએ.
3. **Remote Config Flag:** `maxPhase = 7` set થયેલ હોવું જોઈએ.
4. **Tutorial Cards:** Sub-board rotation અને M301–M304 localized tutorials.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_7_SCOPE_AND_RULES.md](./01_PHASE_7_SCOPE_AND_RULES.md) | Rotation rules, angular coordinate transforms, tangled states, limits |
| 02 | [02_LEVEL_PLAN_3001_3500.md](./02_LEVEL_PLAN_3001_3500.md) | 50-block slot map (L3001–3500), base intros, 45 variants, L3500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md) | Turning Table rules, M301–M304 catalog cards, rotation tick order |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_7.md](./04_VARIANTS_AND_MODIFIERS_PHASE_7.md) | 45 variant slot definitions, rotation-modifier combinations |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_7.md](./05_REWARDS_AND_ECONOMY_PHASE_7.md) | Economy inflow/outflow, Craft Baskets, L3500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_7.md](./06_UI_AND_QA_PHASE_7.md) | Rotor swoosh VFX, turning border animations, tier limits, performance budgets, QA checklist |

