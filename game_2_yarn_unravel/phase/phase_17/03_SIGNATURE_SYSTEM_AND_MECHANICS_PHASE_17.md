# 03 — Signature System & Base Mechanics: Phase 17
> Guardians (Pincushion Court) signature system અને Phase 17 ના 4 નવા base mechanics (M801–M804) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 17 index](./README.md) · [01 Scope & Rules](./01_PHASE_17_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Guardians (Pincushion Court)
- **Concept:** ક્રાફ્ટ રજવાડાના દરબાર (Pincushion Court) ના રક્ષકો તરીકે મોટા મલ્ટિ-સેલ મખમલી પિનકુશન્સ. આ ગાર્ડિયન્સ મોટા અવરોધો તરીકે ઊભા રહે છે અને તેમની આસપાસથી દોરાઓ બહાર કાઢીને તેમની સોય-પિન ખેંચીને તેમને શાંત કરવા પડે છે.
- **Rules & Constraints:**
  - પિનકુશનના સેલ્સ સોલિડ બ્લોકર તરીકે વર્તે છે; તેમના પર દોરો સીધો પસાર થઈ શકતો નથી.
  - પિનકુશનની નજીકથી પસાર થતાં દરેક દોરા દીઠ 1 પિન ખેંચાય છે (-1 HP).
  - HP 0 થતાં ગાર્ડિયન ડિસપિયર થઈને ખાલી ફ્લોર બની જાય છે.
  - તમામ ગાર્ડિયન લેવલ્સ 0-hearts solvable છે.

---

## 2. Base Mechanics Catalog Cards

### M801 — Twin Pincushions (Twin Guardian)
- **ID:** `M801` | **Themed Name:** Twin Pincushions | **Generic:** Twin Guardian | **Intro:** L8011 | **Cat:** X/B | **Hammerable:** No
- **Rule:** બોર્ડ પર બે 2×2 મખમલ પિનકુશન્સ જે એક સામાન્ય HP પૂલ (દા.ત. 6 HP) શેર કરે છે. ખેલાડી ગમે તે પિનકુશનની નજીકથી દોરો પસાર કરે, સંયુક્ત HP ઘટે છે. જ્યારે HP 0 થાય છે ત્યારે બંને પિનકુશન્સ એકસાથે ઓગળીને ક્લિયર ફ્લોરમાં ફેરવાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m801_1","type":"M801","cells":[[2,2],[2,3],[3,2],[3,3]],"params":{"sharedHp":6,"twinId":"m801_2"},"hammerable":false}`

---

### M802 — Armoured Pincushion (Shield Guardian)
- **ID:** `M802` | **Themed Name:** Armoured Pincushion | **Generic:** Shield Guardian | **Intro:** L8131 | **Cat:** X/B | **Hammerable:** No
- **Rule:** પિત્તળની મજબૂત કેપ ધરાવતું 2×2 પિનકુશન. જ્યાં સુધી તેની સાથે લિંક થયેલું લીવર "Shielded" મોડમાં હોય છે, ત્યાં સુધી તેની નજીકથી દોરો નીકળવા છતાં તેનું HP ઘટતું નથી. ખેલાડીએ પહેલાં લીવરને ટેપ કરીને શિલ્ડ ડાઉન કરવું પડે છે, પછી જ ડેમેજ આપી શકાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m802_1","type":"M802","cells":[[5,8],[5,9],[6,8],[6,9]],"params":{"hp":5,"linkedLeverId":"lever_armour_1"},"hammerable":false}`

---

### M803 — Seeding Pincushion (Spawner Guardian)
- **ID:** `M803` | **Themed Name:** Seeding Pincushion | **Generic:** Spawner Guardian | **Intro:** L8251 | **Cat:** X/B | **Hammerable:** No
- **Rule:** નાનું 2×2 પિનકુશન જે સતત નવી સોય/બટન્સ બનાવે છે. દર N (4) પ્લેયર મૂવ્સ પછી, તે પોતાની આસપાસના પ્રથમ ઉપલબ્ધ ખાલી સેલમાં ($U \to R \to D \to L$) લાકડાનું બટન (M001) સ્પૉન કરે છે. જ્યારે તેનું HP 0 થાય ત્યારે સ્પૉનિંગ કાયમી બંધ થાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m803_1","type":"M803","cells":[[7,2],[7,3],[8,2],[8,3]],"params":{"hp":4,"spawnInterval":4},"hammerable":false}`

---

### M804 — Heart Pincushion (Guardian Core)
- **ID:** `M804` | **Themed Name:** Heart Pincushion | **Generic:** Guardian Core | **Intro:** L8371 | **Cat:** X/B | **Hammerable:** No
- **Rule:** 3×3 ગાર્ડિયન જેની મધ્યમાં કિંમતી હાર્ટ કોર સેલ છે. આ ગાર્ડિયનનું HP માત્ર ત્યારે જ ઘટે છે જ્યારે બોર્ડ પરનો લાઇટ બીમ (Phase 6 Lamplight Atelier) તેના હાર્ટ સેલ પર કેન્દ્રિત થયેલો હોય અને તે જ મૂવમાં દોરો તેની સરહદ પરથી બહાર નીકળે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m804_1","type":"M804","cells":[[4,4],[4,5],[4,6],[5,4],[5,5],[5,6],[6,4],[6,5],[6,6]],"params":{"coreCell":[5,5],"hp":8},"hammerable":false}`

