# 03 — Signature System & Base Mechanics: Phase 15
> Conveyors & Tracks (Feed Dog Factory) signature system અને Phase 15 ના 4 નવા base mechanics (M701–M704) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 15 index](./README.md) · [01 Scope & Rules](./01_PHASE_15_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Conveyors & Tracks (Feed Dog Factory)
- **Concept:** સિલાઈ મશીનમાં ફેબ્રિકને આગળ ખસેડવા માટે નીચે ફીડ ડોગ્સ (ધાતુના દાંતા) કામ કરે છે. Phase 15 માં બોર્ડ પર આવા કન્વેયર બેલ્ટ્સ અને ટ્રેક્સ છે જે દોરાઓને દરેક મૂવ પછી 1 સેલ આગળ ધકેલે છે, જેનાથી બોર્ડ પર ગતિશીલ પરિભ્રમણ સર્જાય છે.
- **Rules & Kinetics:**
  - બેલ્ટ પર રહેલા દોરાઓ તેની દિશામાં આગળ વધે છે જો આગળનો સેલ ખાલી હોય.
  - જો દોરાનો આગળનો સેલ બ્લોક હોય તો તે બેલ્ટ પર જ અટકે છે (કોઈ સ્નેગ પેનલ્ટી નથી; માત્ર મૂવમેન્ટ બ્લોક થાય છે).
  - તમામ ટ્રેક પઝલ્સ 0-hearts solvable છે.

---

## 2. Base Mechanics Catalog Cards

### M701 — Belt Switch (Belt Junction)
- **ID:** `M701` | **Themed Name:** Belt Switch | **Generic:** Belt Junction | **Intro:** L7011 | **Cat:** D/G | **Hammerable:** No
- **Rule:** કન્વેયર બેલ્ટ જંકશન પર આવેલો નાનો ક્રાફ્ટ સ્વિચ. પ્લેયર આ સ્વિચ પર ટેપ કરે છે (1 Move વપરાય છે), ત્યારે જંકશન કઈ શાખા તરફ દોરાઓને વાળશે (દા.ત. Straight થી 90° Turn) તે દિશા બદલાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m701_1","type":"M701","cells":[[5,5]],"params":{"branches":["straight","right"],"activeBranch":"straight"},"hammerable":false}`

---

### M702 — Reversing Belt (Reversible Belt)
- **ID:** `M702` | **Themed Name:** Reversing Belt | **Generic:** Reversible Belt | **Intro:** L7131 | **Cat:** T/E | **Hammerable:** No
- **Rule:** કન્વેયર બેલ્ટ સેગમેન્ટ જેની આગળ-પાછળની ગતિનું કાઉન્ટર હોય છે. દર N (3–5) પ્લેયર મૂવ્સ પછી, આ બેલ્ટની ગતિની દિશા આપોઆપ 180° ઊંધી થઈ જાય છે (Forward $\leftrightarrow$ Reverse). બેલ્ટ પર નાનો કાઉન્ટડાઉન બેજ દેખાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m702_1","type":"M702","cells":[[4,2],[4,3],[4,4],[4,5]],"params":{"flipInterval":4,"currentDir":"right"},"hammerable":false}`

---

### M703 — Belt Lever (Belt Lever)
- **ID:** `M703` | **Themed Name:** Belt Lever | **Generic:** Belt Lever | **Intro:** L7251 | **Cat:** D/G | **Hammerable:** No
- **Rule:** બોર્ડની કિનારી પર જડેલું વૂડન ક્લચ લીવર. પ્લેયર લીવર પર ટેપ કરીને (1 Move વપરાય છે) તેની સાથે જોડાયેલા તમામ કન્વેયર બેલ્ટ્સને ચાલુ (Active) અથવા બંધ (Halted) કરી શકે છે. જ્યારે બેલ્ટ બંધ હોય ત્યારે તેના પરના દોરાઓ સામાન્ય સ્થિર દોરાઓની જેમ રહે છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m703_1","type":"M703","cells":[[0,8]],"params":{"linkedBeltIds":["belt_1","belt_2"],"active":true},"hammerable":false}`

---

### M704 — Track Loop (Track Loop)
- **ID:** `M704` | **Themed Name:** Track Loop | **Generic:** Track Loop | **Intro:** L7371 | **Cat:** P/T | **Hammerable:** No
- **Rule:** બોર્ડ પર બંધ લંબચોરસ પરિપથ (Closed Loop Track, દા.ત. 4×4 સેલ્સ). આ ટ્રેક પર બેઠેલો દોરો દરેક મૂવ પછી 1 સેલ આગળ પરિભ્રમણ કરે છે. આ દોરો માત્ર ત્યારે જ સફળતાપૂર્વક અનરૅવલ થઈ શકે છે જ્યારે તેની સોય ટ્રેકના વિશિષ્ટ એક્ઝિટ સેલ પર આવે અને તેનો બહાર નીકળવાનો રસ્તો ક્લિયર હોય. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m704_1","type":"M704","cells":[[6,8],[6,9],[7,9],[8,9],[8,8],[7,8]],"params":{"exitCell":[6,8],"dir":"up"},"hammerable":false}`

