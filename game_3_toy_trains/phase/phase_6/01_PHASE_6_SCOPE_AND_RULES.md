# 01 · Phase 6 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 6 (Levels 2501–3000) ના નિયમો, Light & Beams+ (Signal Lights+) signature system, beam tracing rules, optical sensors અને Remote Config keys.

**Related docs:** [Phase 6 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md)

---

## 1. Scope (પ્રમાણ)
Phase 6 એ Toy Trains નું છઠ્ઠું content update છે જે Levels 2501 થી 3000 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 5 (2001–2500) | Phase 6 (2501–3000) |
|---|---|---|
| Levels | 2001–2500 | **2501–3000 (On-device generated via seed)** |
| Signature System | Yard Shunting+ (Push Physics) | **Signal Lights+ (Light & Beams+)** |
| Optics & Beams | None | **Continuous optical signal beams & sensors** |
| Beam Interruption | None | **Passing trains cut beams; sensors deactivate** |
| Dynamic Lighting | Static day/night | **Blackout Patches (Dark cells illuminated by beams)** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14** |
| Trains Count | 28–40 trains | **28–40 trains** |

---

## 2. Signature System: Signal Lights+ (Beam Tracing Rules)
1. **Beam Emitters (Signal Lamps):**
   - બોર્ડ પર સ્થિર અથવા ટાઈમર આધારિત સિગ્નલ લેમ્પ્સ સતત પ્રકાશનો સીધો બીમ ફેંકે છે.
   - બીમ પારદર્શક ટ્રેક્સ, કાચ અને ખુલ્લા સેલ્સમાંથી સીધો પસાર થાય છે જ્યાં સુધી તે દીવાલ, મિરર કે સેન્સરને ન અડકે.
2. **Train Obstruction:**
   - જ્યારે કોઈ ટ્રેન બીમના માર્ગમાંથી પસાર થાય છે, ત્યારે ટ્રેનની બોડી બીમને બ્લોક કરે છે.
   - બીમ કટ થતાં લક્ષ્ય સેન્સર તરત ડી-એક્ટિવેટ થાય છે. ટ્રેન સંપૂર્ણ પસાર થઈ જતાં બીમ ફરી સેન્સર સુધી પહોંચે છે.
3. **Sensor Gates:**
   - સિગ્નલ સેન્સર પર બીમ પડતો હોય ત્યાં સુધી જોડાયેલો રેલ્વે ગેટ ખુલ્લો રહે છે. બીમ કટ થતાં ગેટ બંધ થઈ જાય છે (બમ્પ ⇒ −1 Heart).
4. **Coloured Lens (M251):**
   - રંગીન લેન્સમાંથી પસાર થતાં બીમ તે લેન્સનો રંગ ધારણ કરે છે (દા.ત. Red, Green, Blue). સેન્સર્સ માત્ર પોતાના મેળ ખાતા રંગના બીમથી જ પ્રતિક્રિયા આપે છે.
5. **Twin Sensor Gate (M252):**
   - બે જુદા જુદા સેન્સર્સ લિંક થયેલા હોય છે; દરવાજો ત્યારે જ ખુલે છે જ્યારે બંને સેન્સર્સ પર એકસાથે બીમ પડતો હોય (Splitter beam અથવા બે લેમ્પ્સ).
6. **Lamp Timer (M253):**
   - સિગ્નલ લેમ્પ દર N Moves એ આપોઆપ ચાલુ/બંધ થાય છે (Move resolution ના Step 3 માં tick).
7. **Blackout Patch (M254):**
   - અંધારા સેલ્સમાં રહેલી ટ્રેનો લૉક રહે છે અને અદૃશ્ય હોય છે (locked tap). જ્યારે કોઈ બીમ અંધારા સેલ પર પડે છે, ત્યારે સેલ પ્રકાશિત થાય છે અને ટ્રેન સક્રિય બને છે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `6` | Player માટે ઉપલબ્ધ મહત્તમ phase. `6` હોય ત્યારે જ L2501 unlock થાય. |
| `phase_6_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_6_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p6` | string | `"{}"` | Emergency overrides for failed seeds. |
