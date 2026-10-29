# 03 — Signature System & Base Mechanics: Phase 18
> Remix A (Phases 1 to 6 Synergy) signature system અને Phase 18 ના 4 ડેટા-ડ્રિવન combo mechanics (M851–M854) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 18 index](./README.md) · [01 Scope & Rules](./01_PHASE_18_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7, §10.3](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Remix A
- **Concept:** અગાઉના સફળ તબક્કાઓ (P1 Launch, P3 Cycles, P4 Multi-floor, P5 Push Physics+, P6 Light & Beams) ના મિકેનિક્સ વચ્ચે નવી રસપ્રદ ક્રિયા-પ્રતિક્રિયાઓ.
- **Data Selection Rule:** ઉમેદવાર પૂલમાંથી પ્લેયર એંગેજમેન્ટ અને સોલ્વર એફિશિયન્સી આધારે પસંદગી.
- **Invariants:** 0-hearts solvability દરેક લેવલ પર ચકાસાયેલ છે.

---

## 2. Combo Mechanics Catalog Cards (Candidate Pool)

### M851 — Cycle Crate
- **ID:** `M851` | **Themed Name:** Cycle Crate | **Generic:** Cycle Crate | **Intro:** L8511 | **Cat:** C/D | **Hammerable:** Yes (1 crate/snip)
- **Rule:** ડે/નાઈટ લૂમ (Phase 3) સાથે જોડાયેલો લાકડાનો ક્રેટ (Phase 5). સ્ટેટ A (Day) માં તે સામાન્ય ક્રેટ તરીકે મુક્તપણે ધકેલી શકાય છે, પરંતુ સ્ટેટ B (Night) માં તે લૂમ લૅચ સાથે લોક થઈને અચલ સિંગલ બ્લોકર બની જાય છે. હેમરેબલ છે.
- **JSON Format:** `{"id":"m851_1","type":"M851","cells":[[4,4]],"params":{"activeCycle":"A"},"hammerable":true}`

---

### M852 — Floor Beam
- **ID:** `M852` | **Themed Name:** Floor Beam | **Generic:** Floor Beam | **Intro:** L8631 | **Cat:** O/D | **Hammerable:** No
- **Rule:** ઑપ્ટિકલ લાઇટ બીમ (Phase 6) જે પારદર્શક ઓર્ગેન્ઝા ફ્લોર (Phase 4) માંથી સીધું નીચેના માળે (Floor 1 $\to$ Floor 2) પ્રવેશે છે અને નીચલા માળે રહેલા સન-કેચર્સને પ્રકાશિત કરે છે. ઉપલા માળેથી દોરો બીમને બ્લોક કરે તો નીચેનો સન-કેચર ઓલવાઈ જાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m852_1","type":"M852","cells":[[6,6]],"params":{"sourceFloor":1,"targetFloor":2},"hammerable":false}`

---

### M853 — Fogged Stair
- **ID:** `M853` | **Themed Name:** Fogged Stair | **Generic:** Fogged Stair | **Intro:** L8751 | **Cat:** T/B | **Hammerable:** No
- **Rule:** મલ્ટિ-ફ્લોર સીડી (M151) જે જાડા વૂલ ફ્લફ નીચે છુપાયેલી હોય છે. ખેલાડીને ઉપરથી સીડી દેખાતી નથી; જ્યારે કોઈ દોરો તે સેલ પરથી પસાર થાય છે ત્યારે ફ્લફ વિખેરાઈ જાય છે અને સીડી કાયમી ધોરણે પ્રગટ થાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m853_1","type":"M853","cells":[[3,8]],"params":{"linkedFloor":2,"revealed":false},"hammerable":false}`

---

### M854 — Satin Charm Crate
- **ID:** `M854` | **Themed Name:** Satin Charm Crate | **Generic:** Satin Charm Crate | **Intro:** L8871 | **Cat:** C/K | **Hammerable:** Yes
- **Rule:** રેશમી સાટિન ફેબ્રિકથી મઢેલો સ્લાઇડિંગ ક્રેટ (M202) જે પોતાની અંદર કિંમતી કી (Charm) ધરાવે છે. જ્યારે આ ક્રેટને બોર્ડ પર સ્લાઇડ કરીને તેના લક્ષિત ક્લેસ્પ પર ધકેલવામાં આવે છે, ત્યારે તે ક્લેસ્પને કાયમી ખોલી નાખે છે અને ક્રેટ ફેબ્રિકમાં ઓગળી જાય છે. હેમરેબલ છે.
- **JSON Format:** `{"id":"m854_1","type":"M854","cells":[[8,3]],"params":{"targetClaspId":"clasp_satin_1"},"hammerable":true}`
