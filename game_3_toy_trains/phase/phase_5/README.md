# Phase 5 — Levels 2001–2500 (Yard Shunting+)
> Toy Trains: Wooden Railway Puzzle ના Phase 5 update નું scope, signature system (Push Physics+: Yard Shunting+), 4 નવા railway base mechanics (M201–M204), 45 variants, release prerequisites અને Phase 5 ના દરેક document નો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 4 index](../phase_4/README.md) · [Phase 6 index](../phase_6/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 5 = **Advanced Railway Push Physics Update**. Phase 4 પૂર્ણ કરનાર players માટે **L2001–2500** content:
1. **Signature System:** Yard Shunting+ (Push Physics+: કાર્ટ્સ અને વેગનને ટ્રેક પર ધકેલવાના નિયમો, ખાડા પૂરવા, સ્લાઇડિંગ કાર્ટ્સ, ટિકિટ કાર્ટ્સ અને હેવી બેલાસ્ટ કાર્ટ્સ).
2. **4 New Base Mechanics:** M201 Cart Pit, M202 Ice Block Cart, M203 Ticket Cart, M204 Ballast Cart.
3. **45 Variants:** Base mechanics × 10 generic railway modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L2500 "Shunting Master Terminal" + Grand Central Chest.

## 2. Content Summary
| Item | Phase 5 Value | Source |
|---|---|---|
| Levels | 2001–2500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Yard Shunting+ (Advanced Push Physics, Inertia & Momentum) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M201 (L2011), M202 (L2131), M203 (L2251), M204 (L2371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L2491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L2500 "Shunting Master Terminal" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P5-A (2001–2250) · P5-B (2251–2500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Train Count | 28–40 trains | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L2010 … L2490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Central Chest | L2500: 1,000 coins + 2 of each booster + Phase 5 badge | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L2025, 2050 … 2500), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 4
| Area | Phase 4 | Phase 5 |
|---|---|---|
| Signature System | Multi-Floor (Station Floors) | **Push Physics+ (Yard Shunting+)** |
| Terrain Modification | Fixed floors and stairs | **Track Repairing:** ખાડામાં કાર્ટ ધકેલીને નવો ટ્રેક બનાવવો (M201) |
| Inertia & Momentum | Single-step move | **Continuous Slide:** બરફના કાર્ટ અવરોધ ન આવે ત્યાં સુધી લપસે (M202) |
| Lock & Key System | Train-carried tickets | **Pushable Keys:** ટિકિટ કાર્ટને ધકેલીને બેરિયર પેડ પર મૂકવું (M203) |
| Mass & Resistance | Standard push | **Heavy Ballast Carts:** વાઇડ લોડ કે કપલ્ડ એન્જિન જ ધકેલી શકે (M204) |

## 4. Release Prerequisites
1. **CI Generator Run:** L2001–2500 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_5_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 5`.
5. **Tutorial Assets:** Shunting push physics cards અને M201–M204 tutorial cards localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_5_SCOPE_AND_RULES.md](./01_PHASE_5_SCOPE_AND_RULES.md) | Shunting push rules, pit filling, continuous sliding, heavy ballast mechanics |
| 02 | [02_LEVEL_PLAN_2001_2500.md](./02_LEVEL_PLAN_2001_2500.md) | 50-block slot map, M201–M204 intros, 45 variants, L2491 review, L2500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md) | Yard Shunting+ rules, M201–M204 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_5.md](./04_VARIANTS_AND_MODIFIERS_PHASE_5.md) | 45 variant slots (Push physics base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_5.md](./05_REWARDS_AND_ECONOMY_PHASE_5.md) | Economy inflow/outflow, Gift Crates, L2500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_5.md](./06_UI_AND_QA_PHASE_5.md) | Shunting arrow indicators, sliding dust VFX, performance, QA checklist |

