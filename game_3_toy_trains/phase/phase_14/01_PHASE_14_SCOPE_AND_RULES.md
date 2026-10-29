# 01 · Phase 14 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 14 (Levels 6501–7000) ના નિયમો, Mirror Worlds (Alpine Pass / Looking-Glass Line) signature system, મિરર અક્ષ, રીફ્લેક્શન લોક્સ, ઇન્વર્સ એન્જિન્સ અને Remote Config keys.

**Related docs:** [Phase 14 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md)

---

## 1. Scope (પ્રમાણ)
Phase 14 એ Toy Trains નું ચૌદમું content update છે જે Levels 6501 થી 7000 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 13 (6001–6500) | Phase 14 (6501–7000) |
|---|---|---|
| Levels | 6001–6500 | **6501–7000 (On-device generated via seed)** |
| Signature System | Weather Station (Fog on the Line) | **Alpine Pass (Looking-Glass Line)** |
| Board Structure | Single fog board | **Symmetrical Board with Central Glacier/Mirror Axis** |
| Mirror Movement | Autonomous roll | **Mirror Rail Axis (M651) moves twin train simultaneously** |
| Paired Barriers | Single exit locks | **Reflection Lock (M652) requires both sides to open** |
| Yard Sharing | Single table | **Alpine Twin Yard (M653) shares full yard layout** |
| Inverted Exits | Standard arrow exit | **Reverse Engine (M654) exits opposite to its arrow** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14 Symmetrical Grid** |
| Trains Count | 34–48 trains | **36–50 trains** |

---

## 2. Signature System: Alpine Pass (`S14` Rules)
1. **Mirror Rail Axis (M651 Alpine Mirror Track):**
   - બોર્ડના કેન્દ્રમાંથી પસાર થતી આલ્પાઇન ગ્લેશિયર અક્ષ (Vertical Axis $X = X_{\text{mid}}$).
   - જ્યારે પ્લેયર ડાબી બાજુની ટ્રેન પર ટેપ કરે છે, ત્યારે જમણી બાજુ રહેલી તેની પ્રતિબિંબિત જોડિયા ટ્રેન (Mirrored Twin) પણ તે જ ક્ષણે મિરર દિશામાં (ડાબે <-> જમણે) સાથે ચાલે છે.
   - જો બંનેમાંથી કોઈ પણ એક ટ્રેનનો પાથ બ્લોક્ડ હોય, તો બંને ટ્રેનો બમ્પ થઈ −1 Heart ગુમાવે છે. બંને પાથ એકસાથે ક્લિયર હોવા અનિવાર્ય છે.
2. **Reflection Lock (M652 Glacier Lock):**
   - મિરર અક્ષની સામસામે આવેલા જોડિયા રેલ્વે બેરિયર્સ.
   - આ બેરિયર ત્યારે જ ખુલે છે જ્યારે બંને બાજુના પ્રતિબિંબિત સ્વિચ/કી-ટ્રેન્સ એકસાથે સક્રિય થાય છે.
3. **Alpine Twin Yard (M653 Mirror Board):**
   - મિરર અક્ષની બંને બાજુ સપ્રમાણ રૂપે ગોઠવાયેલો યાર્ડ.
   - ડાબી બાજુ કરવામાં આવતો કોઈ પણ શન્ટિંગ મૂવ જમણી બાજુના યાર્ડ સેલ પર પ્રતિબિંબિત થાય છે.
4. **Reverse Engine (M654 Inverse Path):**
   - ખાસ આલ્પાઇન ઇન્વર્સ લોકોમોટિવ.
   - સામાન્ય રીતે ટ્રેન તેના એરોની દિશામાં આગળ વધે છે. પરંતુ આ મિરર અર્ધ-ભાગમાં રહેલી ટ્રેન પર ટેપ કરતાં તે પોતાના એરોની બરાબર વિરુદ્ધ દિશામાં રિવર્સ એક્ઝિટ લે છે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `14` | Player માટે ઉપલબ્ધ મહત્તમ phase. `14` હોય ત્યારે જ L6501 unlock થાય. |
| `phase_14_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_14_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p14` | string | `"{}"` | Emergency overrides for failed seeds in Phase 14. |
