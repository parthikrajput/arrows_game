# 03 — Signature System & Base Mechanics: Phase 9
> Split & Merge (Ply & Twist) signature system અને Phase 9 ના 4 નવા base mechanics (M401–M404) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 9 index](./README.md) · [01 Scope & Rules](./01_PHASE_9_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Split & Merge (Ply & Twist)
- **Concept:** ઊનના દોરાઓ સામાન્ય રીતે બહુવિધ પ્લાય (plies) ના બનેલા હોય છે. પ્લેયર બોર્ડ પરના મિકેનિક્સ દ્વારા દોરાને બે સિંગલ-પ્લાય થ્રેડમાં વિભાજીત કરી શકે છે અથવા બે જુદા જુદા દોરાઓને એક મજબૂત દોરામાં ટ્વિસ્ટ કરી શકે છે.
- **Topological Invariants:**
  - સ્પ્લિટ થયેલા દોરાઓ મૂળ દોરાની અડધી જાડાઈ (thickness) દર્શાવે છે.
  - મર્જ થયેલા દોરાઓ સંયુક્ત લંબાઈ અને નવી હેડ-સોય મેળવે છે.
  - તમામ સ્પ્લિટ દોરાઓ 0-hearts solvable પાથ ધરાવે છે.

---

## 2. Base Mechanics Catalog Cards

### M401 — Twisting Pad (Merger Pad)
- **ID:** `M401` | **Themed Name:** Twisting Pad | **Generic:** Merger Pad | **Intro:** L4011 | **Cat:** D/G | **Hammerable:** No
- **Rule:** બોર્ડ પર 2 સંલગ્ન સેલ્સનું વૂલ પેડ. જ્યારે બે દોરાઓના નીડલ હેડ્સ આ બે સેલ્સ પર સ્થિત હોય, ત્યારે પ્લેયર પેડ પર ટેપ કરીને (1 Move વપરાય છે) બંને દોરાઓને એક સંયુક્ત દોરામાં જોડી (Merge) શકે છે. નવો દોરો ફ્રન્ટ નીડલ અને બેક ટેલ ધરાવે છે.
- **JSON Format:** `{"id":"m401_1","type":"M401","cells":[[4,5],[4,6]],"params":{"orientation":"horizontal"},"hammerable":false}`

---

### M402 — Double Split (Twin Splitter)
- **ID:** `M402` | **Themed Name:** Double Split | **Generic:** Twin Splitter | **Intro:** L4131 | **Cat:** P/T | **Hammerable:** No
- **Rule:** બોર્ડ સેલ પર ડબલ-નીડલ ગાઇડ. જ્યારે કોઈ દોરાની પુલ લાઇન આ સ્પ્લિટરમાં પ્રવેશે છે, ત્યારે તે દોરો બે સ્વતંત્ર હાફ-પ્લાય દોરાઓમાં વહેંચાય છે. M029 થી વિપરીત, આ બંને દોરા મૂળ દોરાની દિશા (`dir`) જ જાળવી રાખે છે અને સમાંતર બે ટ્રેક પર આગળ વધે છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m402_1","type":"M402","cells":[[7,8]],"params":{"axis":"forward"},"hammerable":false}`

---

### M403 — Stitch Lock (Segment Lock)
- **ID:** `M403` | **Themed Name:** Stitch Lock | **Generic:** Segment Lock | **Intro:** L4251 | **Cat:** K/L | **Hammerable:** Yes (1 lock/snip)
- **Rule:** ચેઇન-સ્ટીચ (M011/M027) દોરાના ચોક્કસ સેગમેન્ટ $k$ પર જડાયેલો સ્ટીલ લૉક. જ્યાં સુધી આ લૉકની નિયુક્ત કી-થ્રેડ બોર્ડમાંથી અનરૅવલ થઈને બહાર ન નીકળે ત્યાં સુધી આ સેગમેન્ટ અને તેની સાથે જોડાયેલ દોરો મૂવ થઈ શકતો નથી (ટેપ કરવાથી સ્નેગ નહીં પરંતુ લૉક્ડ ટેપ રિસ્પોન્સ મળે છે). હેમરેબલ છે.
- **JSON Format:** `{"id":"m403_1","type":"M403","cells":[[5,3]],"params":{"keyThreadId":"t_12","segmentIndex":2},"hammerable":true}`

---

### M404 — Rejoin Gate (Rejoin Gate)
- **ID:** `M404` | **Themed Name:** Rejoin Gate | **Generic:** Rejoin Gate | **Intro:** L4371 | **Cat:** B | **Hammerable:** No
- **Rule:** એક વિશિષ્ટ ક્રાફ્ટ બકલ ગેટ. શરૂઆતમાં સિંગલ બ્લોકર છે. જ્યારે અગાઉ સ્પ્લિટ થયેલા ચોક્કસ દોરાના બંને અર્ધભાગ (both plys) સફળતાપૂર્વક આ ગેટમાંથી પસાર થઈ જાય છે, ત્યારે જ આ ગેટ કાયમી ઓપન થાય છે. અન્ય દોરાઓ આ ગેટને સીધો પાર કરી શકતા નથી. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m404_1","type":"M404","cells":[[8,4]],"params":{"requiredParentThreadId":"t_05"},"hammerable":false}`

