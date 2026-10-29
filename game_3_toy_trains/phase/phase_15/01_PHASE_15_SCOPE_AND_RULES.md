# 01 · Phase 15 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 15 (Levels 7001–7500) ના નિયમો, Conveyors (Moving Platforms) signature system, બેલ્ટ સ્વિચિંગ, રિવર્સિંગ લીવર્સ, લૂપ બેલ્ટ્સ અને Remote Config keys.

**Related docs:** [Phase 15 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md)

---

## 1. Scope (પ્રમાણ)
Phase 15 એ Toy Trains નું પંદરમું content update છે જે Levels 7001 થી 7500 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 14 (6501–7000) | Phase 15 (7001–7500) |
|---|---|---|
| Levels | 6501–7000 | **7001–7500 (On-device generated via seed)** |
| Signature System | Alpine Pass (Looking-Glass Line) | **Moving Platforms (Conveyors & Tracks)** |
| Track Movement | Static tracks with mirror pairs | **Motorized Conveyor Tracks (Active Transport)** |
| Direction Control | Manual train taps | **Belt Switch (M701) routes conveyor flow L/R** |
| Belt Direction | Fixed flow | **Reversing Belt (M702) inverts flow via lever** |
| Speed Control | Continuous | **Belt Stop Lever (M703) halts/starts linked belts** |
| Infinite Tracks | Linear lines | **Loop Belt (M704) closed continuous loop** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14** |
| Trains Count | 36–50 trains | **36–50 trains** |

---

## 2. Signature System: Moving Platforms (`S15` Rules)
1. **Conveyor Motion (Step 3 Mechanics):**
   - કન્વેયર બેલ્ટ પર ઉભેલી કોઈ પણ ટ્રેન દર મૂવના અંતે (Step 3 tick માં) બેલ્ટની પ્રવાહ દિશામાં આપોઆપ 1 સેલ આગળ વધે છે.
   - જો આગળનો સેલ બ્લોક હોય તો ટ્રેન બેલ્ટ પર જ અટકી જાય છે (બમ્પ થતી નથી પરંતુ સ્લિપ થાય છે).
2. **Belt Switch (M701 Belt Junction):**
   - કન્વેયર બેલ્ટ જંકશન. જ્યારે ટ્રેક બે દિશાઓમાં વિભાજિત થાય છે (Left / Right), ત્યારે આ સ્વિચ પર ટેપ કરવાથી (1 Move) પ્રવાહનો માર્ગ ડાબેથી જમણે ટોગલ થાય છે.
3. **Reversing Belt (M702 Reversible Belt):**
   - બેલ્ટ રિવર્સિંગ લીવર સાથે જોડાયેલો કન્વેયર ટ્રેક.
   - લીવર પર ટેપ કરતાં જ સંલગ્ન તમામ બેલ્ટ સેલ્સની ગતિ દિશા $180^\circ$ ઉલટાઈ જાય છે (Forward <-> Backward).
4. **Belt Stop Lever (M703 Belt Lever):**
   - રેડ/ગ્રીન કન્વેયર બ્રેક લીવર.
   - ટેપ કરવાથી (1 Move) લિન્ક્ડ બેલ્ટ્સ અટકી જાય છે (Pause Mode). ફરી ટેપ કરવાથી તેઓ પુનઃ ચાલુ થાય છે.
5. **Loop Belt (M704 Track Loop):**
   - બંધ પરિપથ (Closed Loop) ધરાવતો 4–8 સેલનો કન્વેયર રીંગ.
   - ટ્રેન આ લૂપમાં પ્રવેશે ત્યારે તે દર મૂવ વખતે ક્લોકવાઇઝ 1 સેલ ગોળ ફરે છે જ્યાં સુધી પ્લેયર તેને ટેપ કરીને બહાર નીકળતી શાખા તરફ રવાના ન કરે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `15` | Player માટે ઉપલબ્ધ મહત્તમ phase. `15` હોય ત્યારે જ L7001 unlock થાય. |
| `phase_15_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_15_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p15` | string | `"{}"` | Emergency overrides for failed seeds in Phase 15. |
