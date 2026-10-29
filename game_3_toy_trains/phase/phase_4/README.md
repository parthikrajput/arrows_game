# Phase 4 — Levels 1501–2000 (Station Floors)
> Toy Trains: Wooden Railway Puzzle ના Phase 4 update નું scope, signature system (Multi-Floor: Station Floors up to 3 floors), 4 નવા railway base mechanics (M151–M154), 45 variants, release prerequisites અને Phase 4 ના દરેક document નો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 3 index](../phase_3/README.md) · [Phase 5 index](../phase_5/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 4 = **Multi-Floor 3D Railway Puzzle Update**. Phase 3 પૂર્ણ કરનાર players માટે **L1501–2000** content:
1. **Signature System:** Station Floors (Multi-floor: 3 stacked tabletop boards સુધી; Floor tabs HUD; Floor સ્વિચ કરીને જોવું = Move નથી).
2. **4 New Base Mechanics:** M151 Station Stairs, M152 Glass Platform, M153 Goods Chute, M154 Goods Lift.
3. **45 Variants:** Base mechanics × 10 generic railway modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L2000 "Grand Central Multi-Floor Station" + Grand Central Chest.

## 2. Content Summary
| Item | Phase 4 Value | Source |
|---|---|---|
| Levels | 1501–2000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Station Floors (Up to 3 floors: F1 Ground Yard, F2 Mezzanine, F3 High Line) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M151 (L1511), M152 (L1631), M153 (L1751), M154 (L1871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L1991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L2000 "Grand Central Multi-Floor Station" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P4-A (1501–1750) · P4-B (1751–2000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 per floor (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Train Count | 28–40 trains (બધા floors મળીને) | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L1510 … L1990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Central Chest | L2000: 1,000 coins + 2 of each booster + Phase 4 badge | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L1525, 1550 … 2000), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 3
| Area | Phase 3 | Phase 4 |
|---|---|---|
| Signature System | Day & Night Cycles (A/B state) | **Multi-Floor Stacked Railway Boards (up to 3 floors)** |
| Navigation | Single board view with zoom/pan | **Floor Tabs UI (F1, F2, F3)**; camera shifts between station levels |
| Inter-Floor Travel | Flat 2D / 3 layers (Ground/Viaduct) | **Vertical path transitions:** Stairs (M151), Goods Chute (M153), Lift (M154) |
| Sight & Visibility | Solid playmat | **Glass Platform (M152)** allows seeing & tapping lower trains |

## 4. Release Prerequisites
1. **CI Generator Run:** L1501–2000 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_4_meta.bin` અને `seed_overrides.json` package bundle માં ઉમેરાયેલ હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 4`.
5. **Tutorial Assets:** Floor switching tabs અને M151–M154 tutorial cards localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_4_SCOPE_AND_RULES.md](./01_PHASE_4_SCOPE_AND_RULES.md) | Multi-floor architecture, viewing vs moving rules, vertical track connectivity |
| 02 | [02_LEVEL_PLAN_1501_2000.md](./02_LEVEL_PLAN_1501_2000.md) | 50-block slot map, M151–M154 intros, 45 variants, L1991 review, L2000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md) | Station Floors rules, M151–M154 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_4.md](./04_VARIANTS_AND_MODIFIERS_PHASE_4.md) | 45 variant slots (Multi-floor base × modifiers), interaction rules |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_4.md](./05_REWARDS_AND_ECONOMY_PHASE_4.md) | Economy inflow/outflow, Gift Crates, L2000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_4.md](./06_UI_AND_QA_PHASE_4.md) | Floor tabs UI, vertical camera transitions, VFX, performance, QA checklist |

