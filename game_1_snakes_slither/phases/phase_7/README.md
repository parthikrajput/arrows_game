# Phase 7 — Levels 3001–3500 (Whirlwind Valley)
> Snakes Slither ના Phase 7 update નું scope, signature system (Rotation: Whirlwind Valley), 4 નવા base mechanics (M301–M304), 45 variants, release prerequisites અને Phase 7 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 6 index](../phase_6/README.md) · [Phase 8 index](../phase_8/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 7 = **Rotational Geometry & Shifting Board Puzzle Update**. Phase 6 પૂર્ણ કરનાર players માટે **L3001–3500** content:
1. **Signature System:** Whirlwind Valley (Rotation: 4×4 સબ-બોર્ડ રોટેશન, ફરતી કિનારીઓ, સ્પિનિંગ સાપ અને ગિયર લોક્સ).
2. **4 New Base Mechanics:** M301 Island Spinner, M302 Turning Hedges, M303 Spinning Snake, M304 Gear Lock.
3. **45 Variants:** Base mechanics × 10 generic modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L3500 "Whirlwind Summit Shrine" + Jungle Treasure Chest.

## 2. Content Summary
| Item | Phase 7 Value | Source |
|---|---|---|
| Levels | 3001–3500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Whirlwind Valley (4x4 sub-board rotor, shifting borders, 90° CW turn) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M301 (L3011), M302 (L3131), M303 (L3251), M304 (L3371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L3491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L3500 "Whirlwind Summit Shrine" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P7-A (3001–3250) · P7-B (3251–3500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Snakes Count | 28–40 snakes | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Jungle Gift Basket | 49 (L3010 … L3490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Jungle Treasure Chest | L3500: 1,000 coins + 2 of each booster + Phase 7 badge | Standard §6.1, SCALING §6 |
| Golden Slither Rush | 20 rounds (after L3025, 3050 … 3500), 30 snakes each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 6
| Area | Phase 6 | Phase 7 |
|---|---|---|
| Signature System | Light & Beams+ (Sun Temple Light) | **Rotation (Whirlwind Valley)** |
| Geometry Shift | Static grid coordinates | **Rotatable 4×4 Sub-Boards (M301)**: ટેપ કરવાથી એરિયા 90° ફરે |
| Dynamic Boundaries| Fixed board border walls | **Rotating Edges (M302)**: કિનારીની દિવાલો દર Move એ ઘડિયાળ દિશામાં સરકે |
| Dynamic Direction | Fixed snake exit direction | **Spinning Snake (M303)**: દરેક Move પછી સાપની દિશા 90° બદલાય |
| Lock State | Multi-beam / color trigger | **Orientation Alignment (M304)**: રોટર યોગ્ય ખૂણે હોય ત્યારે જ લોક ખુલે |

## 4. Release Prerequisites
1. **CI Generator Run:** L3001–3500 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_7_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 7`.
5. **Tutorial Assets:** Sub-board rotation અને spinning snake ના tutorial cards localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_7_SCOPE_AND_RULES.md](./01_PHASE_7_SCOPE_AND_RULES.md) | Rotation rules, partial snake lock invariants, shifting edge rules |
| 02 | [02_LEVEL_PLAN_3001_3500.md](./02_LEVEL_PLAN_3001_3500.md) | 50-block slot map, M301–M304 intros, 45 variants, L3491 review, L3500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md) | Whirlwind Valley rules, M301–M304 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_7.md](./04_VARIANTS_AND_MODIFIERS_PHASE_7.md) | 45 variant slots (Rotation base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_7.md](./05_REWARDS_AND_ECONOMY_PHASE_7.md) | Economy inflow/outflow, Gift Baskets, L3500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_7.md](./06_UI_AND_QA_PHASE_7.md) | Rotation handles, swoosh VFX, performance, QA checklist |

---

## 6. Open Decisions
- **OD-P7-01:** Sub-board rotor 4x4 ની મધ્યમાં નાનું રોટેશન હેન્ડલ દર્શાવવું કે આખા 4x4 એરિયા પર ટેપ સક્ષમ રાખવો? (હાલ સેન્ટ્રલ ફ્લાવર હેન્ડલ ટેપ નક્કી કરેલ છે જેથી ભૂલથી મિસક્લિક ન થાય).
