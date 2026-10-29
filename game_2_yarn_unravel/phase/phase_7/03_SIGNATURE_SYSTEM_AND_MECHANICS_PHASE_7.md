# 03 — Signature System & Base Mechanics: Phase 7
> Rotation (Turning Table) signature system અને Phase 7 ના 4 નવા base mechanics (M301–M304) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 7 index](./README.md) · [01 Scope & Rules](./01_PHASE_7_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Rotation (Turning Table)
- **Concept:** લાકડાના ક્રાફ્ટ બોર્ડ પર ગોળાકાર એમ્બ્રોઇડરી હૂપ્સ છે જે ખેલાડીના ટેપથી અથવા દરેક Move ના અંતે 90° ક્લોકવાઇઝ ફરે છે.
- **Rotation Math:** સેન્ટર `(cx, cy)` ની આસપાસ કોઈપણ સેલ `(x, y)` નું 90° CW રોટેશન:
  $x' = cx - (y - cy)$, $y' = cy + (x - cx)$.
- **Direction Transform:** દોરાની સોયની દિશા $U \to R \to D \to L \to U$ થાય છે.
- **Tangled Thread Invariant:** જો રોટેશન બાદ સોય પોતાના શરીર તરફ પોઇન્ટ કરે, તો દોરો ટેન્ગલ્ડ બને છે (ટેપ લૉક રહે છે જ્યાં સુધી ફરી દિશા ન બદલાય).

---

## 2. Base Mechanics Catalog Cards

### M301 — Hoop Rotor (Sub-board Rotor)
- **ID:** `M301` | **Themed Name:** Hoop Rotor | **Generic:** Sub-board Rotor | **Intro:** L3011 | **Cat:** T | **Hammerable:** No
- **Rule:** બોર્ડ પરનો 4×4 ગોળાકાર એમ્બ્રોઇડરી હૂપ. રોટરના સેન્ટર પર ટેપ કરવાથી તે 4×4 ગ્રીડ 90° CW ફરે છે (ખર્ચ: 1 Move). જે દોરાઓ સંપૂર્ણપણે આ 4×4 ની અંદર છે તે જ તેની સાથે ફરે છે. જે દોરો અર્ધ-અંદર હોય તે રોટરને લૉક કરે છે (ટેપ નકારી કાઢે છે, 0 Move).
- **JSON Format:** `{"id":"m301_1","type":"M301","cells":[[4,4],[4,7],[7,4],[7,7]],"params":{"size":4},"hammerable":false}`

---

### M302 — Turning Hem (Rotating Edges)
- **ID:** `M302` | **Themed Name:** Turning Hem | **Generic:** Rotating Edges | **Intro:** L3131 | **Cat:** B/C | **Hammerable:** No
- **Rule:** બોર્ડની ફરતે રહેલો હેમ (ફોલ્ડ કરેલી કિનારી). તેમાં રહેલી ઓપન ગેપ્સ (જ્યાંથી દોરા બહાર નીકળી શકે છે) દરેક Move ના અંતે બોર્ડની કિનારી પર 1 સેગમેન્ટ ક્લોકવાઇઝ આગળ વધે છે. બંધ હેમ સાથે અથડાતો દોરો સ્નેગ થાય છે (-1 Heart).
- **JSON Format:** `{"id":"m302_1","type":"M302","cells":[[0,5],[0,6]],"params":{"gapSize":2,"step":1},"hammerable":false}`

---

### M303 — Twirl Thread (Spin Path)
- **ID:** `M303` | **Themed Name:** Twirl Thread | **Generic:** Spin Path | **Intro:** L3251 | **Cat:** P | **Hammerable:** Yes
- **Rule:** વિશિષ્ટ વૂલ દોરો જેનું હેડ (સોય) સ્થિર નથી રહેતું. દરેક માન્ય Move પછી તેની સોય 90° ક્લોકવાઇઝ ફરી જાય છે ($U \to R \to D \to L$). ખેલાડીએ તેની યોગ્ય એક્ઝિટ દિશા આવે ત્યારે જ ટેપ કરવો પડે છે. અન્યથા સ્નેગ થાય છે. હેમરેબલ છે.
- **JSON Format:** `{"id":"m303_1","type":"M303","cells":[[5,5],[5,6],[5,7]],"params":{"spinInterval":1},"hammerable":true}`

---

### M304 — Ratchet Pin (Rotation Lock)
- **ID:** `M304` | **Themed Name:** Ratchet Pin | **Generic:** Rotation Lock | **Intro:** L3371 | **Cat:** K | **Hammerable:** No
- **Rule:** ક્રાફ્ટ બોર્ડ પર રોપાયેલી બ્રાસ સેફ્ટી પિન. જ્યાં સુધી આ પિન સાથે જોડાયેલો કી-દોરો અનરૅવલ ન થાય, ત્યાં સુધી તે સંલગ્ન રોટર્સ (M301) ને ફરવા દેતી નથી (રોટર ટેપ લૉક રહે છે). કી-દોરો નીકળતાં જ પિન ખુલી જાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m304_1","type":"M304","cells":[[4,4]],"params":{"targetRotorId":"m301_1","keyThreadId":"p12"},"hammerable":false}`

