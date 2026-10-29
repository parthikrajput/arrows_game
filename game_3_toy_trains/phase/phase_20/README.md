# Phase 20 — Levels 9501–10000 (Grand Master & L10000 Grand Finale)
> Toy Trains: Wooden Railway Puzzle ના Phase 20 update નું scope, signature system (Omni-System Convergence: Grand Master), 4 supreme combo base mechanics (M951–M954), 45 variants, release prerequisites, L10000 Grand Finale અને Phase 20 ના તમામ દસ્તાવેજોનો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6, §9, §10](../../SCALING_TO_10000_LEVELS.md) · [Phase 19 index](../phase_19/README.md) · [Specs Index](../../specs/INDEX.md)

---

## 1. Goal (લક્ષ્ય)
Phase 20 = **The Ultimate Railway Convergence & Grand Master Finale (Levels 9501 to 10,000)**. Phase 19 પૂર્ણ કરનાર ખેલાડીઓ માટે અંતિમ શિખર સામગ્રી:
1. **Signature System:** Grand Master (બોર્ડ પર તમામ 19 પૂર્વ-સિસ્ટમ્સનું સંપૂર્ણ એકત્રીકરણ: Day/Night, Multi-Floor Platforms, Shunting Carts, Beams, Turntables, Ivy Growth, Split & Merge, Sequencing Rhythm, Twin Tables, Gravity Slopes, Fog of War, Alpine Mirror, Conveyors, Ticket Networks, Clock Towers).
2. **4 Supreme Combo Mechanics:**
   - M951: Clockwork Conveyor Guardian (કન્વેયર બેલ્ટ રીંગ જે ક્લોક ટાવર ગાર્ડિયનની આસપાસ ટ્રેનોને પરિભ્રમણ કરાવે છે).
   - M952: Gravity Mirror Relay (ટિલ્ટ લીવર જે ડ્યુઅલ ટેબલ્સ પર મિરર અક્ષની સામસામે ગ્રેવિટીને વિરુદ્ધ દિશામાં ઉલટાવે છે).
   - M953: Day/Night Ticket Master Pass (ગોલ્ડન માસ્ટર પાસ જે Day Phase માં સામાન્ય કી અને Night Phase માં સુપર સ્કેલેટન કી તરીકે વર્તે છે).
   - M954: Prism Bloom Arch (બ્લૂમ આર્ચ જે K વેલ સેલ્સ અડક્યા પછી કલર્ડ લાઇટ બીમથી કાયમી અનલોક થાય છે).
3. **45 Variants:** Supreme combo mechanics × 10 generic modifiers (મહત્તમ 2 સ્ટેક્ડ મોડિફાયર્સ).
4. **Difficulty Band:** Fixed plateau **D 60–76** (L9501–9990), L9991 Review, અને **L10000 Grand Finale (Target D ≈ 91)**.
5. **Grand Master Finale:** L10000 "The Grand Sovereign Terminus" (14×14 અલ્ટીમેટ બોર્ડ પર માર્ચિંગ ક્લોક ટાવર બોસ) + Grand Sovereign Master Chest.

## 2. Content Summary
| Item | Phase 20 Value | Source |
|---|---|---|
| Levels | 9501–10000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Grand Master (All Systems Convergence) | Standard §11, SCALING §6, §9 |
| Base Mechanics | 4: M951 (L9511), M952 (L9631), M953 (L9751), M954 (L9871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L9991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Grand Finale | L10000 "The Grand Sovereign Terminus" (Ultimate Boss Board, D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P20-A (9501–9750) · P20-B (9751–10000) | SCALING §3.5 |
| Max Grid | 14×14 Ultimate Board (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Train Count | 40–56 trains (L10000: 56 trains) | SCALING §3.5 |
| Obstacle Instances | 10–18 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L9510 … L9990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Sovereign Chest | L10000: **5,000 coins** + 5 of each booster + "Grand Master of 10,000 Tracks" Crown Trophy | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L9525, 9550 … 10000), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 19
| Area | Phase 19 | Phase 20 |
|---|---|---|
| Signature System | Remix B (P7–P12 Systems) | **Grand Master (All Systems Convergence)** |
| Mechanics Scope | Mid-era systems | **Omni-System Synergy:** સમગ્ર રમતની તમામ 19 સિસ્ટમ્સ એકસાથે |
| Supreme Combos | 2-system pairings | **Multi-System Triads:** Conveyor + Guardian + Beam + Gravity |
| Ultimate Finale | Mid-Era Terminal | **L10000 "The Grand Sovereign Terminus":** Marching Clock Tower Boss |
| Final Reward | 1,000 coins + badge | **5,000 coins + 5× each booster + Ultimate Gold Crown Trophy** |

## 4. Release Prerequisites
1. **CI Generator Run:** L9501–10000 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_20_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 20`.
5. **Tutorial Assets:** Supreme Combos અને L10000 Boss Warning localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_20_SCOPE_AND_RULES.md](./01_PHASE_20_SCOPE_AND_RULES.md) | Grand Master scope, omni-system convergence rules, L10000 Boss architecture |
| 02 | [02_LEVEL_PLAN_9501_10000.md](./02_LEVEL_PLAN_9501_10000.md) | 50-block slot map, M951–M954 intros, 45 variants, L9991 review, L10000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md) | Grand Master rules, M951–M954 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_20.md](./04_VARIANTS_AND_MODIFIERS_PHASE_20.md) | 45 variant slots (Supreme Combo base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_20.md](./05_REWARDS_AND_ECONOMY_PHASE_20.md) | Economy inflow/outflow, Gift Crates, L10000 Grand Sovereign Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_20.md](./06_UI_AND_QA_PHASE_20.md) | L10000 Boss Marching UI, Omni-System HUD, Golden Crown Celebration VFX, QA |

