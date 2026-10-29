# Phase 15 — Levels 7001–7500 (Moving Platforms)
> Toy Trains: Wooden Railway Puzzle ના Phase 15 update નું scope, signature system (Conveyors & Motorized Tracks: Moving Platforms), 4 નવા railway base mechanics (M701–M704), 45 variants, release prerequisites અને Phase 15 ના તમામ દસ્તાવેજોનો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 14 index](../phase_14/README.md) · [Phase 16 index](../phase_16/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 15 = **Motorized Conveyor Tracks & Dynamic Moving Platforms Update**. Phase 14 પૂર્ણ કરનાર ખેલાડીઓ માટે **L7001–7500** content:
1. **Signature System:** Moving Platforms (Conveyors: ચાલતી કન્વેયર બેલ્ટ પ્લેટ્સ જે તેના પર ઉભેલી ટ્રેનોને દર મૂવ વખતે આપોઆપ આગળ ધકેલે છે, બેલ્ટ સ્વિચ અને લૂપ બેલ્ટ્સ).
2. **4 New Base Mechanics:**
   - M701: Belt Switch / Belt Junction (કન્વેયર બેલ્ટના પ્રવાહને ડાબે/જમણે વાળે છે, ટેપ કરવાથી ટોગલ થાય છે, 1 Move).
   - M702: Reversing Belt / Reversible Belt (લિન્ક્ડ લીવર દબાવવાથી કન્વેયર બેલ્ટની પ્રવાહ દિશા ઉલટી થાય છે).
   - M703: Belt Stop Lever / Belt Lever (કન્વેયર બેલ્ટને ચાલુ/બંધ કરતો રેડ-ગ્રીન લીવર).
   - M704: Loop Belt / Track Loop (બંધ કન્વેયર રીંગ જે ટ્રેનોને દર મૂવ વખતે 1 સેલ પરિભ્રમણ કરાવે છે; ટ્રેન સીધી દિશામાં બહાર નીકળી શકે છે).
3. **45 Variants:** Base mechanics × 10 generic railway modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L7500 "Automated Transshipment Yard" + Grand Central Chest.

## 2. Content Summary
| Item | Phase 15 Value | Source |
|---|---|---|
| Levels | 7001–7500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Moving Platforms (Conveyors & Motorized Platforms) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M701 (L7011), M702 (L7131), M703 (L7251), M704 (L7371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L7491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L7500 "Automated Transshipment Yard" (Finale target D ≈ 91)| SCALING §3.5, §6 |
| Tiers | P15-A (7001–7250) · P15-B (7251–7500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Train Count | 36–50 trains | SCALING §3.5 |
| Obstacle Instances | 8–16 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L7010 … L7490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Central Chest | L7500: 1,000 coins + 2 of each booster + Phase 15 badge | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L7025, 7050 … 7500), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 14
| Area | Phase 14 | Phase 15 |
|---|---|---|
| Signature System | Alpine Pass (Looking-Glass Line) | **Moving Platforms (Conveyors & Tracks)** |
| Board Dynamic | Symmetrical mirror reflection | **Active Conveyor Motion:** ટ્રેક પોતે ટ્રેનને ખસેડે છે |
| Flow Routing | Static tracks | **Belt Switch (M701):** કન્વેયરનો માર્ગ ટેપથી L/R ટોગલ થાય છે |
| Reversibility | Fixed reverse engine | **Reversing Belt (M702):** સમગ્ર પટ્ટાની ગતિ ઉલટાવી શકાય છે |
| Dynamic Loops | None | **Loop Belt (M704):** ક્લોઝ્ડ રીંગ ટ્રેનોને ગોળ ફેરવે છે |

## 4. Release Prerequisites
1. **CI Generator Run:** L7001–7500 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_15_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 15`.
5. **Tutorial Assets:** Belt Switch, Reversing Belt, Stop Lever, Loop Belt localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_15_SCOPE_AND_RULES.md](./01_PHASE_15_SCOPE_AND_RULES.md) | Moving Platforms conveyor rules, belt tick order, routing logic |
| 02 | [02_LEVEL_PLAN_7001_7500.md](./02_LEVEL_PLAN_7001_7500.md) | 50-block slot map, M701–M704 intros, 45 variants, L7491 review, L7500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md) | Conveyor rules, M701–M704 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_15.md](./04_VARIANTS_AND_MODIFIERS_PHASE_15.md) | 45 variant slots (Moving Platforms base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_15.md](./05_REWARDS_AND_ECONOMY_PHASE_15.md) | Economy inflow/outflow, Gift Crates, L7500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_15.md](./06_UI_AND_QA_PHASE_15.md) | Motorized tread rollers shader, belt arrow flow, loop rotation VFX, QA |
