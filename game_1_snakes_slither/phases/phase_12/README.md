# Phase 12 — Levels 5501–6000 (Monsoon Winds)
> Snakes Slither ના Phase 12 update નું scope, signature system (Gravity & Falling Physics: Monsoon Winds), 4 નવા base mechanics (M551–M554), 45 variants, release prerequisites અને Phase 12 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 11 index](../phase_11/README.md) · [Phase 13 index](../phase_13/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 12 = **Dynamic Gravity & Falling Blockers Puzzle Update (Monsoon Winds)**. Phase 11 પૂર્ણ કરનાર players માટે **L5501–6000** content:
1. **Signature System:** Monsoon Winds (બોર્ડ પર 4 દિશાઓમાં ફરતી ગુરુત્વાકર્ષણ શક્તિ જે લૂઝ ફળો અને ભારે સાપોને નીચે ખેંચે છે).
2. **4 New Base Mechanics:**
   - M551: Wind Lever / Gravity Lever (ટેપ કરવાથી ગુરુત્વાકર્ષણની દિશા $90^\circ$ ક્લોકવાઇઝ ફરે છે, HUD એરો દર્શાવે છે).
   - M552: Falling Fruit / Falling Blockers (પ્રત્યેક મૂવ પછી મુક્ત ફળ બ્લોકર્સ ગ્રેવિટીની દિશામાં 1 સેલ નીચે પડે છે).
   - M553: Floaty Lily / Anti-grav Tile (આ ટાઇલ પર રહેલું ફળ ગુરુત્વાકર્ષણ છતાં નીચે પડતું નથી).
   - M554: Heavy Python / Weight Path (ભારે અજગર જે પોતાની નીચેના તમામ સેલ્સ ખાલી હોય ત્યારે ગ્રેવિટીની દિશામાં 1 સેલ નીચે સરકે છે).
3. **45 Variants:** Base mechanics × 10 generic modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L6000 "Eye of the Monsoon" + Jungle Treasure Chest.

---

## 2. Content Summary
| Item | Phase 12 Value | Source |
|---|---|---|
| Levels | 5501–6000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Monsoon Winds (Dynamic 4-way gravity vector, falling physics) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M551 (L5511), M552 (L5631), M553 (L5751), M554 (L5871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L5991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L6000 "Eye of the Monsoon" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P12-A (5501–5750) · P12-B (5751–6000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Snakes Count | 28–42 snakes | SCALING §3.5 |
| Obstacle Instances | 8–15 instances (ફળો, લિવર્સ અને એન્ટી-ગ્રેવ ટાઇલ્સ) | SCALING §3.5 |
| Jungle Gift Basket | 49 (L5510 … L5990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Jungle Treasure Chest | L6000: 1,000 coins + 2 of each booster + Phase 12 badge | Standard §6.1, SCALING §6 |
| Golden Slither Rush | 20 rounds (after L5525, 5550 … 6000), 30 snakes each | Standard §6.1, §16.9 |

---

## 3. What's New vs Phase 11
| Area | Phase 11 | Phase 12 |
|---|---|---|
| Signature System | Linked Boards (Two Ponds) | **Gravity & Physics (Monsoon Winds)** |
| Board Physics | Static geometry | **Dynamic Gravity Vector**: 4 દિશામાં શિફ્ટ થતું ગુરુત્વાકર્ષણ ($0^\circ, 90^\circ, 180^\circ, 270^\circ$) |
| Environmental Falls | None | **Falling Fruit Blockers (M552)**: દર મૂવ પછી મુક્ત બ્લોકર્સ નીચે પડે છે |
| Anti-Gravity Zones | None | **Floaty Lily (M553)**: ગુરુત્વાકર્ષણ પ્રતિકારક ઝોન |
| Snake Physics | Static position until tapped | **Heavy Python (M554)**: વજનદાર સાપ આપોઆપ સ્લાઇડ થાય છે |

---

## 4. Release Prerequisites
1. **CI Generator Run:** L5501–6000 ના તમામ seeds pre-validated with gravity settling verification.
2. **Metadata Asset:** `phase_12_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 12`.
5. **Tutorial Assets:** Gravity Lever (M551) અને Falling Fruit (M552) ના tutorial cards localized.

---

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_12_SCOPE_AND_RULES.md](./01_PHASE_12_SCOPE_AND_RULES.md) | Scope, limits, rules, gravity vector state engine. |
| 02 | [02_LEVEL_PLAN_5501_6000.md](./02_LEVEL_PLAN_5501_6000.md) | 500-level slot allocation, 50 blocks, intros, review, finale. |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md) | Signature system rules, M551–M554 mechanics, post-move falling cascade. |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_12.md](./04_VARIANTS_AND_MODIFIERS_PHASE_12.md) | 45 variant catalog (Block 553–599), modifier combinations. |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_12.md](./05_REWARDS_AND_ECONOMY_PHASE_12.md) | Economy balance, Gift Baskets, Finale Chest, Golden Slither Rush. |
| 06 | [06_UI_AND_QA_PHASE_12.md](./06_UI_AND_QA_PHASE_12.md) | Gravity arrow HUD, Falling drop VFX, Audio cues, QA checklist. |

---

## 6. Open Decisions
- **OD-P12-01:** M551 Wind Lever ટેપ કરવા પર શું તે 1 મૂવ તરીકે ગણાય? Default: હા, લિવર ફેરવવું એ 1 માન્ય મૂવ છે જેથી આસપાસના ડ્રમ ગેટ્સ અને ટર્ન મોડ્યુલો યોગ્ય રીતે એડવાન્સ થાય.
- **OD-P12-02:** Falling Fruit (M552) એકસાથે નીચે પડતી વખતે જો સાપના માથા પર પડે તો શું થાય? Default: સાપ ક્યારેય કચડાઈને ડેડલોક થતો નથી; ફળ સાપના શરીર પર અટકી જાય છે (Zero Damage Standard).
