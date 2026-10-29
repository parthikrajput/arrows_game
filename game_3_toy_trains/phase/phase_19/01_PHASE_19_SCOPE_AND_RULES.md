# 01 · Phase 19 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 19 (Levels 9001–9500) ના નિયમો, Mid-Era Analytics Remix (Remix B) signature system, મિડ-એરા ક્રોસ-સિસ્ટમ ફ્યુઝન અને Remote Config keys.

**Related docs:** [Phase 19 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6, §9, §10](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md)

---

## 1. Scope (પ્રમાણ)
Phase 19 એ Toy Trains નું ઓગણીસમું content update છે જે Levels 9001 થી 9500 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 18 (8501–9000) | Phase 19 (9001–9500) |
|---|---|---|
| Levels | 8501–9000 | **9001–9500 (On-device generated via seed)** |
| Signature System | Remix A (P1–P6 Systems) | **Remix B (P7–P12 Systems Synergy)** |
| Base Mechanics Type | Early Era Combo Mechanics | **4 Mid-Era Data Combo Mechanics (M901–M904)** |
| Kinetic Systems | Lifts & Beams | **Rotors, Spores, Splits, Gravity Incline & Twin Tables** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14** |
| Trains Count | 36–52 trains | **38–54 trains** |

---

## 2. Signature System: Remix B (`S19` Rules)
1. **Selection & Telemetry Criteria (§10):**
   - Remix B ના 4 કોમ્બોઝ Phase 7 થી 12 વચ્ચેના સૌથી વધુ રસપ્રદ મિકેનિક્સમાંથી ડેટા-ડ્રિવન સિલેક્શન વડે પસંદ કરવામાં આવ્યા છે.
2. **M901: Turntable Coupling Pad (Rotating Coupler):**
   - 4×4 રોટેટિંગ યાર્ડ બ્લોક (P7) જેની ઉપર મેગ્નેટિક કપલિંગ પેડ્સ (P9) સ્થાપિત છે.
   - જ્યાં સુધી યાર્ડને 90° રોટેટ કરીને યોગ્ય ટ્રેક સાથે સંરેખિત ન કરવામાં આવે, ત્યાં સુધી બંને ટ્રેનો જોડાઈ શકતી નથી.
3. **M902: Incline Seed Wagon (Gravity Spore Train):**
   - સીડ વેગન (P8) જે હિલ લાઇન (P12) ના ઢાળ પર ગુરુત્વાકર્ષણથી આપોઆપ નીચે સરકે છે. સરકતી વખતે તે પોતાના મુસાફરી માર્ગમાં પાછળ વેલના બીજ છોડતી જાય છે જે N Moves પછી અંકુરિત થાય છે.
4. **M903: Cross-Table Metronome Gate (Twin Table Rhythm):**
   - બે જોડાયેલા વુડન ટેબલ્સ Table A અને Table B (P11) વચ્ચેનો મેટ્રોનોમ રિધમ ગેટ (P10).
   - બંને ટેબલ્સ વચ્ચે ટ્રેનોની આવ-જા મેટ્રોનોમના સમાન રિધમિક ઓપન-ક્લોઝ પેટર્ન પર નિયંત્રિત થાય છે.
5. **M904: Hedge-Trimming Split Train (Twin Split Pruner):**
   - ડબલ ટ્રેન (P9) જે ટેપ કરતાં બે સમાંતર ટ્રેનોમાં વિભાજિત થાય છે. બંને ટ્રેનો હેજ ટ્રીમર બ્લેડ્સ (P8) ધરાવે છે અને બંને પાટા પરથી એકસાથે દોડીને બંને બાજુની જંગલી વેલ સાફ કરે છે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `19` | Player માટે ઉપલબ્ધ મહત્તમ phase. `19` હોય ત્યારે જ L9001 unlock થાય. |
| `phase_19_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_19_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p19` | string | `"{}"` | Emergency overrides for failed seeds in Phase 19. |

