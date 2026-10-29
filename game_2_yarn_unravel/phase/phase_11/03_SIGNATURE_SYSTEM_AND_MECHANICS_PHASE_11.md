# 03 — Signature System & Base Mechanics: Phase 11
> Linked Boards (Twin Hoops) signature system અને Phase 11 ના 4 નવા base mechanics (M501–M504) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 11 index](./README.md) · [01 Scope & Rules](./01_PHASE_11_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Linked Boards (Twin Hoops)
- **Concept:** સિંગલ રેક્ટેન્ગ્યુલર બોર્ડને બદલે બે સમાંતર એમ્બ્રોઇડરી હૂપ્સ (Hoop A અને Hoop B) સ્ક્રીન પર દેખાય છે. દોરાઓ બંને હૂપ્સમાં વિતરિત થયેલા છે અને વચ્ચેની સીવણ સરહદ (Seam Edge) અથવા પોમપોમ પોર્ટલ્સ દ્વારા એકબીજામાં પ્રવેશ કરે છે.
- **Topological Invariants:**
  - બંને હૂપ્સ એક જ સમયમાં સક્રિય રહે છે; પ્લેયર કોઈપણ હૂપ પર રહેલા માન્ય દોરાને ટેપ કરી શકે છે.
  - કેમેરા વ્યુ બંને હૂપ્સને આરામદાયક રીતે સ્ક્રીનમાં ફ્રેમ કરે છે (Smart Auto-Framing).
  - બંને હૂપ્સના તમામ દોરાઓ બહાર નીકળે ત્યારે જ લેવલ જીતાય છે.

---

## 2. Base Mechanics Catalog Cards

### M501 — Seam Edge (Board Link Edge)
- **ID:** `M501` | **Themed Name:** Seam Edge | **Generic:** Board Link Edge | **Intro:** L5011 | **Cat:** T/E | **Hammerable:** No
- **Rule:** બે હૂપ્સ વચ્ચેની સમાન બોર્ડર પર રહેલો સીવેલો ટાંકો. જ્યારે કોઈ દોરાની પુલ લાઇન Hoop A ની સીમ એજમાંથી બહાર નીકળે છે, ત્યારે તે સીધો બોર્ડ બહાર જવાને બદલે Hoop B ની અનુરૂપ રો/કૉલમ સેલમાંથી તે જ દિશામાં આગળ વધે છે. જો Hoop B નો ટાર્ગેટ સેલ બ્લોક હોય તો સ્નેગ થાય છે (-1 Heart). હેમરેબલ નથી.
- **JSON Format:** `{"id":"m501_1","type":"M501","cells":[[7,0]],"params":{"targetBoard":"hoop_b","targetCell":[0,0],"dir":"right"},"hammerable":false}`

---

### M502 — Cross Charm (Cross-board Key)
- **ID:** `M502` | **Themed Name:** Cross Charm | **Generic:** Cross-board Key | **Intro:** L5131 | **Cat:** K | **Hammerable:** Yes (1 charm/snip)
- **Rule:** Hoop A પર સ્થિત એક મેટાલિક ક્રાફ્ટ કી (Charm). જ્યારે Hoop A પરથી તેની સાથે જોડાયેલો દોરો અનરૅવલ થઈને બહાર નીકળે છે, ત્યારે તે Hoop B પર રહેલા મેચિંગ રંગના ક્લેસ્પ (Clasp) ને કાયમી ધોરણે અનલૉક કરે છે. હેમરેબલ છે.
- **JSON Format:** `{"id":"m502_1","type":"M502","cells":[[3,4]],"params":{"sourceBoard":"hoop_a","targetBoard":"hoop_b","linkedClaspId":"clasp_b_1"},"hammerable":true}`

---

### M503 — Mirror Hoop (Mirror Board)
- **ID:** `M503` | **Themed Name:** Mirror Hoop | **Generic:** Mirror Board | **Intro:** L5251 | **Cat:** P | **Hammerable:** No
- **Rule:** Hoop A અને Hoop B વચ્ચે સિંક્રનાઇઝ્ડ ટ્વીન થ્રેડ જોડી. જ્યારે પ્લેયર Hoop A પરના દોરાને ટેપ કરે છે, ત્યારે Hoop B પરનો તેનો મિરર ટ્વીન દોરો પણ આપોઆપ અનરૅવલ થવા લાગે છે. બંને દોરાઓના પાથ ક્લિયર હોવા ફરજિયાત છે; જો કોઈ એક પણ પાથમાં અવરોધ હોય, તો બંને દોરા સ્નેગ થઈને પાછા વળે છે અને કુલ 1 જ Heart ગુમાવાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m503_1","type":"M503","cells":[[2,2]],"params":{"twinBoard":"hoop_b","twinThreadId":"t_b_04"},"hammerable":false}`

---

### M504 — Relay Pompom (Relay Portal)
- **ID:** `M504` | **Themed Name:** Relay Pompom | **Generic:** Relay Portal | **Intro:** L5371 | **Cat:** T | **Hammerable:** No
- **Rule:** સોફ્ટ યાર્ન પોમપોમ પોર્ટલ પેર જે બે હૂપ્સ વચ્ચે વિસ્તરેલી છે (એક પોમપોમ Hoop A માં અને બીજો Hoop B માં). જ્યારે દોરાની સોય Hoop A ના પોમપોમમાં પ્રવેશે છે, ત્યારે તે તરત જ Hoop B ના પોમપોમમાંથી સમાન દિશામાં બહાર નીકળીને આગળનો પાથ કાપે છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m504_1","type":"M504","cells":[[5,5]],"params":{"sourceBoard":"hoop_a","linkedBoard":"hoop_b","linkedCell":[2,2]},"hammerable":false}`

