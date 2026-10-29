# 01 · Phase 17 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 17 (Levels 8001–8500) ના નિયમો, Guardians (Clock Towers) signature system, ટાવર HP ડિસીપેશન, સ્પોનર્સ, કોર બીમ્સ અને Remote Config keys.

**Related docs:** [Phase 17 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md)

---

## 1. Scope (પ્રમાણ)
Phase 17 એ Toy Trains નું સત્તરમું content update છે જે Levels 8001 થી 8500 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 16 (7501–8000) | Phase 17 (8001–8500) |
|---|---|---|
| Levels | 7501–8000 | **8001–8500 (On-device generated via seed)** |
| Signature System | Ticket Office (Keys Deluxe) | **Clock Towers (Guardians)** |
| Board Structure | Passive key network | **Interactive Multi-Cell Guardian Boss Towers** |
| Health Dynamics | Single barrier open | **Shared & Individual HP Pools (3–8 HP)** |
| Shield Mechanics| Direct key access | **Armoured Tower (M802) order-dependent damage** |
| Hazard Spawning | Static blockers | **Depot Tower (M803) places buffer stops every N moves** |
| Core Requirement| Key exit | **Clock Core (M804) needs HP 0 + active light beam** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14** |
| Trains Count | 36–52 trains | **36–52 trains** |

---

## 2. Signature System: Clock Towers (`S17` Rules)
1. **Twin Clock Towers (M801 Twin Guardian):**
   - બોર્ડ પર બે અલગ ક્લોક ટાવર્સ ($2\times 2$ સેલ્સ દરેક) જે એક જ સંયુક્ત HP પૂલ (દા.ત. 6 HP) શેર કરે છે.
   - કોઈપણ ટાવરની આસપાસથી સંલગ્ન ટ્રેન બહાર નીકળે ત્યારે પૂલમાંથી ૧ HP ઘટે છે. જ્યારે HP 0 થાય ત્યારે બંને ટાવર્સ એકસાથે અદૃશ્ય થાય છે.
2. **Armoured Clock Tower (M802 Shield Guardian):**
   - સુરક્ષિત ઢાલ ધરાવતો ટાવર.
   - ટાવરની આસપાસ દર્શાવેલા ક્રમ મુજબ (દા.ત. 🔴 -> 🔵 -> 🟡) ટ્રેનો બહાર નીકળે તો જ ઢાલ તૂટે છે અને તેનું HP ઘટે છે. ખોટા ક્રમમાં ટ્રેન નીકળતાં ટાવર કોઈ ડેમેજ લેતો નથી.
3. **Depot Tower (M803 Spawner Guardian):**
   - રેલ્વે ડિપો ટાવર.
   - દર N Moves એ (Step 3 tick માં) પોતાના ખાલી પાડોશી સેલમાં નવો બફર સ્ટોપ (Buffer Stop Blocker M001) સ્પોન કરે છે જ્યાં સુધી તેનું HP 0 ન થાય.
4. **Clock Core (M804 Guardian Core):**
   - ટાવરનું સંવેદનશીલ હૃદય/કોર.
   - જ્યારે તેનું HP 0 થાય છે ત્યારે પણ તે તરત અદૃશ્ય થતો નથી; જ્યાં સુધી સિગ્નલ લેમ્પનો બીમ (Signal Light Beam M251) સીધો તેના સેલ પર ન પડે ત્યાં સુધી તે પાટા પર અવરોધ તરીકે રહે છે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `17` | Player માટે ઉપલબ્ધ મહત્તમ phase. `17` હોય ત્યારે જ L8001 unlock થાય. |
| `phase_17_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_17_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p17` | string | `"{}"` | Emergency overrides for failed seeds in Phase 17. |
