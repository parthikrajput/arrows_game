# Phase 11 — Levels 5001–5500 (Twin Gardens)
> Ants & Bees: Garden Trails ના Phase 11 update નું scope, signature system (Linked Boards: Twin Gardens), 4 નવા base mechanics (M501–M504), 45 variants, on-device deterministic generation, release prerequisites અને Phase 11 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 10 index](../phase_10/README.md) · [Phase 12 index](../phase_12/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 11 = **Twin Gardens (Linked Boards) update** (બાજુબાજુમાં રહેલા બે ગાર્ડન બોર્ડ્સ, બોર્ડ-ટુ-બોર્ડ ગેટ લિંક્સ, ક્રોસ-બોર્ડ પેન-પાલ કી, મિરર બોર્ડ સિન્ક્રોનાઇઝેશન અને રિલે બરો પોર્ટલ્સ). Phase 10 ના 5000 levels ક્લિયર કરનાર players માટે **L5001–5500** content:
1. **Signature System:** Linked Boards (Twin Gardens — બોર્ડ A અને બોર્ડ B વચ્ચે ટ્રાન્ઝિશન, ડ્યુઅલ વ્યૂપોર્ટ સ્વિચ/ઝૂમ).
2. **4 New Base Mechanics:** M501 Garden Gate Link, M502 Pen-Pal Key, M503 Reflecting Pond Board, M504 Relay Burrow.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 11 Value | Source |
|---|---|---|
| Levels | 5001–5500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Linked Boards: Twin Gardens (2 mini boards, edge crossing, cross keys) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M501 (L5011), M502 (L5131), M503 (L5251), M504 (L5371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L5491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L5500 "Twin Garden Jubilee" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P11-A (5001–5250) · P11-B (5251–5500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 per board (2 boards, zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across both boards and layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances across boards | SCALING §3.5 |
| Queen's Gift Box | 49 (L5010 … L5490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L5500: 1,000 coins + 2 of each booster + "Twin Realm Navigator" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L5025, 5050 … 5500), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 10
| Area | Phase 10 | Phase 11 |
|---|---|---|
| Core Focus | Temporal rhythm & exit sequencing | **Spatial Dual Boards & Cross-Board Interactivity (Linked Boards)** |
| Viewport Topology| Single board grid | **Dual Board Layout (Board A & Board B)** with seamless pan or board-switch tab |
| Boundary Behavior| Board perimeter = exit | Board edge can transition lines directly into adjacent board |
| Seed Metadata | `phase_10_meta.bin` | Shipped `phase_11_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Dual-Board Solver Verification:** L5001–5500 ના તમામ 500 levels linked boards solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_11_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Cross-Board Transition Determinism:** બોર્ડ A માંથી બોર્ડ B માં લાઈનનું ટ્રાન્ઝિશન તમામ ડિવાઇસીસ પર ફ્રેમ-પરફેક્ટ હોવું જોઈએ.
4. **Remote Config Flag:** `maxPhase = 11` સેટ થતાં Phase 11 અનલૉક થાય.
5. **Tutorial Assets:** M501–M504 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_11_SCOPE_AND_RULES.md](./01_PHASE_11_SCOPE_AND_RULES.md) | Linked boards rules, cross-edge continuity, cross-board keys, limits |
| 02 | [02_LEVEL_PLAN_5001_5500.md](./02_LEVEL_PLAN_5001_5500.md) | 50-block slot map (L5001–5500), base intros, 45 variants, L5491 review, L5500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md) | Twin Gardens rules, M501–M504 cards, inter-board transition order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_11.md](./04_VARIANTS_AND_MODIFIERS_PHASE_11.md) | 45 variant slot definitions (Linked Boards mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_11.md](./05_REWARDS_AND_ECONOMY_PHASE_11.md) | Economy inflow/outflow, Gift Boxes, L5500 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_11.md](./06_UI_AND_QA_PHASE_11.md) | Dual-board HUD tabs, mini-map link preview, portal VFX, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P11-01:** Board switch camera pan duration: 250 ms easeInOut vs instant snap with swipe gesture.

