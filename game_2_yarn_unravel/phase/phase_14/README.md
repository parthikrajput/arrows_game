# Phase 14 — Levels 6501–7000 (Looking-Glass Quilt)
> Purpose: Yarn Unravel ના Phase 14 update નું scope, signature system (Mirror Worlds: Looking-Glass Quilt — mirror seams, reflect clasps, twin quilts, inverse threads), 4 નવા base mechanics (M651–M654), 45 variants, ઑન-ડિવાઇસ જનરેશન અને Phase 14 docs નો index.

**Related docs:** [Game overview](../../README.md) · [Phases overview](../README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 13 index](../phase_13/README.md) · [Phase 15 index](../phase_15/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 14 players માટે **L6501–7000** content લાવે છે:
1. **Signature System: Mirror Worlds (Looking-Glass Quilt):** ક્રાફ્ટ બોર્ડની મધ્યમાં મિરર સીમ (Mirror Seam) વડે વિભાજીત સમપ્રમાણ ક્વિલ્ટ, જેમાં એક બાજુનો દોરો ખેંચતાં બીજી બાજુનો જોડિયા દોરો પ્રતિબિંબિત ગતિ કરે છે.
2. **4 New Base Mechanics:** M651 Mirror Seam (Mirror Axis), M652 Reflect Clasp (Reflect Lock), M653 Twin Quilt (Twin Board), M654 Inverse Thread (Inverse Path).
3. **45 Variants:** Base mechanics × 10 craft modifiers (`Knotted`, `Dyed`, `Fluffed`, `Ribbon-Tied`, વગેરે).
4. **Difficulty Band:** Fixed plateau **D 94–110** (standard §17.24).
5. **Phase Finale:** L7000 "The Looking-Glass Masterpiece" + Grand Sewing Chest.

## 2. Content Summary
| Item | Phase 14 Value | Source |
|---|---|---|
| Levels | 6501–7000 (On-device generated via seed) | Standard §11; SCALING §6, §7 |
| Signature System | Mirror Worlds (Looking-Glass Quilt, reflection symmetry & inverse paths) | Standard §11, SCALING §7 |
| Base Mechanics | 4: M651 (L6511), M652 (L6631), M653 (L6751), M654 (L6871) | Standard §11, §17.38; SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §8 |
| Review Level | L6991 (Block 50 x1 — "Looking-Glass Quilt Mastery") | Standard §17.34, §17.38 |
| Finale | L7000 "The Looking-Glass Masterpiece" (Finale target D ≈ 132) | SCALING §3.5, §7 |
| Tiers | P14-A (6501–6750) · P14-B (6751–7000) | SCALING §3.5, §6 |
| Grid Bounds | 12×12–14×14 | SCALING §3.5 |
| Total Threads | 28–40 threads | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Craft Basket (Gift Box) | 49 (L6510 … L6990) × **300 coins** + 1 booster | Standard §6.1, SCALING §7 |
| Grand Sewing Chest | L7000: 1,000 coins + 2 of each booster + Phase 14 badge | Standard §6.1, SCALING §7 |
| Golden Bobbin Rush | 20 rounds (after L6525, 6550 … 7000), 30 threads each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 13
| Area | Phase 13 | Phase 14 |
|---|---|---|
| Signature System | Hidden Info (Mystery Basket) | **Mirror Worlds (Looking-Glass Quilt)** — bilateral reflection & twin mechanics |
| Board Dynamics | Concealment & scouting | **Symmetric twin unravelling**, inverse motion threads, reflect clasps |
| Base Mechanics | M601–M604 (Scout, Decoy, False Wall, Plate) | **M651–M654 (Mirror Seam, Reflect Clasp, Twin Quilt, Inverse Thread)** |
| Difficulty Model | D Band 91–107 | **D Band 94–110** (target $D_{\text{finale}} \approx 132$) |

## 4. Release Prerequisites
1. **CI Validation:** L6501–7000 ના 500 levels CI validator દ્વારા pre-validated હોવા જોઈએ.
2. **Metadata Asset:** `phase_14_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ હોવા જોઈએ.
3. **Remote Config Flag:** `maxPhase = 14` set થયેલ હોવું જોઈએ.
4. **Tutorial Cards:** Mirror Seam symmetry, Reflect Clasp pairs, Twin Quilt toggles અને Inverse Thread localized tutorials.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_14_SCOPE_AND_RULES.md](./01_PHASE_14_SCOPE_AND_RULES.md) | Mirror Worlds rules, reflection axes, inverse physics, limits |
| 02 | [02_LEVEL_PLAN_6501_7000.md](./02_LEVEL_PLAN_6501_7000.md) | 50-block slot map (L6501–7000), base intros, 45 variants, L7000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md) | Looking-Glass Quilt rules, M651–M654 catalog cards, mirror tick order |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_14.md](./04_VARIANTS_AND_MODIFIERS_PHASE_14.md) | 45 variant slot definitions, mirror-modifier combinations |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_14.md](./05_REWARDS_AND_ECONOMY_PHASE_14.md) | Economy inflow/outflow, Craft Baskets, L7000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_14.md](./06_UI_AND_QA_PHASE_14.md) | Mirror axis visual styling, reflection shimmer VFX, tier limits, QA checklist |

