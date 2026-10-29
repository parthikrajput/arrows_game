# Phase 14 — Levels 6501–7000 (Reflecting Pond)
> Ants & Bees: Garden Trails ના Phase 14 update નું scope, signature system (Mirror Worlds: Reflecting Pond), 4 નવા base mechanics (M651–M654), 45 variants, on-device deterministic generation, release prerequisites અને Phase 14 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 13 index](../phase_13/README.md) · [Phase 15 index](../phase_15/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 14 = **Reflecting Pond (Mirror Worlds) update** (પાણીના તળાવની મિરર અક્ષ, રીફ્લેક્ટેડ સિન્ક્રોનસ લાઈનો, રીફ્લેક્શન લૉક્સ, ટ્વિન પોન્ડ બોર્ડ્સ અને ઇન્વર્સ પાથ લાઈનો). Phase 13 ના 6500 levels ક્લિયર કરનાર players માટે **L6501–7000** content:
1. **Signature System:** Mirror Worlds (Reflecting Pond — બોર્ડ-વિભાજક પ્રતિબિંબ અક્ષ, સમપ્રમાણ ગતિ, ઉલટી દિશાની લાઈનો).
2. **4 New Base Mechanics:** M651 Pond Axis, M652 Reflection Lock, M653 Twin Pond, M654 Upside-Down Line.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 14 Value | Source |
|---|---|---|
| Levels | 6501–7000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Mirror Worlds: Reflecting Pond (Mirror axis, reflection locks, inverted paths) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M651 (L6511), M652 (L6631), M653 (L6751), M654 (L6871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L6991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L7000 "Mirrored Solstice Gala" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P14-A (6501–6750) · P14-B (6751–7000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Queen's Gift Box | 49 (L6510 … L6990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L7000: 1,000 coins + 2 of each booster + "Mirror Mirage Master" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L6525, 6550 … 7000), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 13
| Area | Phase 13 | Phase 14 |
|---|---|---|
| Core Focus | Fog of war & information scouting | **Bilateral Symmetry & Mirrored Physics (Reflecting Pond)** |
| Line Coupling | Independent lines with scout triggers | **Bilateral Pairs: Tapping one line moves its mirrored counterpart** |
| Path Direction | Direction matches visual insect head | **Upside-Down Lines (Effective direction is mirrored across pond axis)** |
| Seed Metadata | `phase_13_meta.bin` | Shipped `phase_14_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Mirror Worlds Solver Verification:** L6501–7000 ના તમામ 500 levels mirror simulation solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_14_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Axis Symmetry Transformation Determinism:** Mirror axis $[x', y'] = [2x_{\text{axis}} - x, y]$ transformation તમામ પ્લેટફોર્મ્સ પર એકસમાન રીતે ટ્રેસ થવું જોઈએ.
4. **Remote Config Flag:** `maxPhase = 14` સેટ થતાં Phase 14 અનલૉક થાય.
5. **Tutorial Assets:** M651–M654 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_14_SCOPE_AND_RULES.md](./01_PHASE_14_SCOPE_AND_RULES.md) | Mirror axis rules, synchronized twin taps, reflection locks, limits |
| 02 | [02_LEVEL_PLAN_6501_7000.md](./02_LEVEL_PLAN_6501_7000.md) | 50-block slot map (L6501–7000), base intros, 45 variants, L6991 review, L7000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md) | Reflecting Pond rules, M651–M654 cards, reflection symmetry order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_14.md](./04_VARIANTS_AND_MODIFIERS_PHASE_14.md) | 45 variant slot definitions (Mirror Worlds mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_14.md](./05_REWARDS_AND_ECONOMY_PHASE_14.md) | Economy inflow/outflow, Gift Boxes, L7000 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_14.md](./06_UI_AND_QA_PHASE_14.md) | Water ripple axis shader, inverted head icons, mirror VFX, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P14-01:** Water ripple shimmer frequency on pond axis: 1.5 Hz vs 2.0 Hz.

