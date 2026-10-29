# Phase 11 — Levels 5001–5500 (Twin Tables)
> Toy Trains: Wooden Railway Puzzle ના Phase 11 update નું scope, signature system (Linked Boards: Twin Tables), 4 નવા railway base mechanics (M501–M504), 45 variants, release prerequisites અને Phase 11 ના તમામ દસ્તાવેજોનો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 10 index](../phase_10/README.md) · [Phase 12 index](../phase_12/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 11 = **Dual-Table Connected Railway Yards Update**. Phase 10 પૂર્ણ કરનાર ખેલાડીઓ માટે **L5001–5500** content:
1. **Signature System:** Twin Tables (Linked Boards: બે જોડાયેલા મીની વુડન બોર્ડ્સ / ટેબલ્સ Table A & Table B વચ્ચે ક્રોસ-બોર્ડ ટ્રેક કનેક્શન્સ).
2. **4 New Base Mechanics:** M501 Table Bridge, M502 Inter-table Ticket, M503 Mirror Table, M504 Relay Tunnel.
3. **45 Variants:** Base mechanics × 10 generic railway modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L5500 "Twin Grand Central Terminals" + Grand Central Chest.

## 2. Content Summary
| Item | Phase 11 Value | Source |
|---|---|---|
| Levels | 5001–5500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Twin Tables (Linked Multi-Board System) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M501 (L5011), M502 (L5131), M503 (L5251), M504 (L5371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L5491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L5500 "Twin Grand Central Terminals" (Finale target D ≈ 91)| SCALING §3.5, §6 |
| Tiers | P11-A (5001–5250) · P11-B (5251–5500) | SCALING §3.5 |
| Max Grid | Dual linked tables (Two 8×8 to 9×9 boards side-by-side) | Standard §9.3, §17.23 |
| Train Count | 34–46 trains | SCALING §3.5 |
| Obstacle Instances | 8–16 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L5010 … L5490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Central Chest | L5500: 1,000 coins + 2 of each booster + Phase 11 badge | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L5025, 5050 … 5500), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 10
| Area | Phase 10 | Phase 11 |
|---|---|---|
| Signature System | Timetable Master (Sequencing) | **Twin Tables (Linked Boards)** |
| Board Structure | Single contiguous board | **Dual Linked Boards:** Table A અને Table B વચ્ચે ટ્રેનોનું સતત આદાન-પ્રદાન |
| Cross-Board Crossing | None | **Table Bridge (M501):** Table A ની લિંક્ડ એજમાંથી નીકળતી ટ્રેન Table B ની મેળ ખાતી એજમાં પ્રવેશે છે |
| Cross-Board Triggers | Local triggers | **Inter-table Ticket (M502):** Table A પર ટિકિટ કલેક્ટ કરતાં Table B પરનો બેરિયર ખુલે છે |
| Dual Synchronization | Single moves | **Mirror Table (M503):** Table A પરની ટ્રેન ચલાવતાં Table B પરની જોડિયા ટ્રેન અરીસાની જેમ સાથે ચાલે છે |
| Cross-Board Portals | Single board tunnels | **Relay Tunnel (M504):** એક સુરંગ Table A પર અને બીજી Table B પર હોય છે |

## 4. Release Prerequisites
1. **CI Generator Run:** L5001–5500 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_11_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 11`.
5. **Tutorial Assets:** Dual table viewport, Table Bridge, Inter-table tickets localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_11_SCOPE_AND_RULES.md](./01_PHASE_11_SCOPE_AND_RULES.md) | Twin table structure, board link edges, cross-table tickets, mirror sync |
| 02 | [02_LEVEL_PLAN_5001_5500.md](./02_LEVEL_PLAN_5001_5500.md) | 50-block slot map, M501–M504 intros, 45 variants, L5491 review, L5500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md) | Linked Boards rules, M501–M504 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_11.md](./04_VARIANTS_AND_MODIFIERS_PHASE_11.md) | 45 variant slots (Twin Tables base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_11.md](./05_REWARDS_AND_ECONOMY_PHASE_11.md) | Economy inflow/outflow, Gift Crates, L5500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_11.md](./06_UI_AND_QA_PHASE_11.md) | Split-view / Pan UI, Table bridge glow, cross-board ticket link VFX, QA |
