# Phase 12 — Levels 5501–6000 (Hanging Loom)
> Purpose: Yarn Unravel ના Phase 12 update નું scope, signature system (Gravity: Hanging Loom — plumb levers, dropping buttons, float patches, weighted threads), 4 નવા base mechanics (M551–M554), 45 variants, ઑન-ડિવાઇસ જનરેશન અને Phase 12 docs નો index.

**Related docs:** [Game overview](../../README.md) · [Phases overview](../README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 11 index](../phase_11/README.md) · [Phase 13 index](../phase_13/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 12 players માટે **L5501–6000** content લાવે છે:
1. **Signature System: Gravity (Hanging Loom):** ક્રાફ્ટ લૂમ પર ગુરુત્વાકર્ષણ (Gravity) ની દિશા બદલતી પ્લમ્બ લીવર્સ અને દરેક મૂવ પછી પડતાં લૂઝ બટન્સ અને વેઇટેડ યાર્ન થ્રેડ્સ.
2. **4 New Base Mechanics:** M551 Plumb Lever (Gravity Lever), M552 Dropping Buttons (Falling Blockers), M553 Float Patch (Anti-grav Tile), M554 Weighted Thread (Weight Path).
3. **45 Variants:** Base mechanics × 10 craft modifiers (`Knotted`, `Dyed`, `Fluffed`, `Ribbon-Tied`, વગેરે).
4. **Difficulty Band:** Fixed plateau **D 88–104** (standard §17.24).
5. **Phase Finale:** L6000 "The Plumb Line Tapestry" + Grand Sewing Chest.

## 2. Content Summary
| Item | Phase 12 Value | Source |
|---|---|---|
| Levels | 5501–6000 (On-device generated via seed) | Standard §11; SCALING §6, §7 |
| Signature System | Gravity (Hanging Loom, directional gravity shifts) | Standard §11, SCALING §7 |
| Base Mechanics | 4: M551 (L5511), M552 (L5631), M553 (L5751), M554 (L5871) | Standard §11, §17.38; SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §8 |
| Review Level | L5991 (Block 50 x1 — "Hanging Loom Mastery") | Standard §17.34, §17.38 |
| Finale | L6000 "The Plumb Line Tapestry" (Finale target D ≈ 125) | SCALING §3.5, §7 |
| Tiers | P12-A (5501–5750) · P12-B (5751–6000) | SCALING §3.5, §6 |
| Grid Bounds | 12×12–14×14 | SCALING §3.5 |
| Total Threads | 28–40 threads | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Craft Basket (Gift Box) | 49 (L5510 … L5990) × **300 coins** + 1 booster | Standard §6.1, SCALING §7 |
| Grand Sewing Chest | L6000: 1,000 coins + 2 of each booster + Phase 12 badge | Standard §6.1, SCALING §7 |
| Golden Bobbin Rush | 20 rounds (after L5525, 5550 … 6000), 30 threads each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 11
| Area | Phase 11 | Phase 12 |
|---|---|---|
| Signature System | Linked Boards (Twin Hoops) | **Gravity (Hanging Loom)** — 4-directional board gravity shifts |
| Board Dynamics | Cross-hoop edge transitions | **Dropping loose buttons**, sliding weighted threads, anti-grav patches |
| Base Mechanics | M501–M504 (Seam Edge, Cross Charm, Mirror Hoop, Relay Pompom) | **M551–M554 (Plumb Lever, Dropping Buttons, Float Patch, Weighted Thread)** |
| Difficulty Model | D Band 85–101 | **D Band 88–104** (target $D_{\text{finale}} \approx 125$) |

## 4. Release Prerequisites
1. **CI Validation:** L5501–6000 ના 500 levels CI validator દ્વારા pre-validated હોવા જોઈએ.
2. **Metadata Asset:** `phase_12_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ હોવા જોઈએ.
3. **Remote Config Flag:** `maxPhase = 12` set થયેલ હોવું જોઈએ.
4. **Tutorial Cards:** Plumb Lever gravity toggle, Dropping Buttons, Float Patch અને Weighted Thread localized tutorials.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_12_SCOPE_AND_RULES.md](./01_PHASE_12_SCOPE_AND_RULES.md) | Gravity rules, falling physics, plumb lever states, limits |
| 02 | [02_LEVEL_PLAN_5501_6000.md](./02_LEVEL_PLAN_5501_6000.md) | 50-block slot map (L5501–6000), base intros, 45 variants, L6000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md) | Hanging Loom rules, M551–M554 catalog cards, gravity tick order |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_12.md](./04_VARIANTS_AND_MODIFIERS_PHASE_12.md) | 45 variant slot definitions, gravity-modifier combinations |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_12.md](./05_REWARDS_AND_ECONOMY_PHASE_12.md) | Economy inflow/outflow, Craft Baskets, L6000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_12.md](./06_UI_AND_QA_PHASE_12.md) | Gravity direction arrow UI, falling button VFX, tier limits, QA checklist |

