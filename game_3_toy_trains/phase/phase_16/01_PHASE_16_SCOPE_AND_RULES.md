# 01 · Phase 16 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 16 (Levels 7501–8000) ના નિયમો, Keys Deluxe (Ticket Office) signature system, ટિકિટ ચેઇન્સ, પંચિંગ/ક્રાફ્ટિંગ, માસ્ટર પાસ અને Remote Config keys.

**Related docs:** [Phase 16 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md)

---

## 1. Scope (પ્રમાણ)
Phase 16 એ Toy Trains નું સોળમું content update છે જે Levels 7501 થી 8000 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 15 (7001–7500) | Phase 16 (7501–8000) |
|---|---|---|
| Levels | 7001–7500 | **7501–8000 (On-device generated via seed)** |
| Signature System | Moving Platforms (Conveyors) | **Ticket Office (Keys Deluxe)** |
| Key Logic | Single independent tickets | **Ticket Chain (M751) sequential key releases** |
| Key Assembly | Pre-spawned full keys | **Ticket Punch (M752) combines two half-tickets** |
| Skeleton Key | None | **Master Pass (M753) opens any single barrier** |
| Key Reallocation| Fixed train keys | **Ticket Swap Pad (M754) swaps keys between trains** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **12×12 થી 14×14** |
| Trains Count | 36–50 trains | **36–52 trains** |

---

## 2. Signature System: Ticket Office (`S16` Rules)
1. **Ticket Chain (M751 Key Chain):**
   - સાંકળિત રેલ્વે બેરિયર્સ. જ્યારે ટિકિટ કાર A બેરિયર A ને ખોલે છે, ત્યારે તે બેરિયરની અંદરથી નવી ટિકિટ કાર B પાટા પર છૂટી થાય છે, જે આગળના બેરિયર B ને ખોલવા જરૂરી છે.
2. **Ticket Punch (M752 Key Crafting):**
   - ટ્રેક પર આવેલું પંચ બૂથ (Punch Station).
   - પાટા પર 2 અલગ અર્ધ-ટિકિટો (Half-Ticket Stubs [Left] અને [Right]) હોય છે. જ્યારે બંને હાફ-ટિકિટો સ્ટેશનમાં પ્રવેશે છે અથવા પંચ બૂથ ઓળંગે છે, ત્યારે તેઓ આપોઆપ જોડાઈને 1 પૂર્ણ માન્ય ગોલ્ડન ટિકિટ બની જાય છે.
3. **Master Pass (M753 Skeleton Key):**
   - ગોલ્ડન લોકોમોટિવ જે માસ્ટર પાસ વહન કરે છે.
   - આ ટ્રેન પોતાના મુસાફરી માર્ગમાં આવતા કોઈપણ પ્રથમ રેલ્વે બેરિયર (લાલ, વાદળી કે લીલો) પર પહોંચતાં જ તેને તુરંત અનલોક કરી દે છે. અનલોક કર્યા પછી માસ્ટર પાસ વપરાઈ જાય છે (Single Use).
4. **Ticket Swap Pad (M754 Key Swap):**
   - બે જોડીદાર ટ્રેક પેડ્સ.
   - જ્યારે બે ટિકિટ ધારક ટ્રેનો બંને પેડ્સ પર આવીને ઊભી રહે છે, ત્યારે પેડ પર ટેપ કરવાથી (1 Move) બંને ટ્રેનો વચ્ચે ટિકિટ પ્રતીકો (ચાવીઓ) અદલાબદલી (swap) થાય છે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `16` | Player માટે ઉપલબ્ધ મહત્તમ phase. `16` હોય ત્યારે જ L7501 unlock થાય. |
| `phase_16_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_16_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p16` | string | `"{}"` | Emergency overrides for failed seeds in Phase 16. |
