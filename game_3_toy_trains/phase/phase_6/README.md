# Phase 6 — Levels 2501–3000 (Signal Lights+)
> Toy Trains: Wooden Railway Puzzle ના Phase 6 update નું scope, signature system (Light & Beams+: Signal Lights+), 4 નવા railway base mechanics (M251–M254), 45 variants, release prerequisites અને Phase 6 ના દરેક document નો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 5 index](../phase_5/README.md) · [Phase 7 index](../phase_7/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 6 = **Railway Optics & Signal Beams Update**. Phase 5 પૂર્ણ કરનાર players માટે **L2501–3000** content:
1. **Signature System:** Signal Lights+ (Light & Beams+: રેલ્વે સિગ્નલ બીમ્સ, ઓપ્ટિકલ કલર ફિલ્ટર્સ, સ્પ્લિટર્સ, લાઇટ સેન્સર્સ અને અંધારા સેલ્સ).
2. **4 New Base Mechanics:** M251 Coloured Lens, M252 Twin Sensor Gate, M253 Lamp Timer, M254 Blackout Patch.
3. **45 Variants:** Base mechanics × 10 generic railway modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L3000 "Grand Signal Central" + Grand Central Chest.

## 2. Content Summary
| Item | Phase 6 Value | Source |
|---|---|---|
| Levels | 2501–3000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Signal Lights+ (Light Beams, Mirrors & Sensors) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M251 (L2511), M252 (L2631), M253 (L2751), M254 (L2871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L2991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L3000 "Grand Signal Central" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P6-A (2501–2750) · P6-B (2751–3000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Train Count | 28–40 trains | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L2510 … L2990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Central Chest | L3000: 1,000 coins + 2 of each booster + Phase 6 badge | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L2525, 2550 … 3000), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 5
| Area | Phase 5 | Phase 6 |
|---|---|---|
| Signature System | Push Physics+ (Yard Shunting+) | **Light & Beams+ (Signal Lights+)** |
| Signal Interaction | Physical track triggers | **Photonic Sensors:** બીમ સેન્સર પર પડતાં દરવાજા ખુલે છે |
| Color Filtering | Mechanical gates | **Coloured Lens (M251):** બીમનો રંગ બદલી ચોક્કસ સેન્સરને સક્રિય કરવું |
| Occlusion | Steam fog (M010) | **Blackout Patch (M254):** બીમ પડે ત્યારે જ અંધારા સેલની ટ્રેન સક્રિય થાય |

## 4. Release Prerequisites
1. **CI Generator Run:** L2501–3000 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_6_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 6`.
5. **Tutorial Assets:** Optical signal cards અને M251–M254 tutorial cards localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_6_SCOPE_AND_RULES.md](./01_PHASE_6_SCOPE_AND_RULES.md) | Signal optics rules, beam propagation, sensor locks, dark cells |
| 02 | [02_LEVEL_PLAN_2501_3000.md](./02_LEVEL_PLAN_2501_3000.md) | 50-block slot map, M251–M254 intros, 45 variants, L2991 review, L3000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md) | Signal Lights+ rules, M251–M254 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_6.md](./04_VARIANTS_AND_MODIFIERS_PHASE_6.md) | 45 variant slots (Signal Optics base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_6.md](./05_REWARDS_AND_ECONOMY_PHASE_6.md) | Economy inflow/outflow, Gift Crates, L3000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_6.md](./06_UI_AND_QA_PHASE_6.md) | Signal beam VFX (`BlendMode.plus`), sensor glow, performance, QA checklist |
