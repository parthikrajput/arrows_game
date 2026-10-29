# 01 · Phase 13 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 13 (Levels 6001–6500) ના નિયમો, Hidden Information (Weather Station / Fog on the Line) signature system, સ્કાઉટ ટ્રેન, મિરાજ સ્ટીમ, ફોલ્સ વાડ અને Remote Config keys.

**Related docs:** [Phase 13 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md)

---

## 1. Scope (પ્રમાણ)
Phase 13 એ Toy Trains નું તેરમું content update છે જે Levels 6001 થી 6500 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 12 (5501–6000) | Phase 13 (6001–6500) |
|---|---|---|
| Levels | 5501–6000 | **6001–6500 (On-device generated via seed)** |
| Signature System | Hill Line (Gravity & Incline) | **Weather Station (Fog on the Line)** |
| Fog Coverage | Local steam clouds | **Dynamic Fog of War covering track sections** |
| Active Scout | None | **Scout Draisine (M601) reveals radius 1 cells on exit** |
| Decoy Objects | None | **Mirage Steam (M602) creates decoy trains** |
| Optical Illusion | None | **Painted Backdrop (M603) allows trains to pass through** |
| Pressure Light | Static signal lamps | **Lantern Plate (M604) lifts radius 2 fog while covered** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14** |
| Trains Count | 34–46 trains | **34–48 trains** |

---

## 2. Signature System: Weather Station (`S13` Rules)
1. **Scout Draisine (M601 Scout Path):**
   - નાની હળવી સ્કાઉટ હેન્ડકાર્ટ/ડ્રેસીન.
   - જ્યારે આ સ્કાઉટ ટ્રેન બોર્ડમાંથી સફળતાપૂર્વક બહાર નીકળે છે, ત્યારે તે પોતાની સમગ્ર એક્ઝિટ લેનની આસપાસના 1-સેલ વિસ્તારમાં છવાયેલા તમામ સ્ટીમ ધુમ્મસને કાયમી ધોરણે દૂર કરે છે.
2. **Mirage Steam (M602 Mimic Fog):**
   - સ્ટીમ ક્લાઉડ જે ધુમ્મસની અંદર આભાસી (Decoy) ટ્રેન જેવો આકાર દર્શાવે છે.
   - ખેલાડીને લાગે છે કે પાટો બ્લોક્ડ છે, પરંતુ જો ખેલાડી Route Peek (લોન્ગ પ્રેસ) વાપરે તો તે ખાલી પાટો દર્શાવે છે. વાસ્તવિક ટ્રેન તેના પરથી અસ્ખલિત પસાર થઈ શકે છે.
3. **Painted Backdrop (M603 False Wall):**
   - દેખાવમાં સામાન્ય લાકડાની વાડ (Wooden Fence Blocker) જેવો અવરોધ.
   - વાસ્તવમાં તે ઓપ્ટિકલ ઇલ્યુઝન (ભ્રમણા) છે. ટ્રેન તેની આરપાર નીકળી શકે છે. Route Peek માં તે લાલ અવરોધને બદલે લીલો પાથ દર્શાવે છે.
4. **Lantern Plate (M604 Reveal Plate):**
   - ટ્રેક પર સ્થાપિત લેન્ટર્ન સ્વીચ પ્લેટ.
   - જ્યાં સુધી કોઈ પણ ટ્રેનનું શરીર આ પ્લેટ ઉપર સ્થિર રહે છે, ત્યાં સુધી તેના કેન્દ્રથી રેડિયસ 2 ના તમામ સેલ્સનું ધુમ્મસ સંપૂર્ણ હટેલું રહે છે. ટ્રેન ખસી જતાં ધુમ્મસ ફરી વળે છે (જો સ્કાઉટ ન થયું હોય તો).

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `13` | Player માટે ઉપલબ્ધ મહત્તમ phase. `13` હોય ત્યારે જ L6001 unlock થાય. |
| `phase_13_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_13_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p13` | string | `"{}"` | Emergency overrides for failed seeds in Phase 13. |
