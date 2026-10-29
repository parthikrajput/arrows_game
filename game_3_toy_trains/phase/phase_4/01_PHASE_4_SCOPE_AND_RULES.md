# 01 · Phase 4 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 4 (Levels 1501–2000) ના નિયમો, Multi-Floor (Station Floors) signature system, floor viewing vs moving rules, vertical connectivity અને Remote Config keys.

**Related docs:** [Phase 4 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md)

---

## 1. Scope (પ્રમાણ)
Phase 4 એ Toy Trains નું ચોથું content update છે જે Levels 1501 થી 2000 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 3 (1001–1500) | Phase 4 (1501–2000) |
|---|---|---|
| Levels | 1001–1500 | **1501–2000 (On-device generated via seed)** |
| Signature System | Day & Night Cycles (A/B) | **Station Floors (Multi-Floor 3D Layout)** |
| Floors Count | 1 tabletop board | **Up to 3 stacked floors (F1, F2, F3)** |
| Camera / Navigation | Single board view | **Floor Tabs UI; Floor switch = 0 Moves** |
| Vertical Transit | None (2D only) | **Stairs (M151), Goods Chute (M153), Lift (M154)** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14 પ્રતિ ફ્લોર** |
| Trains Count | 28–40 trains | **28–40 trains (all floors combined)** |

---

## 2. Signature System: Station Floors (Multi-Floor Rules)
1. **Floor Stacking:** પઝલ બોર્ડ મહત્તમ 3 સ્તરોમાં વહેંચાયેલું છે:
   - **F1 Ground Yard:** નીચલું સ્તર (રેલ્વે યાર્ડ).
   - **F2 Mezzanine:** મધ્યમ સ્તર (પેસેન્જર પ્લેટફોર્મ્સ).
   - **F3 High Line:** ઉપલું સ્તર (એલિવેટેડ વાયાડક્ટ ટ્રેક).
2. **Floor Tabs Navigation:**
   - સ્ક્રીનના જમણા ભાગમાં Floor Tabs (`F1`, `F2`, `F3`) હોય છે.
   - ટેબ પર tap કરીને અન્ય ફ્લોર જોવું એ **Move નથી** (કાઉન્ટર આગળ વધતું નથી, બોર્ડ સ્ટેટ બદલાતું નથી).
   - ખેલાડી કોઈપણ સક્રિય ફ્લોર પર સીધો tap કરીને ટ્રેન રવાના કરી શકે છે.
3. **Vertical Transit Rules:**
   - **M151 Station Stairs:** ટ્રેનની exit lane સીડી પર પહોંચતાં તે ઉપરના કે નીચેના ફ્લોર પર સમાન `(x, y)` સેલથી તે જ દિશામાં આગળ વધે છે. જો લક્ષ્ય સેલ ઓક્યુપાઇડ હોય તો બમ્પ (−1 Heart).
   - **M153 Goods Chute:** ટ્રેન ખાડામાં પ્રવેશે એટલે ગુરુત્વાકર્ષણથી નીચેના ફ્લોર પર પડે છે (relocate, 1 Move).
   - **M154 Goods Lift:** ટ્રેન લિફ્ટ પ્લેટફોર્મ પર સંપૂર્ણપણે ઊભી હોય ત્યારે લિફ્ટ બટન tap કરવાથી ટ્રેન સહિત લિફ્ટ બીજા ફ્લોર પર જાય છે (1 Move).
4. **Visibility:**
   - સામાન્ય ફ્લોર અપારદર્શક (opaque) છે.
   - **M152 Glass Platform** સેલ્સ પરથી નીચેનો ફ્લોર સ્પષ્ટ દેખાય છે અને નીચેની ટ્રેનને ત્યાંથી જ સીધી tap કરી શકાય છે (કોઈ લોક નથી).

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `4` | Player માટે ઉપલબ્ધ મહત્તમ phase. `4` હોય ત્યારે જ L1501 unlock થાય. |
| `phase_4_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_4_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `max_floors_phase_4` | int | `3` | મહત્તમ ફ્લોર મર્યાદા. |
| `seed_overrides_p4` | string | `"{}"` | Emergency overrides for failed seeds. |

