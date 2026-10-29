# 03 — Signature System & Base Mechanics: Phase 6
> Light & Beams+ (Lamplight Atelier) signature system અને Phase 6 ના 4 નવા base mechanics (M251–M254) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 6 index](./README.md) · [01 Scope & Rules](./01_PHASE_6_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Light & Beams+ (Lamplight Atelier)
- **Concept:** ક્રાફ્ટ બોર્ડની કિનારી પર અથવા સેન્ટરમાં વિન્ટેજ બ્રાસ લેમ્પ્સ (Atelier Lamps) ગોઠવાયેલા છે જે સોનેરી પ્રકાશ કિરણો ફેંકે છે.
- **Ray-Casting:** કિરણો સેલ બાય સેલ સીધી રેખામાં પ્રવાસ કરે છે. દોરાનું શરીર કે નક્કર અવરોધ કિરણને રોકે છે. જ્યારે દોરો અનરૅવલ થઈ જાય છે, ત્યારે પ્રકાશ તરત જ આગળ વિસ્તરે છે.
- **Sun-Catchers:** બોર્ડ પર નાના ગ્લાસ સન-કેચર્સ છે જે પ્રકાશ મેળવતાં જ તેમની સાથે જોડાયેલા ગેટ્સ ખોલે છે.

---

## 2. Base Mechanics Catalog Cards

### M251 — Tinted Glass (Color Filter)
- **ID:** `M251` | **Themed Name:** Tinted Glass | **Generic:** Color Filter | **Intro:** L2511 | **Cat:** B/D | **Hammerable:** Yes
- **Rule:** બોર્ડ સેલ પર પારદર્શક રંગીન કાચ છે. જ્યારે સામાન્ય સફેદ પ્રકાશ કિરણ આ કાચમાંથી પસાર થાય છે, ત્યારે તે કાચનો રંગ (દા.ત. લાલ કે લીલો) ધારણ કરે છે. કલર્ડ સન-કેચર્સ માત્ર તેમના મેચિંગ કલરના કિરણથી જ સક્રિય થાય છે. દોરાઓ કાચ સાથે અથડાતાં સ્નેગ થાય છે (-1 Heart). હેમરેબલ છે (સ્નિપ કરવાથી કાચ તૂટે છે).
- **JSON Format:** `{"id":"m251_1","type":"M251","cells":[[5,4]],"params":{"filterColor":"green"},"hammerable":true}`

---

### M252 — Prism Clasp (Beam Splitter Lock)
- **ID:** `M252` | **Themed Name:** Prism Clasp | **Generic:** Beam Splitter Lock | **Intro:** L2631 | **Cat:** K | **Hammerable:** No
- **Rule:** પ્રિઝમ આકારનો મજબૂત મેટાલિક ક્લેસ્પ લોક. તે સામાન્ય રીતે સિંગલ બ્લોકર તરીકે વર્તે છે. જ્યારે એક જ Move ના અંતે $\ge 2$ અલગ અલગ પ્રકાશ કિરણો (દા.ત. બે અલગ અલગ દિશામાંથી) આ પ્રિઝમ પર એકસાથે આપાત થાય છે, ત્યારે ક્લેસ્પ કાયમી ધોરણે ખુલી જાય છે અને સેલ ક્લિયર ફ્લોર બને છે.
- **JSON Format:** `{"id":"m252_1","type":"M252","cells":[[7,7]],"params":{"requiredBeams":2},"hammerable":false}`

---

### M253 — Hourglass Lamp (Beam Timer)
- **ID:** `M253` | **Themed Name:** Hourglass Lamp | **Generic:** Beam Timer | **Intro:** L2751 | **Cat:** T/C | **Hammerable:** No
- **Rule:** મુવ-આધારિત અવરગ્લાસ લેમ્પ. તે N મૂવ્સ સુધી પ્રકાશ કિરણ ચાલુ રાખે છે અને ત્યારબાદ N મૂવ્સ સુધી બંધ થઈ જાય છે (દા.ત. 3 મૂવ્સ ON, 3 મૂવ્સ OFF). આ સંપૂર્ણપણે ટર્ન-આધારિત છે; કોઈ વોલ-ક્લોક ટાઈમર નથી. લેમ્પ સેલ પોતે બ્લોકર છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m253_1","type":"M253","cells":[[2,2]],"params":{"interval":3,"initialState":"ON"},"hammerable":false}`

---

### M254 — Shadow Pocket (Dark Cells)
- **ID:** `M254` | **Themed Name:** Shadow Pocket | **Generic:** Dark Cells | **Intro:** L2871 | **Cat:** C/K | **Hammerable:** No
- **Rule:** ક્રાફ્ટ બોર્ડનો અંધારાવાળો ભાગ (શેડો પોકેટ). જો કોઈ દોરાનું કોઈપણ સેગમેન્ટ અંધારા સેલમાં હોય, તો તે દોરો ટેપ કરવા માટે **લૉક** રહે છે (સોફ્ટ વોબલ + "tick" સાઉન્ડ, 0 Heart). જ્યારે કોઈ પ્રકાશ કિરણ તે શેડો પોકેટ પરથી પસાર થાય છે, ત્યારે તે સેલ પ્રકાશિત થાય છે અને દોરો તાત્કાલિક ટેપ કરવા સક્ષમ બને છે.
- **JSON Format:** `{"id":"m254_1","type":"M254","cells":[[8,4],[8,5],[9,4],[9,5]],"params":{"illuminated":false},"hammerable":false}`

