# Phase 8 — Levels 3501–4000 (Bloom Season)
> Ants & Bees: Garden Trails ના Phase 8 update નું scope, signature system (Growth: Bloom Season), 4 નવા base mechanics (M351–M354), 45 variants, on-device deterministic generation, release prerequisites અને Phase 8 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 7 index](../phase_7/README.md) · [Phase 9 index](../phase_9/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 8 = **Bloom Season (Growth) update** (સતત વિસ્તરતી મોર્નિંગ ગ્લોરી વેલો, ગાર્ડન કાતર દ્વારા કાપણી, એક્ઝિટ પછી બીજ છોડતી લાઈનો અને પરાગરજ ગેટ્સ). Phase 7 ના 3500 levels ક્લિયર કરનાર players માટે **L3501–4000** content:
1. **Signature System:** Growth (Bloom Season — મૂવ-આધારિત વેલનો ફેલાવો, પ્રોએક્ટિવ પ્રૂનિંગ, સીડ ગ્રોથ ટાઇમર્સ).
2. **4 New Base Mechanics:** M351 Morning Glory Vine, M352 Garden Shears, M353 Seed-Dropping Line, M354 Pollination Gate.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 8 Value | Source |
|---|---|---|
| Levels | 3501–4000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Growth: Bloom Season (Vine spreading, dynamic blockers, pruning) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M351 (L3511), M352 (L3631), M353 (L3751), M354 (L3871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L3991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L4000 "Eternal Bloom Gala" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P8-A (3501–3750) · P8-B (3751–4000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Queen's Gift Box | 49 (L3510 … L3990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L4000: 1,000 coins + 2 of each booster + "Master Florist" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L3525, 3550 … 4000), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 7
| Area | Phase 7 | Phase 8 |
|---|---|---|
| Core Focus | Rotations and directional shifts | **Dynamic Board Growth, Spreading Vines & Pruning Strategies** |
| Terrain Behavior | Rotating sub-grids & hedges | Organically expanding Morning Glory vines expanding every N Moves |
| Line Exits | Direction-spinning lines | **Seed-Dropping Lines (leave latent seeds that grow into blockers)** |
| Seed Metadata | `phase_7_meta.bin` | Shipped `phase_8_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Growth Solver Verification:** L3501–4000 ના તમામ 500 levels growth simulation solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_8_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Growth Cross-Expansion Determinism:** દર $N$ Moves એ વેલનો ચારેય ઓર્થોગોનલ દિશામાં ફેલાવો (U, R, D, L) તમામ પ્લેટફોર્મ્સ પર સમાન રીતે થવો જોઈએ.
4. **Remote Config Flag:** `maxPhase = 8` સેટ થતાં Phase 8 અનલૉક થાય.
5. **Tutorial Assets:** M351–M354 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_8_SCOPE_AND_RULES.md](./01_PHASE_8_SCOPE_AND_RULES.md) | Growth rules, vine propagation rate, shears cutting, seed countdown, limits |
| 02 | [02_LEVEL_PLAN_3501_4000.md](./02_LEVEL_PLAN_3501_4000.md) | 50-block slot map (L3501–4000), base intros, 45 variants, L3991 review, L4000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md) | Bloom Season rules, M351–M354 cards, expansion order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_8.md](./04_VARIANTS_AND_MODIFIERS_PHASE_8.md) | 45 variant slot definitions (Growth mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_8.md](./05_REWARDS_AND_ECONOMY_PHASE_8.md) | Economy inflow/outflow, Gift Boxes, L4000 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_8.md](./06_UI_AND_QA_PHASE_8.md) | Growth counter badges, vine spreading animations, pruning VFX, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P8-01:** Shears snipping animation duration: 180 ms vs 220 ms.
