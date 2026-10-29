# 03 — Signature System & Base Mechanics: Phase 16
> Keys Deluxe (Jewel Box) signature system અને Phase 16 ના 4 નવા base mechanics (M751–M754) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 16 index](./README.md) · [01 Scope & Rules](./01_PHASE_16_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Keys Deluxe (Jewel Box)
- **Concept:** જૂના લાકડાના જ્વેલરી બોક્સમાં રહેલા કિંમતી ક્રાફ્ટ ચાર્મ્સ અને લોક્સ. Phase 16 માં કી મિકેનિક્સ વધુ ઊંડાણપૂર્વક વિસ્તરે છે—ચાર્મ્સને ક્રમમાં એકત્ર કરવા, અડધા ચાર્મ્સ જોડીને નવી કી બનાવવી અને યુનિવર્સલ સ્કેલેટન કી દ્વારા જટિલ લોક્સ ઉકેલવા.
- **Rules & Constraints:**
  - ચેઇન ચાર્મ્સ બહાર કાઢવાનો ક્રમ તોડી શકાતો નથી; ખોટો ટેપ લૉક રહે છે.
  - ક્રાફ્ટેડ કી બંને જરૂરી દોરાઓ બહાર નીકળતાં જ આપોઆપ ફોર્જ થાય છે.
  - તમામ પઝલ્સ 0-hearts solvable છે.

---

## 2. Base Mechanics Catalog Cards

### M751 — Charm Chain (Key Chain)
- **ID:** `M751` | **Themed Name:** Charm Chain | **Generic:** Key Chain | **Intro:** L7511 | **Cat:** K | **Hammerable:** No
- **Rule:** સોનાના ક્રમાંકિત બેજ ($1, 2, 3$) ધરાવતા ચાર્મ દોરાઓની શૃંખલા. ખેલાડીએ પહેલાં ચાર્મ 1 વાળા દોરાને બહાર કાઢવો પડે છે, પછી જ ચાર્મ 2 વાળો દોરો ટેપ-સક્ષમ બને છે. જો આઉટ-ઓફ-ઓર્ડર દોરો ટેપ કરાય તો સોય વાઇબ્રેટ થાય છે અને લૉક્ડ ટેપ રિસ્પોન્સ મળે છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m751_1","type":"M751","cells":[[3,3]],"params":{"chainId":"chain_alpha","index":1,"total":3},"hammerable":false}`

---

### M752 — Charm Crafting (Key Crafting)
- **ID:** `M752` | **Themed Name:** Charm Crafting | **Generic:** Key Crafting | **Intro:** L7631 | **Cat:** K/D | **Hammerable:** No
- **Rule:** બે સ્વતંત્ર દોરાઓ અડધી-અડધી કી (Half-Charm Left અને Half-Charm Right) ધરાવે છે. જ્યારે આ બંને દોરા સફળતાપૂર્વક અનરૅવલ થઈને બોર્ડ બહાર નીકળે છે, ત્યારે સ્ક્રીન પર બંને અર્ધભાગો જોડાઈને સોનેરી ગ્રાન્ડ કી બને છે અને નિયુક્ત ગ્રાન્ડ ક્લેસ્પ કાયમી ખુલે છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m752_1","type":"M752","cells":[[6,2],[9,8]],"params":{"pairId":"craft_pair_1","requiredThreadIds":["t_14","t_22"]},"hammerable":false}`

---

### M753 — Skeleton Charm (Skeleton Key)
- **ID:** `M753` | **Themed Name:** Skeleton Charm | **Generic:** Skeleton Key | **Intro:** L7751 | **Cat:** K | **Hammerable:** Yes (1 charm/snip)
- **Rule:** બોર્ડ પર સ્કેલેટન કી ચિહ્ન ધરાવતો માસ્ટર દોરો. સામાન્ય કી માત્ર મેચિંગ કલર ખોલે છે, જ્યારે આ સ્કેલેટન ચાર્મ દોરો કોઈપણ રંગના પ્રથમ ક્લેસ્પ પરથી પસાર થતાં જ તેને તાત્કાલિક કાયમી અનલૉક કરી નાખે છે. હેમરેબલ છે.
- **JSON Format:** `{"id":"m753_1","type":"M753","cells":[[5,6],[5,7],[5,8]],"params":{"universal":true},"hammerable":true}`

---

### M754 — Charm Swap Hoop (Key Swap)
- **ID:** `M754` | **Themed Name:** Charm Swap Hoop | **Generic:** Key Swap | **Intro:** L7871 | **Cat:** D | **Hammerable:** No
- **Rule:** બોર્ડ પર સ્થાપિત નાનું ક્રાફ્ટ સ્વેપ સર્કલ. પ્લેયર આ હૂપ પર ટેપ કરે છે (1 Move વપરાય છે), ત્યારે તેની સાથે લિંક થયેલા બે દોરાઓ વચ્ચે કી-રંગોની આપલે થાય છે (દા.ત. લાલ કી વાળો દોરો વાદળી કી ધારણ કરે છે અને વાદળી વાળો લાલ કી ધારણ કરે છે). હેમરેબલ નથી.
- **JSON Format:** `{"id":"m754_1","type":"M754","cells":[[7,7]],"params":{"linkedThreadA":"t_03","linkedThreadB":"t_09"},"hammerable":false}`

