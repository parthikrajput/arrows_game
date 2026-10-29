# 01 · Phase 8 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 8 (Levels 3501–4000) ના નિયમો, Growth (Overgrown Branch Line) signature system, ivy spread order, pruning mechanics, bloom gates અને Remote Config keys.

**Related docs:** [Phase 8 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md)

---

## 1. Scope (પ્રમાણ)
Phase 8 એ Toy Trains નું આઠમું content update છે જે Levels 3501 થી 4000 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 7 (3001–3500) | Phase 8 (3501–4000) |
|---|---|---|
| Levels | 3001–3500 | **3501–4000 (On-device generated via seed)** |
| Signature System | Turntable Yards+ (Rotation) | **Overgrown Branch Line (Growth)** |
| Growth Rate | 1 cell per N moves (M027) | **Wild Ivy+ (M351) expands into 2 cells per N moves** |
| Active Cleaning | Single hammer hit | **Hedge Trimmer Car (M352) prunes all adjacent ivy** |
| Dynamic Seeding | None | **Seed Wagon (M353) drops delayed growth seeds** |
| Bloom Gates | Static key barriers | **Flower Arch (M354) unlocks when K ivy cells touch it** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14** |
| Trains Count | 28–40 trains | **28–40 trains** |

---

## 2. Signature System: Overgrown Branch Line (Growth Rules)
1. **Wild Ivy+ (M351) Growth Order:**
   - દર N Moves એ (Step 3 tick માં) વેલ પોતાના નજીકના મહત્તમ **2 ખાલી સેલ્સ** માં વિસ્તરે છે.
   - વિસ્તરણ ક્રમ નિશ્ચિત (deterministic) છે: `Up -> Right -> Down -> Left`.
   - વેલ ટ્રેક સેલને બ્લોક કરે છે; તેના પર આવતી ટ્રેન બમ્પ થઈ −1 Heart ગુમાવે છે.
2. **Hedge Trimmer Car (M352):**
   - ટ્રેક પરનો ખાસ પ્રોટેક્શન સેલ. જ્યારે કોઈ ટ્રેનની exit lane આ સેલ પરથી પૂર્ણપણે પસાર થાય છે, ત્યારે તે લેનની બંને બાજુ ઓર્થોગોનલી જોડાયેલા તમામ વેલ સેલ્સ કપાઈને સાફ થઈ જાય છે.
3. **Seed Wagon (M353):**
   - ટ્રેન જ્યારે બોર્ડમાંથી બહાર નીકળે છે, ત્યારે તે પોતાના છેલ્લા બોડી સેલ પર એક બીજ (Seed) છોડી જાય છે.
   - N Moves પછી આ બીજ અંકુરિત થઈ નવો વેલ સ્પ્રેડર બની જાય છે.
4. **Flower Arch (M354 Bloom Gate):**
   - ફૂલોથી સુશોભિત રેલ્વે કમાન. સામાન્ય ટ્રેનો માટે આ કમાન બ્લોકર છે.
   - જ્યારે બોર્ડ પર ફેલાતી વેલના K સેલ્સ (દા.ત. K = 4) આ કમાનને સ્પર્શે છે, ત્યારે ફૂલો ખીલે છે અને કમાન કાયમી ધોરણે ખુલી જાય છે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `8` | Player માટે ઉપલબ્ધ મહત્તમ phase. `8` હોય ત્યારે જ L3501 unlock થાય. |
| `phase_8_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_8_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p8` | string | `"{}"` | Emergency overrides for failed seeds. |
