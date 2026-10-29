# 03 — Signature System & Base Mechanics: Phase 4
> Multi-Floor (Sewing Room Floors) signature system અને Phase 4 ના 4 નવા base mechanics (M151–M154) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 4 index](./README.md) · [01 Scope & Rules](./01_PHASE_4_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Multi-Floor (Sewing Room Floors)
- **Concept:** લાકડાની લૂમ પર વર્ટિકલ ફ્રેમ્સ રચાય છે: Floor 1 (એમ્બ્રોઇડરી ટેબલ), Floor 2 (કટિંગ ટેબલ), Floor 3 (એટિક લૂમ).
- **Floor Navigation:** ખેલાડી HUD પરના F1, F2, F3 ટેબ્સ વડે કેમેરા મુક્તપણે સ્વિચ કરી શકે છે (ખર્ચ: 0 Moves).
- **Camera Glide:** ફ્લોર બદલાતાં 250 ms નો સ્મૂધ વર્ટિકલ પેનિંગ એનિમેશન ચાલે છે.
- **Preview Integration:** Thread Peek લોંગ-પ્રેસ વર્ટિકલ સ્ટેર્સ અને ડ્રોપ હોલ્સમાંથી પસાર થઈને અન્ય ફ્લોર પરની લાઇન પણ ટ્રેસ કરે છે.

---

## 2. Base Mechanics Catalog Cards

### M151 — Spiral Spool Stair (Stairs)
- **ID:** `M151` | **Themed Name:** Spiral Spool Stair | **Generic:** Stairs | **Intro:** L1511 | **Cat:** D/L | **Hammerable:** No
- **Rule:** બોર્ડ સેલ પર સ્ટીલની સ્પૂલ સીડી છે. આ સેલમાં પ્રવેશેલો દોરો તાત્કાલિક લક્ષ્ય ફ્લોર પર તે જ `(x, y)` સેલમાં તે જ દિશામાં આગળ વધે છે. જો લક્ષ્ય ફ્લોર પરનો એક્ઝિટ પાથ બ્લોક હોય તો દોરો સીડીના પ્રવેશદ્વારે સ્નેગ થાય છે (-1 Heart).
- **JSON Format:** `{"id":"m151_1","type":"M151","cells":[[3,5]],"params":{"targetFloor":2},"hammerable":false}`

---

### M152 — Organza Floor (Glass Floor)
- **ID:** `M152` | **Themed Name:** Organza Floor | **Generic:** Glass Floor | **Intro:** L1631 | **Cat:** L | **Hammerable:** No
- **Rule:** ઉપરના ફ્લોર પર પારદર્શક ઓર્ગેન્ઝા સિલ્કનું પેચ છે. આ સેલની નીચે રહેલા લોઅર ફ્લોરના દોરાઓ સ્પષ્ટપણે દેખાય છે અને ઉપરના ફ્લોર પરથી સીધા ટેપ કરીને અનરૅવલ કરી શકાય છે.
- **Tap Priority:** Organza સેલ પર જો ઉપરના ફ્લોર પર પણ દોરો હોય, તો ઉપરનો દોરો પ્રથમ ટેપ મેળવે છે.
- **JSON Format:** `{"id":"m152_1","type":"M152","cells":[[5,5],[5,6],[6,5],[6,6]],"params":{"seeThroughFloor":1},"hammerable":false}`

---

### M153 — Drop Hole (Drop Hole)
- **ID:** `M153` | **Themed Name:** Drop Hole | **Generic:** Drop Hole | **Intro:** L1751 | **Cat:** D/L | **Hammerable:** No
- **Rule:** કાપડ બોર્ડ પરનું ગોળ કાણું. દોરો તેની પુલ લાઇન દરમિયાન આ કાણા પર પહોંચતાં જ સીધો નીચેના ફ્લોર પર તે સેલમાં ડ્રોપ થાય છે અને ત્યાં રિલોકેટ થાય છે (ખર્ચ: 1 Move). તે નીચેના ફ્લોર પર સામાન્ય દોરાની જેમ રહે છે અને આગલા ટેપ પર નીચેના ફ્લોર પરથી ખેંચાય છે.
- **JSON Format:** `{"id":"m153_1","type":"M153","cells":[[7,7]],"params":{"destinationFloor":1},"hammerable":false}`

---

### M154 — Bobbin Lift (Elevator)
- **ID:** `M154` | **Themed Name:** Bobbin Lift | **Generic:** Elevator | **Intro:** L1871 | **Cat:** T | **Hammerable:** No
- **Rule:** ઇન્ટરેક્ટિવ બોબિન લિફ્ટ ટાઇલ. જ્યારે કોઈ દોરાની સોય લિફ્ટ સેલ પર ઊભી હોય ત્યારે લિફ્ટ પર ટેપ કરવાથી તે દોરો ઊર્ધ્વગમન/અધોગમન કરીને ઉપરના કે નીચેના ફ્લોર પર જાય છે (ખર્ચ: 1 Move). જો લિફ્ટ પર કોઈ દોરો ન હોય તો ટેપ લોક wobble દર્શાવે છે (0 Move).
- **JSON Format:** `{"id":"m154_1","type":"M154","cells":[[4,4]],"params":{"linkedFloors":[1,2]},"hammerable":false}`

