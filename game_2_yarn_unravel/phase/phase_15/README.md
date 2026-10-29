# Phase 15 — Levels 7001–7500 (Feed Dog Factory)
> Purpose: Yarn Unravel ના Phase 15 update નું scope, signature system (Conveyors & Tracks: Feed Dog Factory — belt switches, reversing belts, belt levers, track loops), 4 નવા base mechanics (M701–M704), 45 variants, ઑન-ડિવાઇસ જનરેશન અને Phase 15 docs નો index.

**Related docs:** [Game overview](../../README.md) · [Phases overview](../README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 14 index](../phase_14/README.md) · [Phase 16 index](../phase_16/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 15 players માટે **L7001–7500** content લાવે છે:
1. **Signature System: Conveyors & Tracks (Feed Dog Factory):** સિલાઈ મશીનના ફીડ ડોગ (Feed Dog) જેવા મિકેનાઇઝ્ડ કન્વેયર બેલ્ટ્સ અને ટ્રેક્સ જે દોરાઓને બોર્ડ પર ચોક્કસ દિશામાં સતત આગળ ધકેલે છે.
2. **4 New Base Mechanics:** M701 Belt Switch (Belt Junction), M702 Reversing Belt (Reversible Belt), M703 Belt Lever (Belt Lever), M704 Track Loop (Track Loop).
3. **45 Variants:** Base mechanics × 10 craft modifiers (`Knotted`, `Dyed`, `Fluffed`, `Ribbon-Tied`, વગેરે).
4. **Difficulty Band:** Fixed plateau **D 97–113** (standard §17.24).
5. **Phase Finale:** L7500 "The Feed Dog Engine" + Grand Sewing Chest.

## 2. Content Summary
| Item | Phase 15 Value | Source |
|---|---|---|
| Levels | 7001–7500 (On-device generated via seed) | Standard §11; SCALING §6, §7 |
| Signature System | Conveyors & Tracks (Feed Dog Factory, moving belts & closed tracks) | Standard §11, SCALING §7 |
| Base Mechanics | 4: M701 (L7011), M702 (L7131), M703 (L7251), M704 (L7371) | Standard §11, §17.38; SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §8 |
| Review Level | L7491 (Block 50 x1 — "Feed Dog Factory Mastery") | Standard §17.34, §17.38 |
| Finale | L7500 "The Feed Dog Engine" (Finale target D ≈ 135) | SCALING §3.5, §7 |
| Tiers | P15-A (7001–7250) · P15-B (7251–7500) | SCALING §3.5, §6 |
| Grid Bounds | 12×12–14×14 | SCALING §3.5 |
| Total Threads | 28–40 threads | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Craft Basket (Gift Box) | 49 (L7010 … L7490) × **300 coins** + 1 booster | Standard §6.1, SCALING §7 |
| Grand Sewing Chest | L7500: 1,000 coins + 2 of each booster + Phase 15 badge | Standard §6.1, SCALING §7 |
| Golden Bobbin Rush | 20 rounds (after L7025, 7050 … 7500), 30 threads each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 14
| Area | Phase 14 | Phase 15 |
|---|---|---|
| Signature System | Mirror Worlds (Looking-Glass Quilt) | **Conveyors & Tracks (Feed Dog Factory)** — motorized moving belts & loops |
| Board Dynamics | Bilateral mirror reflection | **Continuous conveyor translation**, periodic belt reversals, track riding |
| Base Mechanics | M651–M654 (Mirror Seam, Reflect Clasp, Twin Quilt, Inverse) | **M701–M704 (Belt Switch, Reversing Belt, Belt Lever, Track Loop)** |
| Difficulty Model | D Band 94–110 | **D Band 97–113** (target $D_{\text{finale}} \approx 135$) |

## 4. Release Prerequisites
1. **CI Validation:** L7001–7500 ના 500 levels CI validator દ્વારા pre-validated હોવા જોઈએ.
2. **Metadata Asset:** `phase_15_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ હોવા જોઈએ.
3. **Remote Config Flag:** `maxPhase = 15` set થયેલ હોવું જોઈએ.
4. **Tutorial Cards:** Belt Switch branch toggle, Reversing Belt timing, Belt Lever on/off અને Track Loop exits localized tutorials.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_15_SCOPE_AND_RULES.md](./01_PHASE_15_SCOPE_AND_RULES.md) | Feed Dog rules, conveyor kinematics, track loop circulation, limits |
| 02 | [02_LEVEL_PLAN_7001_7500.md](./02_LEVEL_PLAN_7001_7500.md) | 50-block slot map (L7001–7500), base intros, 45 variants, L7500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md) | Feed Dog Factory rules, M701–M704 catalog cards, conveyor tick order |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_15.md](./04_VARIANTS_AND_MODIFIERS_PHASE_15.md) | 45 variant slot definitions, conveyor-modifier combinations |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_15.md](./05_REWARDS_AND_ECONOMY_PHASE_15.md) | Economy inflow/outflow, Craft Baskets, L7500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_15.md](./06_UI_AND_QA_PHASE_15.md) | Feed Dog tread animation, conveyor arrow UI, tier limits, QA checklist |

