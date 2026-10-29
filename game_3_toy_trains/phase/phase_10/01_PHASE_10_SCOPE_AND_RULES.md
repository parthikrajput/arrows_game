# 01 · Phase 10 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 10 (Levels 4501–5000) ના નિયમો, Sequencing (Timetable Master) signature system, મેટ્રોનોમ રિધમ, કલર પેટર્ન લોક્સ, પ્લેટફોર્મ ઓર્ડરિંગ અને Remote Config keys.

**Related docs:** [Phase 10 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md)

---

## 1. Scope (પ્રમાણ)
Phase 10 એ Toy Trains નું દસમું content update છે જે Levels 4501 થી 5000 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 9 (4001–4500) | Phase 10 (4501–5000) |
|---|---|---|
| Levels | 4001–4500 | **4501–5000 (On-device generated via seed)** |
| Signature System | Couple & Uncouple (Split & Merge) | **Timetable Master (Sequencing)** |
| Rhythm Mechanism | Fixed periodic cycles | **Metronome Gate (M451) follows move patterns (e.g. O-O-C)** |
| Exit Locking | Key train exit | **Departure Code Lock (M452) requires color sequence exit** |
| Edge Rules | Any free perimeter | **Platform Order Exit (M453) requires numbered train order** |
| Memory Logic | None | **Echo Signal (M454) repeats previous N exits** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14** |
| Trains Count | 30–42 trains | **32–44 trains** |

---

## 2. Signature System: Timetable Master (`S10` Rules)
1. **Metronome Gate (M451 Rhythm Gate):**
   - રેલ્વે ક્રોસિંગ ગેટ જે પુનરાવર્તિત મૂવ પેટર્ન અનુસરે છે (દા.ત. `["open", "open", "closed"]`).
   - દર Move એ સ્ટેપ 3 માં પોઇન્ટર આગળ વધે છે. જ્યારે સ્ટેટ "open" હોય ત્યારે જ ટ્રેન પસાર થઈ શકે છે; "closed" હોય ત્યારે ટ્રેન બમ્પ થઈ −1 Heart ગુમાવે છે.
2. **Departure Code Lock (M452 Pattern Lock):**
   - મુખ્ય ટ્રેક પર આવેલો કોડ બેરિયર. તેની ઉપર રંગોનો ચોક્કસ સિક્વન્સ (દા.ત. [Red, Blue, Green]) દર્શાવેલો હોય છે.
   - જ્યારે સ્ટેશનમાંથી ટ્રેનો દર્શાવેલા રંગ ક્રમ મુજબ બહાર નીકળે છે, ત્યારે જ આ બેરિયર કાયમી ધોરણે ખુલી જાય છે. ખોટા ક્રમમાં ટ્રેન નીકળે તો પેટર્ન રીસેટ થાય છે.
3. **Platform Order Exit (M453 Order Edge):**
   - સ્ટેશનનો પ્લેટફોર્મ એક્ઝિટ એજ. આ એજ પર ક્રમાંકો (1, 2, 3...) અંકિત હોય છે.
   - આ એજ માત્ર પોતાના ક્રમાંકવાળી ટ્રેનને જ પસાર થવા દે છે. દા.ત. ટ્રેન #1 નીકળ્યા પછી જ ટ્રેન #2 માટે એજ મુક્ત બને છે.
4. **Echo Signal (M454 Echo Sequence):**
   - મેમરી-આધારિત રેલ્વે સિગ્નલ. પાછલી N ટ્રેનો (દા.ત. N = 2) જે રંગની બહાર નીકળી હોય, તે પછીની N ટ્રેનો પણ બરાબર તે જ રંગોનું પુનરાવર્તન કરે તો જ સિગ્નલ ગ્રીન રહે છે; અન્યથા લાલ થઈ પાટો બ્લોક કરે છે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `10` | Player માટે ઉપલબ્ધ મહત્તમ phase. `10` હોય ત્યારે જ L4501 unlock થાય. |
| `phase_10_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_10_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p10` | string | `"{}"` | Emergency overrides for failed seeds in Phase 10. |
