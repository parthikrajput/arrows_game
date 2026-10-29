# Phase 17 — Levels 8001–8500 (Pincushion Court)
> Purpose: Yarn Unravel ના Phase 17 update નું scope, signature system (Guardians: Pincushion Court — twin pincushions, armoured pincushions, seeding pincushions, heart pincushions), 4 નવા base mechanics (M801–M804), 45 variants, ઑન-ડિવાઇસ જનરેશન અને Phase 17 docs નો index.

**Related docs:** [Game overview](../../README.md) · [Phases overview](../README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 16 index](../phase_16/README.md) · [Phase 18 index](../phase_18/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 17 players માટે **L8001–8500** content લાવે છે:
1. **Signature System: Guardians (Pincushion Court):** ક્રાફ્ટ બોર્ડ પર વિશાળ રોયલ પિનકુશન્સ (Pincushions) જે બોસ જેવા અવરોધો તરીકે વર્તે છે—સંયુક્ત HP પૂલ્સ, યાંત્રિક શિલ્ડ્સ, બટન સ્પૉનિંગ અને હાર્ટ કોર વલ્નરેબિલિટી.
2. **4 New Base Mechanics:** M801 Twin Pincushions (Twin Guardian), M802 Armoured Pincushion (Shield Guardian), M803 Seeding Pincushion (Spawner Guardian), M804 Heart Pincushion (Guardian Core).
3. **45 Variants:** Base mechanics × 10 craft modifiers (`Knotted`, `Dyed`, `Fluffed`, `Ribbon-Tied`, વગેરે).
4. **Difficulty Band:** Fixed plateau **D 103–119** (standard §17.24).
5. **Phase Finale:** L8500 "The Pincushion Sovereign" + Grand Sewing Chest.

## 2. Content Summary
| Item | Phase 17 Value | Source |
|---|---|---|
| Levels | 8001–8500 (On-device generated via seed) | Standard §11; SCALING §6, §7 |
| Signature System | Guardians (Pincushion Court, boss-scale HP guardians) | Standard §11, SCALING §7 |
| Base Mechanics | 4: M801 (L8011), M802 (L8131), M803 (L8251), M804 (L8371) | Standard §11, §17.38; SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §8 |
| Review Level | L8491 (Block 50 x1 — "Pincushion Court Mastery") | Standard §17.34, §17.38 |
| Finale | L8500 "The Pincushion Sovereign" (Finale target D ≈ 142) | SCALING §3.5, §7 |
| Tiers | P17-A (8001–8250) · P17-B (8251–8500) | SCALING §3.5, §6 |
| Grid Bounds | 12×12–14×14 | SCALING §3.5 |
| Total Threads | 28–40 threads | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Craft Basket (Gift Box) | 49 (L8010 … L8490) × **300 coins** + 1 booster | Standard §6.1, SCALING §7 |
| Grand Sewing Chest | L8500: 1,000 coins + 2 of each booster + Phase 17 badge | Standard §6.1, SCALING §7 |
| Golden Bobbin Rush | 20 rounds (after L8025, 8050 … 8500), 30 threads each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 16
| Area | Phase 16 | Phase 17 |
|---|---|---|
| Signature System | Keys Deluxe (Jewel Box) | **Guardians (Pincushion Court)** — multi-cell HP boss obstacles |
| Board Dynamics | Key synthesis & charm chains | **Pincushion damage mechanics**, button spawners, core beam alignments |
| Base Mechanics | M751–M754 (Charm Chain, Crafting, Skeleton) | **M801–M804 (Twin Pincushions, Armoured, Seeding, Heart Pincushion)** |
| Difficulty Model | D Band 100–116 | **D Band 103–119** (target $D_{\text{finale}} \approx 142$) |

## 4. Release Prerequisites
1. **CI Validation:** L8001–8500 ના 500 levels CI validator દ્વારા pre-validated હોવા જોઈએ.
2. **Metadata Asset:** `phase_17_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ હોવા જોઈએ.
3. **Remote Config Flag:** `maxPhase = 17` set થયેલ હોવું જોઈએ.
4. **Tutorial Cards:** Twin Pincushion shared HP, Armoured shielding, Seeding button spawns અને Heart Core beams localized tutorials.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_17_SCOPE_AND_RULES.md](./01_PHASE_17_SCOPE_AND_RULES.md) | Guardians rules, HP damage models, spawner rules, limits |
| 02 | [02_LEVEL_PLAN_8001_8500.md](./02_LEVEL_PLAN_8001_8500.md) | 50-block slot map (L8001–8500), base intros, 45 variants, L8500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md) | Pincushion Court rules, M801–M804 catalog cards, guardian tick order |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_17.md](./04_VARIANTS_AND_MODIFIERS_PHASE_17.md) | 45 variant slot definitions, guardian-modifier combinations |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_17.md](./05_REWARDS_AND_ECONOMY_PHASE_17.md) | Economy inflow/outflow, Craft Baskets, L8500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_17.md](./06_UI_AND_QA_PHASE_17.md) | Pincushion HP bars, pin-pulling VFX, tier limits, QA checklist |

