# Phase 15 — Levels 7001–7500 (River Delta)
> Snakes Slither ના Phase 15 update નું scope, signature system (Conveyors & Tracks: River Delta), 4 નવા base mechanics (M701–M704), 45 variants, release prerequisites અને Phase 15 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 14 index](../phase_14/README.md) · [Phase 16 index](../phase_16/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 15 = **Conveyor Flow & Dynamic Track Routing Update (River Delta)**. Phase 14 પૂર્ણ કરનાર players માટે **L7001–7500** content:
1. **Signature System:** River Delta (પાણીના વહેણ જેવી કન્વેયર ટ્રેક ટાઇલ્સ જે સાપોને આપમેળે આગળ ધકેલે છે, વળાંકો આપે છે અને ચક્રાકારે ફેરવે છે).
2. **4 New Base Mechanics:**
   - M701: River Fork / Belt Junction (કન્વેયર જંક્શન જે સ્વીચની સ્થિતિ મુજબ સાપને ડાબે કે જમણે વાળે છે; ટેપ = 1 મૂવ).
   - M702: Tide River / Reversible Belt (દર $N$ મૂવ્સે કન્વેયર પ્રવાહની દિશા આપોઆપ ઉલટાઈ જાય છે).
   - M703: Sluice Lever / Belt Lever (ટેપ કરવાથી લિંક્ડ કન્વેયર ટ્રેક ચાલુ અથવા બંધ થાય છે; ટેપ = 1 મૂવ).
   - M704: Whirlpool / Track Loop (બંધ લૂપ ટ્રેક; જે સાપ તેના પર સંપૂર્ણપણે આવે તે દર મૂવ પર ચક્રાકારે ગોળ ફરે છે).
3. **45 Variants:** Base mechanics × 10 generic modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L7500 "Mouth of the Grand Delta" + Jungle Treasure Chest.

---

## 2. Content Summary
| Item | Phase 15 Value | Source |
|---|---|---|
| Levels | 7001–7500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | River Delta (Conveyors, junction routing, reversible belts, loops) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M701 (L7011), M702 (L7131), M703 (L7251), M704 (L7371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L7491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L7500 "Mouth of the Grand Delta" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P15-A (7001–7250) · P15-B (7251–7500) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Snakes Count | 28–42 snakes | SCALING §3.5 |
| Obstacle Instances | 8–15 instances (જંક્શન્સ, સ્લૂઇસ ગેટ્સ, વમળો) | SCALING §3.5 |
| Jungle Gift Basket | 49 (L7010 … L7490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Jungle Treasure Chest | L7500: 1,000 coins + 2 of each booster + Phase 15 badge | Standard §6.1, SCALING §6 |
| Golden Slither Rush | 20 rounds (after L7025, 7050 … 7500), 30 snakes each | Standard §6.1, §16.9 |

---

## 3. What's New vs Phase 14
| Area | Phase 14 | Phase 15 |
|---|---|---|
| Signature System | Mirror Worlds (Pond Reflections) | **Conveyors & Tracks (River Delta)** |
| Board Dynamics | Symmetrical mirrored taps | **Automated Conveyor Propulsion**: ટ્રેક પર રહેલા સાપો આપોઆપ પ્રવાહ સાથે વહે |
| Path Switching | Fixed geometrical paths | **Junction Routing (M701)**: ખેલાડી ટ્રેક સ્વીચ વડે રસ્તાઓ બદલે |
| Flow Periodicity | Static layout | **Reversible Tides (M702)**: મૂવ કાઉન્ટર આધારિત પ્રવાહ રિવર્સલ |
| Circulating Loops | None | **Whirlpool Loops (M704)**: સતત પરિભ્રમણ કરતા સાપો |

---

## 4. Release Prerequisites
1. **CI Generator Run:** L7001–7500 ના તમામ seeds pre-validated with conveyor settling simulation.
2. **Metadata Asset:** `phase_15_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 15`.
5. **Tutorial Assets:** Belt Junction (M701) અને Reversible Tide (M702) ના tutorial cards localized.

---

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_15_SCOPE_AND_RULES.md](./01_PHASE_15_SCOPE_AND_RULES.md) | Scope, limits, rules, conveyor belt kinematic engine. |
| 02 | [02_LEVEL_PLAN_7001_7500.md](./02_LEVEL_PLAN_7001_7500.md) | 500-level slot allocation, 50 blocks, intros, review, finale. |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md) | Signature system rules, M701–M704 mechanics, loop physics. |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_15.md](./04_VARIANTS_AND_MODIFIERS_PHASE_15.md) | 45 variant catalog (Block 703–749), modifier combinations. |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_15.md](./05_REWARDS_AND_ECONOMY_PHASE_15.md) | Economy balance, Gift Baskets, Finale Chest, Golden Slither Rush. |
| 06 | [06_UI_AND_QA_PHASE_15.md](./06_UI_AND_QA_PHASE_15.md) | Conveyor arrows, Water ripple flow VFX, Sluice levers, QA checklist. |

---

## 6. Open Decisions
- **OD-P15-01:** M701 Belt Junction સ્વીચ ટેપ કરવાથી મૂવ વપરાય કે ફ્રી છે? Default: ટેપ = 1 મૂવ (`Move += 1`), જેથી ટાઈડ કાઉન્ટર અને અન્ય સિસ્ટમ્સ યોગ્ય રીતે પ્રગતિ કરે.
- **OD-P15-02:** M704 Whirlpool Loop માં ફરતો સાપ શું ટેપ કરીને બહાર કાઢી શકાય? Default: હા, જ્યારે સાપનું માથું એક્ઝિટ લેન તરફ આવે ત્યારે ટેપ કરવાથી તે લૂપમાંથી બહાર નીકળીને બોર્ડ છોડે છે.

