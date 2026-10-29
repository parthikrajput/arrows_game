# Phase 18 — Levels 8501–9000 (Remix A)
> Toy Trains: Wooden Railway Puzzle ના Phase 18 update નું scope, signature system (Early Era Analytics Remix: Remix A / P1–P6 Systems), 4 analytics-driven combo base mechanics (M851–M854), 45 variants, release prerequisites અને Phase 18 ના તમામ દસ્તાવેજોનો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6, §9, §10](../../SCALING_TO_10000_LEVELS.md) · [Phase 17 index](../phase_17/README.md) · [Phase 19 index](../phase_19/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 18 = **Early Era Systems Cross-Fusion Update (Remix A: Phases 1 to 6)**. Phase 17 પૂર્ણ કરનાર ખેલાડીઓ માટે **L8501–9000** content:
1. **Signature System:** Remix A (Phase 1 થી Phase 6 સુધીના સૌથી લોકપ્રિય અને ઉચ્ચ એંગેજમેન્ટ ધરાવતા રેલ્વે મિકેનિક્સનું સિનર્જિસ્ટિક સંયોજન: Day & Night Timetables, Multi-Floor Station Platforms, Push Physics Shunting, Signal Light Beams).
2. **4 Data-Driven Combo Mechanics:**
   - M851: Day/Night Ticket Cart (Cycle Key: ટિકિટ કાર્ટ જે ડે/નાઇટ ટનલમાંથી પસાર થઈ A/B ફેઝમાં બેરિયર ખોલે છે).
   - M852: Station Floor Shunting Lift (Multi-Floor Cart Elevator: ભારે કાર્ગો કાર્ટને પ્લેટફોર્મ ફ્લોર 1 થી ફ્લોર 2 પર લઈ જતી લિફ્ટ).
   - M853: Prism Signal Sensor (Color Lens Sensor Gate: કલર્ડ લેન્સમાંથી પસાર થતો બીમ સેન્સર ગેટ અથવા ડ્રોબ્રિજને સક્રિય કરે છે).
   - M854: Ice Cart Blackout Chute (ડ્રોપ ચ્યુટમાંથી નીચેના ફ્લોરના કાર્ટ પીટમાં સરકતી આઇસ બ્લોક કાર્ટ).
   *(આ 4 કોમ્બોઝ SCALING §9 અને §10 ના એનાલિટિક્સ રૂલ અનુસાર પસંદ થાય છે).*
3. **45 Variants:** Base mechanics × 10 generic railway modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L9000 "Grand Early Railway Junction" + Grand Central Chest.

## 2. Content Summary
| Item | Phase 18 Value | Source |
|---|---|---|
| Levels | 8501–9000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Remix A (P1–P6 Systems Synergy, Data-driven) | Standard §11, SCALING §6, §9 |
| Base Mechanics | 4: M851 (L8511), M852 (L8631), M853 (L8751), M854 (L8871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L8991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L9000 "Grand Early Railway Junction" (Target D ≈ 91)| SCALING §3.5, §6 |
| Tiers | P18-A (8501–8750) · P18-B (8751–9000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Train Count | 36–52 trains | SCALING §3.5 |
| Obstacle Instances | 8–16 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L8510 … L8990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Central Chest | L9000: 1,000 coins + 2 of each booster + Phase 18 badge | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L8525, 8550 … 9000), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 17
| Area | Phase 17 | Phase 18 |
|---|---|---|
| Signature System | Clock Towers (Guardians) | **Remix A (P1–P6 Synergy)** |
| Mechanics Source | Dedicated boss guardian entity | **Cross-Era Fusion:** P1 થી P6 ના ક્લાસિક મિકેનિક્સનું મિશ્રણ |
| Interaction Layer | Damage HP decay | **Deep System Interlocking:** ડે/નાઇટ સાયકલ સાથે મલ્ટી-ફ્લોર અને બીમ સેન્સર્સ |
| Selection Metric | Pre-determined base list | **Data-Driven Curation (§10):** લાઈવ એનાલિટિક્સના હાઈ-એંગેજમેન્ટ કોમ્બોઝ |

## 4. Release Prerequisites
1. **CI Generator Run:** L8501–9000 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_18_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 18`.
5. **Tutorial Assets:** Day/Night Ticket Cart, Multi-Floor Shunting Lift localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_18_SCOPE_AND_RULES.md](./01_PHASE_18_SCOPE_AND_RULES.md) | Remix A scope, data-driven combo rules, early-era cross-system interlocking |
| 02 | [02_LEVEL_PLAN_8501_9000.md](./02_LEVEL_PLAN_8501_9000.md) | 50-block slot map, M851–M854 intros, 45 variants, L8991 review, L9000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md) | Early Era Synergy rules, M851–M854 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_18.md](./04_VARIANTS_AND_MODIFIERS_PHASE_18.md) | 45 variant slots (Remix A base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_18.md](./05_REWARDS_AND_ECONOMY_PHASE_18.md) | Economy inflow/outflow, Gift Crates, L9000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_18.md](./06_UI_AND_QA_PHASE_18.md) | Day/night multi-floor shading, prism beam particle links, QA checklist |

