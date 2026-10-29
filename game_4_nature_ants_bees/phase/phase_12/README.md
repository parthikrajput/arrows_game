# Phase 12 — Levels 5501–6000 (Falling Leaves)
> Ants & Bees: Garden Trails ના Phase 12 update નું scope, signature system (Gravity: Falling Leaves), 4 નવા base mechanics (M551–M554), 45 variants, on-device deterministic generation, release prerequisites અને Phase 12 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 11 index](../phase_11/README.md) · [Phase 13 index](../phase_13/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 12 = **Falling Leaves (Gravity) update** (દિશાકીય ગુરુત્વાકર્ષણ લીવર, પડતાં એકોર્ન બ્લોકર્સ, એન્ટિ-ગ્રેવિટી ડેંડિલિઅન ટાઇલ્સ અને વજનદાર બીટલ લાઈનો). Phase 11 ના 5500 levels ક્લિયર કરનાર players માટે **L5501–6000** content:
1. **Signature System:** Gravity (Falling Leaves — ચાર દિશાઓમાં ગુરુત્વાકર્ષણ પ્રવાહ, મૂવ પછી મુક્ત ઘટકોનું પતન).
2. **4 New Base Mechanics:** M551 Wind-Vane Lever, M552 Falling Acorns, M553 Dandelion Puff Tile, M554 Heavy Beetle Line.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 12 Value | Source |
|---|---|---|
| Levels | 5501–6000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Gravity: Falling Leaves (Gravity dir, falling loose items 1 cell/Move) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M551 (L5511), M552 (L5631), M553 (L5751), M554 (L5871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L5991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L6000 "Autumn Gale Gala" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P12-A (5501–5750) · P12-B (5751–6000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Queen's Gift Box | 49 (L5510 … L5990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L6000: 1,000 coins + 2 of each booster + "Wind Whisperer" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L5525, 5550 … 6000), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 11
| Area | Phase 11 | Phase 12 |
|---|---|---|
| Core Focus | Multi-board spatial transitions | **Environmental Gravity & Inertial Physics (Falling Leaves)** |
| Dynamic Elements | Stationary gates & cross-keys | Loose items and heavy beetles translate 1 cell per Move in gravity dir |
| Flying vs Ground | Bees affected equally by portals | **Bees fly immune to gravity; Ground Ants & Heavy Beetles fall** |
| Seed Metadata | `phase_11_meta.bin` | Shipped `phase_12_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Gravity Solver Verification:** L5501–6000 ના તમામ 500 levels gravity solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_12_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Gravity Settlement Determinism:** દરેક Move પછી તમામ મુક્ત ઘટકોનું 1 સેલ ગુરુત્વાકર્ષણ પતન تمام પ્લેટફોર્મ્સ પર એકસમાન રીતે ટિક થવું જોઈએ.
4. **Remote Config Flag:** `maxPhase = 12` સેટ થતાં Phase 12 અનલૉક થાય.
5. **Tutorial Assets:** M551–M554 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_12_SCOPE_AND_RULES.md](./01_PHASE_12_SCOPE_AND_RULES.md) | Gravity rules, vector shift, anti-gravity immunity, falling blocker limits |
| 02 | [02_LEVEL_PLAN_5501_6000.md](./02_LEVEL_PLAN_5501_6000.md) | 50-block slot map (L5501–6000), base intros, 45 variants, L5991 review, L6000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md) | Falling Leaves rules, M551–M554 cards, settlement order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_12.md](./04_VARIANTS_AND_MODIFIERS_PHASE_12.md) | 45 variant slot definitions (Gravity mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_12.md](./05_REWARDS_AND_ECONOMY_PHASE_12.md) | Economy inflow/outflow, Gift Boxes, L6000 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_12.md](./06_UI_AND_QA_PHASE_12.md) | Wind-vane HUD arrow, falling leaf VFX, tumble audio, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P12-01:** Gravity shift wind gust particle duration: 160 ms vs 200 ms.

