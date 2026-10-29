# Phase 19 — Levels 9001–9500 (Garden Festival II — Remix B)
> Ants & Bees: Garden Trails ના Phase 19 update નું scope, signature system (Remix B: Garden Festival II), 4 ડેટા-સંચાલિત કોમ્બો મિકેનિક્સ (M901–M904), 45 variants, on-device deterministic generation, release prerequisites અને Phase 19 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 18 index](../phase_18/README.md) · [Phase 20 index](../phase_20/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 19 = **Garden Festival II (Remix B) update** (Phases 7 થી 12 ની અદ્યતન સિસ્ટમ્સ — Rotation, Growth, Split/Merge, Sequencing, Linked Boards, Gravity નું સંયોજન). Phase 18 ના 9000 levels ક્લિયર કરનાર players માટે **L9001–9500** content:
1. **Signature System:** Remix B (Garden Festival II — મધ્ય-ગાળાની ગતિશીલ સિસ્ટમ્સનું સંકલન).
2. **4 Data-Chosen Combo Mechanics:** M901 Falling Vines, M902 Rhythm Rotor, M903 Twin-Garden Fork, M904 Gravity Turntable (પ્લેયર એન્ગેજમેન્ટ ડેટા દ્વારા રેન્ક થયેલ કેન્ડિડેટ પૂલમાંથી).
3. **45 Variants:** Combo mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 19 Value | Source |
|---|---|---|
| Levels | 9001–9500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Remix B: Garden Festival II (Hybrid systems of Phases 7 to 12) | Standard §11, SCALING §7 |
| Combo Mechanics | 4: M901 (L9011), M902 (L9131), M903 (L9251), M904 (L9371) | Standard §11, §17.38; SCALING §7 |
| Selection Rule | Ranked by per-system completion rate, low churn & booster use | SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L9491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L9500 "Festival of Winds & Blooms" (Finale target D ≈ 91) | SCALING §3.5, §7 |
| Tiers | P19-A (9001–9250) · P19-B (9251–9500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 per board (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all active layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Queen's Gift Box | 49 (L9010 … L9490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L9500: 1,000 coins + 2 of each booster + "Master Composer" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L9025, 9050 … 9500), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 18
| Area | Phase 18 | Phase 19 |
|---|---|---|
| Systems Scope | Phases 1–6 (Cycles, Terraces, Push, Beams) | **Phases 7–12 (Rotation, Growth, Split/Merge, Rhythm, Dual Boards, Gravity)** |
| Dynamics | Stationary hybrid mechanics | **Kinetic Hybrids: Rotating boards under gravity, vines sliding in wind** |
| Cross-Board Splits| Single board splits / terrace shifts | Fork twigs splitting lines across separate linked garden boards |
| Seed Metadata | `phase_18_meta.bin` | Shipped `phase_19_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Remix B Solver Verification:** L9001–9500 ના તમામ 500 levels hybrid solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_19_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Analytics Selection Validation:** M901–M904 ના કોમ્બો કેન્ડિડેટ્સ ટેલિમેટ્રી ડેટા (D7–D12 completion metric) પર આધારિત હોવા જોઈએ.
4. **Remote Config Flag:** `maxPhase = 19` સેટ થતાં Phase 19 અનલૉક થાય.
5. **Tutorial Assets:** M901–M904 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_19_SCOPE_AND_RULES.md](./01_PHASE_19_SCOPE_AND_RULES.md) | Remix B rules, kinetic combinations, gravity-rotation interaction, limits |
| 02 | [02_LEVEL_PLAN_9001_9500.md](./02_LEVEL_PLAN_9001_9500.md) | 50-block slot map (L9001–9500), base intros, 45 variants, L9491 review, L9500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md) | Garden Festival II rules, M901–M904 cards, composition logic, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_19.md](./04_VARIANTS_AND_MODIFIERS_PHASE_19.md) | 45 variant slot definitions (Remix B mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_19.md](./05_REWARDS_AND_ECONOMY_PHASE_19.md) | Economy inflow/outflow, Gift Boxes, L9500 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_19.md](./06_UI_AND_QA_PHASE_19.md) | Kinetic hybrid UI indicators, wind & petal VFX, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P19-01 (Data Selection):** અંતિમ લાઇવ ડેટા અનુસાર M901–M904 ઉમેદવાર પૂલમાંથી ચોક્કસ ટોપ-4 કોમ્બોઝની અંતિમ ફ્રીઝ (Gravity Turntable vs Rhythm Rotor).
