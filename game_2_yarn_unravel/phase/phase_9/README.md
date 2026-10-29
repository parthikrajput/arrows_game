# Phase 9 — Levels 4001–4500 (Ply & Twist)
> Purpose: Yarn Unravel ના Phase 9 update નું scope, signature system (Split & Merge: Ply & Twist — twisting pads, double splitters, stitch locks, rejoin gates), 4 નવા base mechanics (M401–M404), 45 variants, ઑન-ડિવાઇસ જનરેશન અને Phase 9 docs નો index.

**Related docs:** [Game overview](../../README.md) · [Phases overview](../README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 8 index](../phase_8/README.md) · [Phase 10 index](../phase_10/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 9 players માટે **L4001–4500** content લાવે છે:
1. **Signature System: Split & Merge (Ply & Twist):** ક્રાફ્ટ બોર્ડ પર દોરાઓનું વિભાજન (Splitting into two independent plys) અને જોડાણ (Twisting Pad પર બે દોરાઓનું એક દોરામાં મર્જ થવું).
2. **4 New Base Mechanics:** M401 Twisting Pad (Merger Pad), M402 Double Split (Twin Splitter), M403 Stitch Lock (Segment Lock), M404 Rejoin Gate (Rejoin Gate).
3. **45 Variants:** Base mechanics × 10 craft modifiers (`Knotted`, `Dyed`, `Fluffed`, `Ribbon-Tied`, વગેરે).
4. **Difficulty Band:** Fixed plateau **D 79–95** (standard §17.24).
5. **Phase Finale:** L4500 "The Grand Tapestry Knot" + Grand Sewing Chest.

## 2. Content Summary
| Item | Phase 9 Value | Source |
|---|---|---|
| Levels | 4001–4500 (On-device generated via seed) | Standard §11; SCALING §6, §7 |
| Signature System | Split & Merge (Ply & Twist, thread splitting & merging) | Standard §11, SCALING §7 |
| Base Mechanics | 4: M401 (L4011), M402 (L4131), M403 (L4251), M404 (L4371) | Standard §11, §17.38; SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §8 |
| Review Level | L4491 (Block 50 x1 — "Ply & Twist Mastery") | Standard §17.34, §17.38 |
| Finale | L4500 "The Grand Tapestry Knot" (Finale target D ≈ 114) | SCALING §3.5, §7 |
| Tiers | P9-A (4001–4250) · P9-B (4251–4500) | SCALING §3.5, §6 |
| Grid Bounds | 12×12–14×14 | SCALING §3.5 |
| Total Threads | 28–40 threads | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Craft Basket (Gift Box) | 49 (L4010 … L4490) × **300 coins** + 1 booster | Standard §6.1, SCALING §7 |
| Grand Sewing Chest | L4500: 1,000 coins + 2 of each booster + Phase 9 badge | Standard §6.1, SCALING §7 |
| Golden Bobbin Rush | 20 rounds (after L4025, 4050 … 4500), 30 threads each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 8
| Area | Phase 8 | Phase 9 |
|---|---|---|
| Signature System | Growth (Garden Knitting) | **Split & Merge (Ply & Twist)** — thread topology changes |
| Board Dynamics | Organic spreading ivy yarn | **Thread split & merge**, segment locks, dual-ply rejoin gates |
| Base Mechanics | M351–M354 (Ivy, Snip, Seed Bead, Blossom) | **M401–M404 (Twisting Pad, Double Split, Stitch Lock, Rejoin Gate)** |
| Difficulty Model | D Band 76–92 | **D Band 79–95** (target $D_{\text{finale}} \approx 114$) |

## 4. Release Prerequisites
1. **CI Validation:** L4001–4500 ના 500 levels CI validator દ્વારા pre-validated હોવા જોઈએ.
2. **Metadata Asset:** `phase_9_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ હોવા જોઈએ.
3. **Remote Config Flag:** `maxPhase = 9` set થયેલ હોવું જોઈએ.
4. **Tutorial Cards:** Twisting Pad merge, Double Split, Stitch Lock અને Rejoin Gate localized tutorials.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_9_SCOPE_AND_RULES.md](./01_PHASE_9_SCOPE_AND_RULES.md) | Split & Merge rules, thread topology, merge kinetics, limits |
| 02 | [02_LEVEL_PLAN_4001_4500.md](./02_LEVEL_PLAN_4001_4500.md) | 50-block slot map (L4001–4500), base intros, 45 variants, L4500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md) | Ply & Twist rules, M401–M404 catalog cards, merge tick order |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_9.md](./04_VARIANTS_AND_MODIFIERS_PHASE_9.md) | 45 variant slot definitions, ply/twist modifier combinations |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_9.md](./05_REWARDS_AND_ECONOMY_PHASE_9.md) | Economy inflow/outflow, Craft Baskets, L4500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_9.md](./06_UI_AND_QA_PHASE_9.md) | Thread split/merge VFX, twisting pad visuals, tier limits, QA checklist |

