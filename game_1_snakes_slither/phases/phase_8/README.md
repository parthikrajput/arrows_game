# Phase 8 — Levels 3501–4000 (Overgrown Garden)
> Snakes Slither ના Phase 8 update નું scope, signature system (Growth: Overgrown Garden), 4 નવા base mechanics (M351–M354), 45 variants, release prerequisites અને Phase 8 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 7 index](../phase_7/README.md) · [Phase 9 index](../phase_9/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 8 = **Dynamic Growth & Weed Control Puzzle Update**. Phase 7 પૂર્ણ કરનાર players માટે **L3501–4000** content:
1. **Signature System:** Overgrown Garden (Growth: જંગલમાં આપોઆપ ફેલાતી વેલો, કાપણી ટાઇલ્સ, બીજ વાવતા સાપ અને બ્લૂમ ગેટ્સ).
2. **4 New Base Mechanics:** M351 Wild Vine, M352 Pruning Shears Tile, M353 Seed-Carrier Snake, M354 Bloom Gate.
3. **45 Variants:** Base mechanics × 10 generic modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L4000 "Heart of the Overgrowth" + Jungle Treasure Chest.

## 2. Content Summary
| Item | Phase 8 Value | Source |
|---|---|---|
| Levels | 3501–4000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Overgrown Garden (Multi-neighbour vine growth, dynamic clearing, seeds) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M351 (L3511), M352 (L3631), M353 (L3751), M354 (L3871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L3991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L4000 "Heart of the Overgrowth" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P8-A (3501–3750) · P8-B (3751–4000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Snakes Count | 28–40 snakes | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Jungle Gift Basket | 49 (L3510 … L3990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Jungle Treasure Chest | L4000: 1,000 coins + 2 of each booster + Phase 8 badge | Standard §6.1, SCALING §6 |
| Golden Slither Rush | 20 rounds (after L3525, 3550 … 4000), 30 snakes each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 7
| Area | Phase 7 | Phase 8 |
|---|---|---|
| Signature System | Rotation (Whirlwind Valley) | **Growth (Overgrown Garden)** |
| Board Mutation | Fixed geometry rotation | **Dynamic Entity Expansion (M351)**: વેલો દર N મૂવ્સે 2 પાડોશી સેલમાં ફેલાય |
| Pruning System | None | **Pruning Shears Tile (M352)**: લેન પસાર થતાં આસપાસની વેલો કપાઈ જાય |
| Exit Side Effects | Path leaves board cleanly | **Seed Drop (M353)**: સાપ નીકળતાં પાછળ બીજ મૂકે છે જે મોટું થાય છે |
| Win Conditions | Standard board clear | **Bloom Gate (M354)**: તમામ વેલો પ્રૂન થાય ત્યારે જ દરવાજો ખુલે |

## 4. Release Prerequisites
1. **CI Generator Run:** L3501–4000 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_8_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 8`.
5. **Tutorial Assets:** Vine pruning અને Seed growth ના tutorial cards localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_8_SCOPE_AND_RULES.md](./01_PHASE_8_SCOPE_AND_RULES.md) | Growth rules, multi-neighbour spread order, pruning mechanics, bloom gates |
| 02 | [02_LEVEL_PLAN_3501_4000.md](./02_LEVEL_PLAN_3501_4000.md) | 50-block slot map, M351–M354 intros, 45 variants, L3991 review, L4000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md) | Overgrown Garden rules, M351–M354 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_8.md](./04_VARIANTS_AND_MODIFIERS_PHASE_8.md) | 45 variant slots (Growth base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_8.md](./05_REWARDS_AND_ECONOMY_PHASE_8.md) | Economy inflow/outflow, Gift Baskets, L4000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_8.md](./06_UI_AND_QA_PHASE_8.md) | Growth pulse HUD, sprout VFX, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P8-01:** Pruning Shears Tile (M352) પરથી સાપ પસાર થાય ત્યારે પાંદડાં કપાવવાનો સાઉન્ડ સ્નિપ-સ્નિપ ASMR રાખવો કે મેટલ શીયર ક્લેક? (હાલ સોફ્ટ ક્રંચી લીફ સ્નિપ ASMR નક્કી છે).
