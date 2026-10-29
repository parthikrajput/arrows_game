# Phase 6 — Levels 2501–3000 (Sunlit Garden)
> Ants & Bees: Garden Trails ના Phase 6 update નું scope, signature system (Light & Beams+: Sunlit Garden), 4 નવા base mechanics (M251–M254), 45 variants, on-device deterministic generation, release prerequisites અને Phase 6 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 5 index](../phase_5/README.md) · [Phase 7 index](../phase_7/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 6 = **Sunlit Garden (Light & Beams+) update** (પ્રકાશના કિરણો, કલર ફિલ્ટર્સ, ટ્વિન-સન સ્પ્લિટ લૉક્સ, મૂવ-આધારિત સનડાયલ ટાઇમર્સ અને છાયડાવાળા ડાર્ક સેલ્સ). Phase 5 ના 2500 levels ક્લિયર કરનાર players માટે **L2501–3000** content:
1. **Signature System:** Light & Beams+ (Sunlit Garden — રંગીન કિરણો, ડ્યુઅલ રિસીવર પઝલ્સ, પિરિયોડિક બીમ એમિટર્સ, શેડેડ લાઇન્સ).
2. **4 New Base Mechanics:** M251 Petal Filter, M252 Twin-Sun Lock, M253 Sundial Lens, M254 Shade Patch.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 6 Value | Source |
|---|---|---|
| Levels | 2501–3000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Light & Beams+: Sunlit Garden (Filters, Dual Receivers, Timed Lenses) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M251 (L2511), M252 (L2631), M253 (L2751), M254 (L2871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L2991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L3000 "Sunlit Jubilee Gala" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P6-A (2501–2750) · P6-B (2751–3000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Queen's Gift Box | 49 (L2510 … L2990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L3000: 1,000 coins + 2 of each booster + "Master of Light" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L2525, 2550 … 3000), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 5
| Area | Phase 5 | Phase 6 |
|---|---|---|
| Core Focus | Push Physics+ (Acorn Physics) | **Light & Beams+ (Optical routing, Filters, Solar Timers, Shade)** |
| Optical Routing | Basic single-color sunbeams (Phase 2) | Multi-color petal filters, dual-receiver split locks |
| Environmental State| Uniform garden lighting | Shade patches (Dark cells) that lock lines until illuminated |
| Seed Metadata | `phase_5_meta.bin` | Shipped `phase_6_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Optical Solver Verification:** L2501–3000 ના તમામ 500 levels beam tracer solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_6_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Cross-Platform Determinism:** Beam reflection, refraction અને filtration ગણતરી તમામ ડિવાઇસ પર byte-identical હોવી જોઈએ.
4. **Remote Config Flag:** `maxPhase = 6` સેટ થતાં Phase 6 અનલૉક થાય.
5. **Tutorial Assets:** M251–M254 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_6_SCOPE_AND_RULES.md](./01_PHASE_6_SCOPE_AND_RULES.md) | Light & Beams+ rules, color filtering, sundial timers, dark cell illumination |
| 02 | [02_LEVEL_PLAN_2501_3000.md](./02_LEVEL_PLAN_2501_3000.md) | 50-block slot map (L2501–3000), base intros, 45 variants, L2991 review, L3000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md) | Sunlit Garden rules, M251–M254 cards, optical raycasting, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_6.md](./04_VARIANTS_AND_MODIFIERS_PHASE_6.md) | 45 variant slot definitions (Optical mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_6.md](./05_REWARDS_AND_ECONOMY_PHASE_6.md) | Economy inflow/outflow, Gift Boxes, L3000 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_6.md](./06_UI_AND_QA_PHASE_6.md) | Sundial timer HUD, additive beam VFX, performance budgets, QA checklist |

---

## 6. Open Decisions
- **OD-P6-01:** Colored beam filter blend intensity: 0.85 alpha vs 1.0 full saturation on high-contrast displays.
