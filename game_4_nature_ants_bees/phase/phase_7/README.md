# Phase 7 — Levels 3001–3500 (Whirling Garden)
> Ants & Bees: Garden Trails ના Phase 7 update નું scope, signature system (Rotation: Whirling Garden), 4 નવા base mechanics (M301–M304), 45 variants, on-device deterministic generation, release prerequisites અને Phase 7 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 6 index](../phase_6/README.md) · [Phase 8 index](../phase_8/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 7 = **Whirling Garden (Rotation) update** (રોટેટિંગ સબ-ગ્રીડ ટર્નટેબલ્સ, સરહદી ફરતી હેજ દીવાલો, સ્પિનિંગ ટોપ લાઈનો અને રોટેશન-ઇમ્યુન પિન્ડ ડેઇઝી). Phase 6 ના 3000 levels ક્લિયર કરનાર players માટે **L3001–3500** content:
1. **Signature System:** Rotation (Whirling Garden — સબ-બોર્ડ 90° CW રોટેશન, પેરિમીટર શિફ્ટિંગ, લાઈન સ્પિનિંગ સ્ટેટ્સ).
2. **4 New Base Mechanics:** M301 Flower-Bed Turntable, M302 Turning Hedge, M303 Spinning Top Line, M304 Pinned Daisy.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 7 Value | Source |
|---|---|---|
| Levels | 3001–3500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Rotation: Whirling Garden (Sub-board 90° CW turn, perimeter shift) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M301 (L3011), M302 (L3131), M303 (L3251), M304 (L3371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L3491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L3500 "Whirling Blossom Gala" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P7-A (3001–3250) · P7-B (3251–3500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Queen's Gift Box | 49 (L3010 … L3490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L3500: 1,000 coins + 2 of each booster + "Whirling Botanist" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L3025, 3050 … 3500), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 6
| Area | Phase 6 | Phase 7 |
|---|---|---|
| Core Focus | Light beams, color filters, shade patches | **Spatial Rotation & Orientation Shifting (Turntables, Rotating Edges)** |
| Board Dynamics | Linear raycasting & Move-based timers | Dynamic 90° CW sub-board rotation, perimeter wall shifts |
| Line Autonomy | Static lines, illuminated to unlock | **Spinning Top Lines (Dir rotates 90° CW each non-moving turn)** |
| Seed Metadata | `phase_6_meta.bin` | Shipped `phase_7_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Rotation Solver Verification:** L3001–3500 ના તમામ 500 levels rotation solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_7_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Rotation Coordinate Transform Determinism:** 90° CW rotation matrix $[x', y'] = [y, -x]$ transformation تمام પ્લેટફોર્મ્સ પર પિક્સેલ-પરફેક્ટ પરિણામ આપે.
4. **Remote Config Flag:** `maxPhase = 7` સેટ થતાં Phase 7 અનલૉક થાય.
5. **Tutorial Assets:** M301–M304 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_7_SCOPE_AND_RULES.md](./01_PHASE_7_SCOPE_AND_RULES.md) | Rotation rules, turntable boundaries, spinning line direction updates, limits |
| 02 | [02_LEVEL_PLAN_3001_3500.md](./02_LEVEL_PLAN_3001_3500.md) | 50-block slot map (L3001–3500), base intros, 45 variants, L3491 review, L3500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md) | Whirling Garden rules, M301–M304 cards, rotation matrix, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_7.md](./04_VARIANTS_AND_MODIFIERS_PHASE_7.md) | 45 variant slot definitions (Rotation mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_7.md](./05_REWARDS_AND_ECONOMY_PHASE_7.md) | Economy inflow/outflow, Gift Boxes, L3500 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_7.md](./06_UI_AND_QA_PHASE_7.md) | Turntable UI controls, rotation animations, whirling VFX, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P7-01:** Turntable smooth rotation animation duration: 250 ms vs 300 ms.
