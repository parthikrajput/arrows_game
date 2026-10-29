# Phase 18 — Levels 8501–9000 (Garden Festival I — Remix A)
> Ants & Bees: Garden Trails ના Phase 18 update નું scope, signature system (Remix A: Garden Festival I), 4 ડેટા-સંચાલિત કોમ્બો મિકેનિક્સ (M851–M854), 45 variants, on-device deterministic generation, release prerequisites અને Phase 18 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 17 index](../phase_17/README.md) · [Phase 19 index](../phase_19/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 18 = **Garden Festival I (Remix A) update** (Phases 1 થી 6 ની સર્વોચ્ચ સિસ્ટમ્સ — Cycles, Multi-floor, Push Physics+, Light & Beams+ નું સંયોજન). Phase 17 ના 8500 levels ક્લિયર કરનાર players માટે **L8501–9000** content:
1. **Signature System:** Remix A (Garden Festival I — અગાઉની સફળ મિકેનિક્સનું સીમલેસ હાઇબ્રિડાઇઝેશન).
2. **4 Data-Chosen Combo Mechanics:** M851 Day-Night Terrace, M852 Sunlit Acorn, M853 Shaded Stairs, M854 Dawn Marble (પ્લેયર એન્ગેજમેન્ટ ડેટા દ્વારા રેન્ક થયેલ કેન્ડિડેટ પૂલમાંથી).
3. **45 Variants:** Combo mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 18 Value | Source |
|---|---|---|
| Levels | 8501–9000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Remix A: Garden Festival I (Hybrid systems of Phases 1 to 6) | Standard §11, SCALING §7 |
| Combo Mechanics | 4: M851 (L8511), M852 (L8631), M853 (L8751), M854 (L8871) | Standard §11, §17.38; SCALING §7 |
| Selection Rule | Ranked by per-system completion rate, low churn & booster use | SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L8991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L9000 "Festival of Sunlight & Shadows" (Finale target D ≈ 91) | SCALING §3.5, §7 |
| Tiers | P18-A (8501–8750) · P18-B (8751–9000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 per floor (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all active layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Queen's Gift Box | 49 (L8510 … L8990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L9000: 1,000 coins + 2 of each booster + "Festival Grandee" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L8525, 8550 … 9000), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 17
| Area | Phase 17 | Phase 18 |
|---|---|---|
| Core Focus | Boss guardians with shared HP pools | **Cross-System Combinations (Remix A: P1–P6 Systems)** |
| Mechanic Genesis | Standalone single-theme features | **Composed Rules: Two parent mechanics fused into unified behavior** |
| Layer Depth | 3 layers on single ground board | Multi-floor vertical terraces interacting with day/night cycles & beams |
| Seed Metadata | `phase_17_meta.bin` | Shipped `phase_18_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Remix Solver Verification:** L8501–9000 ના તમામ 500 levels hybrid solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_18_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Analytics Selection Validation:** M851–M854 ના કોમ્બો કેન્ડિડેટ્સ ટેલિમેટ્રી ડેટા (D1–D30 completion metric) પર આધારિત હોવા જોઈએ.
4. **Remote Config Flag:** `maxPhase = 18` સેટ થતાં Phase 18 અનલૉક થાય.
5. **Tutorial Assets:** M851–M854 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_18_SCOPE_AND_RULES.md](./01_PHASE_18_SCOPE_AND_RULES.md) | Remix A rules, hybrid parent resolution, layer inheritance, limits |
| 02 | [02_LEVEL_PLAN_8501_9000.md](./02_LEVEL_PLAN_8501_9000.md) | 50-block slot map (L8501–9000), base intros, 45 variants, L8991 review, L9000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md) | Garden Festival I rules, M851–M854 cards, composition logic, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_18.md](./04_VARIANTS_AND_MODIFIERS_PHASE_18.md) | 45 variant slot definitions (Remix A mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_18.md](./05_REWARDS_AND_ECONOMY_PHASE_18.md) | Economy inflow/outflow, Gift Boxes, L9000 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_18.md](./06_UI_AND_QA_PHASE_18.md) | Hybrid UI badges, festival light VFX, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P18-01 (Data Selection):** અંતિમ લાઇવ ડેટા અનુસાર M851–M854 ઉમેદવાર પૂલમાંથી ચોક્કસ ટોપ-4 કોમ્બોઝની અંતિમ ફ્રીઝ (Day-Night Terrace vs Lens Terrace).
