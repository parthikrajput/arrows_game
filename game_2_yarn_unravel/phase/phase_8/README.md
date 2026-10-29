# Phase 8 — Levels 3501–4000 (Garden Knitting)
> Purpose: Yarn Unravel ના Phase 8 update નું scope, signature system (Growth: Garden Knitting — ivy yarn spreaders, snip pruner tiles, seed bead threads, blossom gates), 4 નવા base mechanics (M351–M354), 45 variants, ઑન-ડિવાઇસ જનરેશન અને Phase 8 docs નો index.

**Related docs:** [Game overview](../../README.md) · [Phases overview](../README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 7 index](../phase_7/README.md) · [Phase 9 index](../phase_9/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 8 players માટે **L3501–4000** content લાવે છે:
1. **Signature System: Growth (Garden Knitting):** ક્રાફ્ટ બોર્ડ પર ગૂંથેલા છોડવાઓ (Ivy Yarn) જે દર N Moves એ આપોઆપ ખાલી સેલ્સમાં વિસ્તરે છે.
2. **4 New Base Mechanics:** M351 Ivy Yarn (Vine Spread+), M352 Snip Tile (Pruner Tile), M353 Seed Bead Thread (Seed Path), M354 Blossom Gate (Bloom Gate).
3. **45 Variants:** Base mechanics × 10 craft modifiers (`Knotted`, `Dyed`, `Fluffed`, `Ribbon-Tied`, વગેરે).
4. **Difficulty Band:** Fixed plateau **D 76–92** (standard §17.24).
5. **Phase Finale:** L4000 "The Blooming Quilt" + Grand Sewing Chest.

## 2. Content Summary
| Item | Phase 8 Value | Source |
|---|---|---|
| Levels | 3501–4000 (On-device generated via seed) | Standard §11; SCALING §6, §7 |
| Signature System | Growth (Garden Knitting, dynamic board spread) | Standard §11, SCALING §7 |
| Base Mechanics | 4: M351 (L3511), M352 (L3631), M353 (L3751), M354 (L3871) | Standard §11, §17.38; SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §8 |
| Review Level | L3991 (Block 50 x1 — "Garden Knitting Mastery") | Standard §17.34, §17.38 |
| Finale | L4000 "The Blooming Quilt" (Finale target D ≈ 110) | SCALING §3.5, §7 |
| Tiers | P8-A (3501–3750) · P8-B (3751–4000) | SCALING §3.5, §6 |
| Grid Bounds | 12×12–14×14 | SCALING §3.5 |
| Total Threads | 28–40 threads | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Craft Basket (Gift Box) | 49 (L3510 … L3990) × **300 coins** + 1 booster | Standard §6.1, SCALING §7 |
| Grand Sewing Chest | L4000: 1,000 coins + 2 of each booster + Phase 8 badge | Standard §6.1, SCALING §7 |
| Golden Bobbin Rush | 20 rounds (after L3525, 3550 … 4000), 30 threads each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 7
| Area | Phase 7 | Phase 8 |
|---|---|---|
| Signature System | Rotation (Turning Table) | **Growth (Garden Knitting)** — organic expanding yarn spreaders |
| Board Dynamics | 90° angular rotations | **Spreading yarn vines**, pruning shears tiles, seed maturation |
| Base Mechanics | M301–M304 (Rotors, Turning Hems) | **M351–M354 (Ivy Yarn, Snip Tiles, Seed Beads, Blossom Gates)** |
| Difficulty Model | D Band 73–89 | **D Band 76–92** (target $D_{\text{finale}} \approx 110$) |

## 4. Release Prerequisites
1. **CI Validation:** L3501–4000 ના 500 levels CI validator દ્વારા pre-validated હોવા જોઈએ.
2. **Metadata Asset:** `phase_8_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ હોવા જોઈએ.
3. **Remote Config Flag:** `maxPhase = 8` set થયેલ હોવું જોઈએ.
4. **Tutorial Cards:** Spreading ivy mechanics અને M351–M354 localized tutorials.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_8_SCOPE_AND_RULES.md](./01_PHASE_8_SCOPE_AND_RULES.md) | Growth rules, spreader kinetics, seed timers, pruning, limits |
| 02 | [02_LEVEL_PLAN_3501_4000.md](./02_LEVEL_PLAN_3501_4000.md) | 50-block slot map (L3501–4000), base intros, 45 variants, L4000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md) | Garden Knitting rules, M351–M354 catalog cards, growth tick order |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_8.md](./04_VARIANTS_AND_MODIFIERS_PHASE_8.md) | 45 variant slot definitions, growth-modifier combinations |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_8.md](./05_REWARDS_AND_ECONOMY_PHASE_8.md) | Economy inflow/outflow, Craft Baskets, L4000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_8.md](./06_UI_AND_QA_PHASE_8.md) | Spreading vine VFX, blooming blossom visuals, tier limits, performance budgets, QA checklist |

