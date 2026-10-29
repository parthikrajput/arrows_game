# Phase 6 — Levels 2501–3000 (Sun Temple Light)
> Snakes Slither ના Phase 6 update નું scope, signature system (Light & Beams+: Sun Temple Light), 4 નવા base mechanics (M251–M254), 45 variants, release prerequisites અને Phase 6 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 5 index](../phase_5/README.md) · [Phase 7 index](../phase_7/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 6 = **Advanced Light & Optics Puzzle Update**. Phase 5 પૂર્ણ કરનાર players માટે **L2501–3000** content:
1. **Signature System:** Sun Temple Light (Light & Beams+: કિરણોનું રંગ પરિવર્તન, મલ્ટી-બીમ પ્રિઝમ લોક્સ, સનડાયલ ટાઈમર્સ અને અંધારા સેલ્સ).
2. **4 New Base Mechanics:** M251 Petal Filter, M252 Prism Lock, M253 Sundial Receiver, M254 Shade Leaves.
3. **45 Variants:** Base mechanics × 10 generic modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L3000 "Sun Temple Grand Sanctum" + Jungle Treasure Chest.

## 2. Content Summary
| Item | Phase 6 Value | Source |
|---|---|---|
| Levels | 2501–3000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Sun Temple Light (Dynamic ray casting, color filters, beam timers) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M251 (L2511), M252 (L2631), M253 (L2751), M254 (L2871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L2991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L3000 "Sun Temple Grand Sanctum" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P6-A (2501–2750) · P6-B (2751–3000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Snakes Count | 28–40 snakes | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Jungle Gift Basket | 49 (L2510 … L2990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Jungle Treasure Chest | L3000: 1,000 coins + 2 of each booster + Phase 6 badge | Standard §6.1, SCALING §6 |
| Golden Slither Rush | 20 rounds (after L2525, 2550 … 3000), 30 snakes each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 5
| Area | Phase 5 | Phase 6 |
|---|---|---|
| Signature System | Push Physics+ (Coconut Grove) | **Light & Beams+ (Sun Temple Light)** |
| Optical Interactions| Static reflection (M084–M089) | **Chromatic Filtering (M251) & Multi-Beam Locks (M252)** |
| Temporal Optics | Instant state changes | **Consecutive Beam Timers (M253)** |
| Board Visibility | Uniform board illumination | **Shade Leaves & Dark Cells (M254)**: પ્રકાશ વિના સાપ લોક રહે છે |

## 4. Release Prerequisites
1. **CI Generator Run:** L2501–3000 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_6_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 6`.
5. **Tutorial Assets:** Light filter અને Shade leaves ના tutorial cards localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_6_SCOPE_AND_RULES.md](./01_PHASE_6_SCOPE_AND_RULES.md) | Optics additions, beam color matching, timer latching, dark cell locks |
| 02 | [02_LEVEL_PLAN_2501_3000.md](./02_LEVEL_PLAN_2501_3000.md) | 50-block slot map, M251–M254 intros, 45 variants, L2991 review, L3000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md) | Sun Temple Light rules, M251–M254 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_6.md](./04_VARIANTS_AND_MODIFIERS_PHASE_6.md) | 45 variant slots (Optics base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_6.md](./05_REWARDS_AND_ECONOMY_PHASE_6.md) | Economy inflow/outflow, Gift Baskets, L3000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_6.md](./06_UI_AND_QA_PHASE_6.md) | Beam rendering, color-blind glyphs, VFX, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P6-01:** Shade Leaves (M254) ના ડાર્ક સેલ્સ પર ટાઈલ ડાર્કનિંગ ગ્રેડિયન્ટ રાખવો કે સ્મૂથ નેચરલ લીફ શેડો? (હાલ 40% બ્લેક આલ્ફા લીફ શેડો નક્કી કરેલ છે).
