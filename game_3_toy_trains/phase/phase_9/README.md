# Phase 9 — Levels 4001–4500 (Couple & Uncouple)
> Toy Trains: Wooden Railway Puzzle ના Phase 9 update નું scope, signature system (Split & Merge: Couple & Uncouple), 4 નવા railway base mechanics (M401–M404), 45 variants, release prerequisites અને Phase 9 ના તમામ દસ્તાવેજોનો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 8 index](../phase_8/README.md) · [Phase 10 index](../phase_10/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 9 = **Coupling, Shunting & Segment Split Update**. Phase 8 પૂર્ણ કરનાર ખેલાડીઓ માટે **L4001–4500** content:
1. **Signature System:** Couple & Uncouple (Split & Merge: ટ્રેનોનું પાટા પર જોડાણ, ટ્વિન ટ્રેન વિભાજન, સેગમેન્ટ લોક્સ અને રીજોઇન આર્ચ).
2. **4 New Base Mechanics:** M401 Coupling Pad, M402 Twin Split Train, M403 Coupling Lock, M404 Rejoin Arch.
3. **45 Variants:** Base mechanics × 10 generic railway modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L4500 "Grand Junction Coupling Yard" + Grand Central Chest.

## 2. Content Summary
| Item | Phase 9 Value | Source |
|---|---|---|
| Levels | 4001–4500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Couple & Uncouple (Split & Merge Mechanics) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M401 (L4011), M402 (L4131), M403 (L4251), M404 (L4371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L4491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L4500 "Grand Junction Coupling Yard" (Finale target D ≈ 91)| SCALING §3.5, §6 |
| Tiers | P9-A (4001–4250) · P9-B (4251–4500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Train Count | 30–42 trains | SCALING §3.5 |
| Obstacle Instances | 8–15 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L4010 … L4490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Central Chest | L4500: 1,000 coins + 2 of each booster + Phase 9 badge | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L4025, 4050 … 4500), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 8
| Area | Phase 8 | Phase 9 |
|---|---|---|
| Signature System | Overgrown Branch Line (Growth) | **Couple & Uncouple (Split & Merge)** |
| Train Morphology | Static 2–5 car trains | **Dynamic Train Length:** જોડાણથી ટ્રેન લાંબી બને છે (M401), વિભાજનથી 2 સમાંતર ટ્રેન બને છે (M402) |
| Multi-car Merging | None | **Coupling Pad (M401):** બે અલગ ટ્રેનો પેડ પર આવતાં 1 Move માં જોડાઈને એક બને છે |
| Parallel Splitting | Single body exit | **Twin Split Train (M402):** ટેપ કરતાં બે સમાંતર સિંગલ ટ્રેનોમાં છૂટી પડે છે |
| Segment Constraints | Foliage blockers | **Coupling Lock (M403):** અનકપલ્ડ સેગમેન્ટ કી-ટ્રેન એક્ઝિટ ન થાય ત્યાં સુધી લોક રહે છે |
| Dual-Key Gate | Bloom Arch (K ivy count) | **Rejoin Arch (M404):** વિભાજિત ટ્રેનના બંને ભાગો પસાર થાય ત્યારે જ પૂર્ણપણે ખુલે છે |

## 4. Release Prerequisites
1. **CI Generator Run:** L4001–4500 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_9_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 9`.
5. **Tutorial Assets:** Coupling Pads, Split Trains, Rejoin Arches ના એનિમેટેડ ટ્યુટોરિયલ્સ localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_9_SCOPE_AND_RULES.md](./01_PHASE_9_SCOPE_AND_RULES.md) | Coupling pads, twin split rules, segment locks, rejoin arches અને Remote Config |
| 02 | [02_LEVEL_PLAN_4001_4500.md](./02_LEVEL_PLAN_4001_4500.md) | 50-block slot map, M401–M404 intros, 45 variants, L4491 review, L4500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md) | Split & Merge rules, M401–M404 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_9.md](./04_VARIANTS_AND_MODIFIERS_PHASE_9.md) | 45 variant slots (Couple & Uncouple base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_9.md](./05_REWARDS_AND_ECONOMY_PHASE_9.md) | Economy inflow/outflow, Gift Crates, L4500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_9.md](./06_UI_AND_QA_PHASE_9.md) | Magnetic coupler visualizer, split ghost trail, rejoin gate VFX, performance, QA |
