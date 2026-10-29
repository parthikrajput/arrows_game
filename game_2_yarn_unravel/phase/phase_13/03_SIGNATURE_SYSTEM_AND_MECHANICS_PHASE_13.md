# 03 — Signature System & Base Mechanics: Phase 13
> Hidden Info (Mystery Basket) signature system અને Phase 13 ના 4 નવા base mechanics (M601–M604) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 13 index](./README.md) · [01 Scope & Rules](./01_PHASE_13_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Hidden Info (Mystery Basket)
- **Concept:** ક્રાફ્ટ બાસ્કેટમાં પડેલા ઊનના ગૂંચડાઓ અને રુંવાટી (Fluff) ક્યારેક બોર્ડના મહત્વના ભાગોને છુપાવી દે છે. ખેલાડીએ સ્કાઉટિંગ, લેન્ટર્ન રોશની અને સત્ય-ભ્રમની ઓળખ દ્વારા ગૂંચ ઉકેલવી પડે છે.
- **Rules & Mechanics:**
  - ફોગ નીચે રહેલા દોરાઓ અદૃશ્ય હોય છે અને સીધા ટેપ થઈ શકતા નથી (લૉક્ડ ટેપ).
  - થ્રેડ પીક (Thread Peek) ફોગમાં પ્રવેશતા રસ્તા પર '?' ચિહ્ન દર્શાવે છે.
  - તમામ હિડન ઇન્ફો પઝલ્સ હંમેશાં દૃશ્યમાન સ્કાઉટ થ્રેડ્સ વડે પ્રથમ ખુલી શકે તેવા ક્રમમાં ડિઝાઇન થયેલા હોય છે (0-hearts solvable).

---

## 2. Base Mechanics Catalog Cards

### M601 — Scout Thread (Scout Path)
- **ID:** `M601` | **Themed Name:** Scout Thread | **Generic:** Scout Path | **Intro:** L6011 | **Cat:** P | **Hammerable:** Yes
- **Rule:** તેજસ્વી સિલ્વર હેડ ધરાવતો દોરો. જ્યારે તે સફળતાપૂર્વક અનરૅવલ થઈને બોર્ડ બહાર નીકળે છે, ત્યારે તેના સમગ્ર પાથથી 1-સેલ રેડિયસ (Chebyshev distance $\le 1$) માં આવેલું તમામ વૂલ ફ્લફ કાયમી ધોરણે સાફ થઈ જાય છે અને છુપાયેલા દોરાઓ ટેપ-સક્ષમ બને છે. હેમરેબલ છે.
- **JSON Format:** `{"id":"m601_1","type":"M601","cells":[[4,2],[4,3],[4,4]],"params":{"revealRadius":1},"hammerable":true}`

---

### M602 — Decoy Fluff (Mimic Fog)
- **ID:** `M602` | **Themed Name:** Decoy Fluff | **Generic:** Mimic Fog | **Intro:** L6131 | **Cat:** B | **Hammerable:** Yes (1 fluff/snip)
- **Rule:** સામાન્ય વૂલ ફ્લફ જેવો જ દેખાતો સોફ્ટ પેચ જે ખેલાડીને લાગે છે કે નીચે અવરોધ છે, પરંતુ હકીકતમાં તે સંપૂર્ણ ખાલી છે. કોઈપણ દોરાની પુલ લાઇન આ પેચ પરથી પસાર થતાં જ આ ડેકોય ફ્લફ વિખેરાઈને અદૃશ્ય થઈ જાય છે. હેમરેબલ છે.
- **JSON Format:** `{"id":"m602_1","type":"M602","cells":[[7,6]],"params":{},"hammerable":true}`

---

### M603 — Painted Wall (False Wall)
- **ID:** `M603` | **Themed Name:** Painted Wall | **Generic:** False Wall | **Intro:** L6251 | **Cat:** B | **Hammerable:** No
- **Rule:** ફેબ્રિક પર કુશળતાપૂર્વક દોરેલો રૂલર બ્લોકર (M002). દેખાવમાં અસલી લાકડાની દિવાલ જેવો લાગે છે જેથી ખેલાડી દોરો ખેંચતાં ખચકાય, પરંતુ દોરાઓ તેના આરપાર મુક્તપણે પસાર થઈ શકે છે! પ્રથમ પાસ વખતે જ તે પારદર્શક સફેદ ચોક આઉટલાઇનમાં ફેરવાઈ જાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m603_1","type":"M603","cells":[[5,9]],"params":{},"hammerable":false}`

---

### M604 — Lantern Plate (Reveal Plate)
- **ID:** `M604` | **Themed Name:** Lantern Plate | **Generic:** Reveal Plate | **Intro:** L6371 | **Cat:** D | **Hammerable:** No
- **Rule:** બોર્ડ પર સ્થાપિત નાની પિત્તળની લેન્ટર્ન પ્રેશર પ્લેટ. જ્યાં સુધી કોઈપણ દોરાનું શરીર (Body cell) આ પ્લેટ પર દબાયેલું રહે છે, ત્યાં સુધી બોર્ડનું તમામ વૂલ ફ્લફ સેમી-ટ્રાન્સપરન્ટ (40% opacity) બની જાય છે જેથી ખેલાડી નીચેની ગ્રીડ જોઈ શકે છે (પરંતુ દોરાઓ ફોગ સાફ ન થાય ત્યાં સુધી લૉક્ડ રહે છે). હેમરેબલ નથી.
- **JSON Format:** `{"id":"m604_1","type":"M604","cells":[[8,3]],"params":{"revealOpacity":0.4},"hammerable":false}`

