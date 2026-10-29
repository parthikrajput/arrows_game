# 03 — Signature System & Base Mechanics: Phase 10
> Sequencing (Pattern Book) signature system અને Phase 10 ના 4 નવા base mechanics (M451–M454) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 10 index](./README.md) · [01 Scope & Rules](./01_PHASE_10_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Sequencing (Pattern Book)
- **Concept:** વણાટકામમાં ડિઝાઇન બુક (Pattern Book) મુજબ ચોક્કસ ક્રમમાં ટાંકા લેવા પડે છે. Phase 10 માં દોરાઓના બહાર નીકળવાનો ક્રમ, સમયબદ્ધ મેટ્રોનોમ રિધમ અને સિક્વન્સ ક્લેસ્પ્સ રમતને વ્યૂહાત્મક ક્રમબદ્ધતા આપે છે.
- **Rules & Constraints:**
  - ખોટા ક્રમમાં દોરો ખેંચતાં સ્નેગ અથવા લૉક્ડ ટેપ રિસ્પોન્સ મળે છે.
  - તમામ સિક્વન્સ પઝલ્સ પ્લેયર માટે UI પર સ્પષ્ટ ક્રમ નિર્દેશક (Indicators) દ્વારા દર્શાવાય છે.
  - 0-hearts solvability દરેક લેવલ પર સુનિશ્ચિત છે.

---

## 2. Base Mechanics Catalog Cards

### M451 — Metronome Gate (Rhythm Gate)
- **ID:** `M451` | **Themed Name:** Metronome Gate | **Generic:** Rhythm Gate | **Intro:** L4511 | **Cat:** B | **Hammerable:** No
- **Rule:** લાકડાની મેટ્રોનોમ સોય ધરાવતો ગેટ. પ્લેયરના દરેક માન્ય મૂવ પર તેની સ્થિતિ બદલાય છે. પૂર્વનિર્ધારિત રિધમિક પેટર્ન (દા.ત. Open $\to$ Closed $\to$ Closed) મુજબ ચોક્કસ મૂવ્સ પર જ ખુલ્લો રહે છે. બંધ હોય ત્યારે સિંગલ બ્લોકર તરીકે વર્તે છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m451_1","type":"M451","cells":[[6,7]],"params":{"pattern":["O","C","C"],"offset":0},"hammerable":false}`

---

### M452 — Pattern Clasp (Pattern Lock)
- **ID:** `M452` | **Themed Name:** Pattern Clasp | **Generic:** Pattern Lock | **Intro:** L4631 | **Cat:** K/B | **Hammerable:** No
- **Rule:** બોર્ડ પર સ્ટીચ ક્લેસ્પ જે 2 થી 4 રંગોની ક્રમિક પેટર્ન દર્શાવે છે (દા.ત. Red $\to$ Yellow $\to$ Blue). જ્યારે આ નિર્ધારિત રંગ ક્રમમાં જ દોરાઓ સફળતાપૂર્વક અનરૅવલ થઈને બોર્ડ બહાર નીકળે છે, ત્યારે જ આ ક્લેસ્પ કાયમી ધોરણે ઓપન થાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m452_1","type":"M452","cells":[[3,9]],"params":{"colorSequence":["red","yellow","blue"]},"hammerable":false}`

---

### M453 — Ordered Hem (Order Edge)
- **ID:** `M453` | **Themed Name:** Ordered Hem | **Generic:** Order Edge | **Intro:** L4751 | **Cat:** B/E | **Hammerable:** No
- **Rule:** ક્રાફ્ટ બોર્ડની કિનારી પર આવેલી વિશિષ્ટ સીમ (Hem). આ સીમ માત્ર ચડતા ક્રમના ટેગ નંબરવાળા દોરાઓને જ બહાર નીકળવા દે છે ($1 \to 2 \to 3$). જો કોઈ દોરો આ ક્રમનું ઉલ્લંઘન કરીને હેમમાંથી નીકળવાનો પ્રયત્ન કરે, તો સ્નેગ થાય છે (-1 Heart) અને સોય પાછી વળે છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m453_1","type":"M453","cells":[[0,5],[0,6],[0,7]],"params":{"expectedSequence":[1,2,3]},"hammerable":false}`

---

### M454 — Echo Card (Echo Sequence)
- **ID:** `M454` | **Themed Name:** Echo Card | **Generic:** Echo Sequence | **Intro:** L4871 | **Cat:** K | **Hammerable:** No
- **Rule:** સ્ક્રીન પર દેખાતું નાનું પેટર્ન કાર્ડ. ખેલાડી દ્વારા અનરૅવલ કરવામાં આવતા પ્રથમ $k$ (2–3) દોરાઓના રંગોનો ક્રમ આ કાર્ડમાં રેકોર્ડ થાય છે. ત્યારબાદના $k$ દોરાઓ આ જ રંગ ક્રમમાં બહાર નીકળવા ફરજિયાત છે. જો ખોટા રંગનો દોરો ટેપ કરવામાં આવે, તો તે દોરો વાઇબ્રેટ થઈને લૉક રહે છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m454_1","type":"M454","cells":[[1,1]],"params":{"windowSize":3},"hammerable":false}`

