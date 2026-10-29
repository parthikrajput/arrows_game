# Phase 3 — Levels 1001–1500 (Day & Night Timetable)
> Toy Trains: Wooden Railway Puzzle ના Phase 3 update નું scope, signature system (Cycles: Day & Night Timetable), 4 નવા railway base mechanics (M101–M104), 45 variants, on-device deterministic generation, release prerequisites અને Phase 3 ના દરેક document નો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 2 index](../phase_2/README.md) · [Phase 4 index](../phase_4/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 3 = **પહેલો On-Device Generation update** (levels bundled JSON નથી; device પર `xoshiro128**` PRNG seed થી generate થાય છે). Phase 2 ના 1000 levels ક્લિયર કરનાર players માટે **L1001–1500** content:
1. **Signature System:** Day & Night Timetable (Cycles — દર 5 Moves એ બોર્ડ A/B state ફરે છે; Sun/Moon dial HUD).
2. **4 New Base Mechanics:** M101 Day/Night Gate, M102 Day/Night Overpass, M103 Day/Night Tunnel, M104 Day/Night Livery.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24). Difficulty સંખ્યા વધારવાથી નહીં પણ નવા mechanics/variants થી આવે છે.

## 2. Content Summary
| Item | Phase 3 Value | Source |
|---|---|---|
| Levels | 1001–1500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Day & Night Timetable (Cycle period = 5 Moves, Sun/Moon HUD) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M101 (L1011), M102 (L1131), M103 (L1251), M104 (L1371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L1491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L1500 "Day & Night Grand Central Terminal" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P3-A (1001–1250) · P3-B (1251–1500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (pinch-zoom + pan enabled, fitCell ≥ 22 dp) | Standard §9.3, §17.23; SCALING §3.5 |
| Train Count | 28–40 trains | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L1010 … L1490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Central Chest | L1500: 1,000 coins + 2 of each booster + Phase 3 badge | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L1025, 1050 … 1500), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 2
| Area | Phase 2 | Phase 3 |
|---|---|---|
| Level Delivery | Bundled `assets/levels/phase_2.json.gz` | **On-device generation** from seed (CI pre-validated, zero bundle bloat) |
| Signature System | Zoom/Pan + Diagonals + 3 Layers | **Day & Night Timetable (Cycles A/B)** every 5 Moves |
| Mechanics Architecture | 49 standalone base mechanics | 4 Base mechanics + **45 variant combinations** (Base × Modifiers) |
| Difficulty Model | P2-B (52–70) climbing curve | **Fixed Plateau D 60–76** (standard §17.24) |
| Live Tuning | Bundled alternate file | `seed_overrides.json` + `validated_k.json` (Remote Config `levelOverrides`) |
| Seed Metadata | N/A | Shipped `phase_3_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
Phase 3 app build store માં roll out કરતાં પહેલાં નીચેની બાબતો ચકાસવી:
1. **CI Generator Run:** L1001–1500 ના તમામ 500 levels ના 64 attempts CI માં pre-validate થઈ ગયા હોવા જોઈએ (zero unverified seeds).
2. **Metadata Asset:** `phase_3_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને x64 CI પર L1001–1500 generate કરીને byte-identical hash મળવો જોઈએ.
4. **Remote Config Rollout Flag:** `maxPhase = 3` set કરવાથી જ Phase 3 unlock થાય.
5. **Tutorial Assets:** Day & Night dial HUD અને M101–M104 ના tutorial cards localized (English, ગુજરાતી, हिन्दी).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_3_SCOPE_AND_RULES.md](./01_PHASE_3_SCOPE_AND_RULES.md) | Phase 3 scope, Cycle state machine rules, on-device limits, Remote Config keys |
| 02 | [02_LEVEL_PLAN_1001_1500.md](./02_LEVEL_PLAN_1001_1500.md) | 50-block slot map (L1001–1500), signature intro, 4 base intros, 45 variants, L1491 review, L1500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md) | Day & Night Timetable rules, M101–M104 catalog cards, tick order integration (§16.17), solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_3.md](./04_VARIANTS_AND_MODIFIERS_PHASE_3.md) | 45 variant slot definitions (Base × Modifier), modifier behaviors and rules |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_3.md](./05_REWARDS_AND_ECONOMY_PHASE_3.md) | Economy inflow/outflow, Gift Crates, L1500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_3.md](./06_UI_AND_QA_PHASE_3.md) | Sun/Moon dial HUD, VFX for cycles and M101–M104, tier limits, performance budgets, QA checklist |
