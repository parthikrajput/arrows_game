# Phase 16 — Levels 7501–8000 (Jewel Box)
> Purpose: Yarn Unravel ના Phase 16 update નું scope, signature system (Keys Deluxe: Jewel Box — charm chains, charm crafting, skeleton charms, charm swap hoops), 4 નવા base mechanics (M751–M754), 45 variants, ઑન-ડિવાઇસ જનરેશન અને Phase 16 docs નો index.

**Related docs:** [Game overview](../../README.md) · [Phases overview](../README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 15 index](../phase_15/README.md) · [Phase 17 index](../phase_17/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 16 players માટે **L7501–8000** content લાવે છે:
1. **Signature System: Keys Deluxe (Jewel Box):** ક્રાફ્ટ બોર્ડ પર ઝવેરાત અને બટન્સનો ખજાનો; શૃંખલાબદ્ધ ચાર્મ્સ (Charm Chains), બે અર્ધ-ચાર્મ્સનું જોડાણ (Crafting), યુનિવર્સલ સ્કેલેટન ચાર્મ્સ અને કી-સ્વેપ હૂપ્સ.
2. **4 New Base Mechanics:** M751 Charm Chain (Key Chain), M752 Charm Crafting (Key Crafting), M753 Skeleton Charm (Skeleton Key), M754 Charm Swap Hoop (Key Swap).
3. **45 Variants:** Base mechanics × 10 craft modifiers (`Knotted`, `Dyed`, `Fluffed`, `Ribbon-Tied`, વગેરે).
4. **Difficulty Band:** Fixed plateau **D 100–116** (standard §17.24).
5. **Phase Finale:** L8000 "The Master Jewel Box" + Grand Sewing Chest.

## 2. Content Summary
| Item | Phase 16 Value | Source |
|---|---|---|
| Levels | 7501–8000 (On-device generated via seed) | Standard §11; SCALING §6, §7 |
| Signature System | Keys Deluxe (Jewel Box, advanced charm locks & crafting) | Standard §11, SCALING §7 |
| Base Mechanics | 4: M751 (L7511), M752 (L7631), M753 (L7751), M754 (L7871) | Standard §11, §17.38; SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §8 |
| Review Level | L7991 (Block 50 x1 — "Jewel Box Mastery") | Standard §17.34, §17.38 |
| Finale | L8000 "The Master Jewel Box" (Finale target D ≈ 139) | SCALING §3.5, §7 |
| Tiers | P16-A (7501–7750) · P16-B (7751–8000) | SCALING §3.5, §6 |
| Grid Bounds | 12×12–14×14 | SCALING §3.5 |
| Total Threads | 28–40 threads | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Craft Basket (Gift Box) | 49 (L7510 … L7990) × **300 coins** + 1 booster | Standard §6.1, SCALING §7 |
| Grand Sewing Chest | L8000: 1,000 coins + 2 of each booster + Phase 16 badge | Standard §6.1, SCALING §7 |
| Golden Bobbin Rush | 20 rounds (after L7525, 7550 … 8000), 30 threads each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 15
| Area | Phase 15 | Phase 16 |
|---|---|---|
| Signature System | Conveyors & Tracks (Feed Dog Factory) | **Keys Deluxe (Jewel Box)** — advanced chained locks & key crafting |
| Board Dynamics | Moving mechanical belts | **Multi-stage charm collection**, key synthesis, dynamic key swaps |
| Base Mechanics | M701–M704 (Belt Switch, Reverser, Lever, Track) | **M751–M754 (Charm Chain, Crafting, Skeleton Charm, Charm Swap)** |
| Difficulty Model | D Band 97–113 | **D Band 100–116** (target $D_{\text{finale}} \approx 139$) |

## 4. Release Prerequisites
1. **CI Validation:** L7501–8000 ના 500 levels CI validator દ્વારા pre-validated હોવા જોઈએ.
2. **Metadata Asset:** `phase_16_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ હોવા જોઈએ.
3. **Remote Config Flag:** `maxPhase = 16` set થયેલ હોવું જોઈએ.
4. **Tutorial Cards:** Charm Chain ordering, Charm Crafting synthesis, Skeleton Charm universality અને Charm Swap localized tutorials.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_16_SCOPE_AND_RULES.md](./01_PHASE_16_SCOPE_AND_RULES.md) | Keys Deluxe rules, key crafting logic, chain constraints, limits |
| 02 | [02_LEVEL_PLAN_7501_8000.md](./02_LEVEL_PLAN_7501_8000.md) | 50-block slot map (L7501–8000), base intros, 45 variants, L8000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md) | Jewel Box rules, M751–M754 catalog cards, key synthesis tick order |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_16.md](./04_VARIANTS_AND_MODIFIERS_PHASE_16.md) | 45 variant slot definitions, deluxe-key modifier combinations |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_16.md](./05_REWARDS_AND_ECONOMY_PHASE_16.md) | Economy inflow/outflow, Craft Baskets, L8000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_16.md](./06_UI_AND_QA_PHASE_16.md) | Gem & charm rendering, key forging VFX, tier limits, QA checklist |

