# 03 — Signature System & Base Mechanics: Phase 5
> Push Physics+ (Crate Workshop) signature system અને Phase 5 ના 4 નવા base mechanics (M201–M204) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 5 index](./README.md) · [01 Scope & Rules](./01_PHASE_5_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Push Physics+ (Crate Workshop)
- **Concept:** લાકડાની સીવણ સામાનની નાની ક્રેઇટ્સ (Notions Crates) ક્રાફ્ટ બોર્ડ પર ગોઠવાયેલી છે.
- **Push Interaction:**
  - જ્યારે કોઈ દોરો બહાર નીકળવાનો પ્રયાસ કરે છે અને તેનો માર્ગ ક્રેઇટ સાથે ભટકાય છે:
    - જો ક્રેઇટ પાછળનો સેલ ખાલી હોય, તો ક્રેઇટ તે દિશામાં **1 સેલ આગળ ખસે છે** (સ્લાઇડ સાઉન્ડ + ડસ્ટ પફ).
    - દોરો સફળતાપૂર્વક અનરૅવલ થઈને બોર્ડ બહાર નીકળે છે.
    - જો ક્રેઇટ પાછળ દીવાલ કે અન્ય અવરોધ હોય, તો ક્રેઇટ અડચણ બને છે અને દોરો સ્નેગ થાય છે (-1 Heart).
- **Golden Scissors:** સામાન્ય ક્રેઇટ હેમરેબલ છે (`hammerable: true`). સ્નિપ કરવાથી ક્રેઇટ તૂટી જાય છે અને સેલ ખાલી થાય છે.

---

## 2. Base Mechanics Catalog Cards

### M201 — Crate Pit (Crate Holes)
- **ID:** `M201` | **Themed Name:** Crate Pit | **Generic:** Crate Holes | **Intro:** L2011 | **Cat:** B/G | **Hammerable:** No (pit); Crate: Yes
- **Rule:** બોર્ડના લિનન કાપડ પર એક ખાડો (પિટ) છે જે શરૂઆતમાં સિંગલ બ્લોકર તરીકે વર્તે છે. જ્યારે કોઈ ક્રેઇટને ધકેલીને આ ખાડામાં ફેંકવામાં આવે છે, ત્યારે ક્રેઇટ ખાડાને ભરી દે છે. ખાડો અને ક્રેઇટ બંને અદૃશ્ય થઈને તે સેલ સામાન્ય સપાટ ફ્લોર બની જાય છે જેના પરથી દોરા મુક્તપણે પસાર થઈ શકે છે.
- **JSON Format:** `{"id":"m201_1","type":"M201","cells":[[4,7]],"params":{"filled":false},"hammerable":false}`

---

### M202 — Satin Crate (Sliding Ice Crates)
- **ID:** `M202` | **Themed Name:** Satin Crate | **Generic:** Sliding Ice Crates | **Intro:** L2131 | **Cat:** B/G | **Hammerable:** Yes
- **Rule:** ચળકતા લિસ્સા સાટિન કાપડથી ઢંકાયેલી ક્રેઇટ. જ્યારે દોરો તેને ધકેલે છે, ત્યારે તે માત્ર 1 સેલ નહીં પરંતુ માર્ગમાં કોઈ બ્લોકર, અન્ય ક્રેઇટ કે બોર્ડની કિનારી ન આવે ત્યાં સુધી સતત **લપસીને આગળ વધે છે**.
- **JSON Format:** `{"id":"m202_1","type":"M202","cells":[[6,3]],"params":{"sliding":true},"hammerable":true}`

---

### M203 — Charm Crate (Crate Keys)
- **ID:** `M203` | **Themed Name:** Charm Crate | **Generic:** Crate Keys | **Intro:** L2251 | **Cat:** K | **Hammerable:** No
- **Rule:** ક્રેઇટની ઉપર મેટાલિક ચાર્મ (કી) જડેલી છે. જ્યારે આ ક્રેઇટને ધકેલીને તેના મેચિંગ કલરના ક્લેસ્પ (M004 Clasp Lock) ના સેલ પર લાવવામાં આવે છે, ત્યારે ક્લેસ્પ કાયમી ધોરણે અનલૉક થઈ જાય છે અને ક્રેઇટ કન્ઝ્યુમ થઈને દૂર થાય છે.
- **JSON Format:** `{"id":"m203_1","type":"M203","cells":[[2,8]],"params":{"charmColor":"gold","targetClaspId":"m004_2"},"hammerable":false}`

---

### M204 — Iron Crate (Heavy Crate)
- **ID:** `M204` | **Themed Name:** Iron Crate | **Generic:** Heavy Crate | **Intro:** L2371 | **Cat:** B | **Hammerable:** No
- **Rule:** વજનદાર કાસ્ટ આયર્નની બનેલી સીવણ ક્રેઇટ. સામાન્ય સ્ટાન્ડર્ડ દોરો તેને ધકેલી શકતો નથી (દોરો સ્નેગ થાય છે, -1 Heart). આ ક્રેઇટ માત્ર **Chunky Chenille (M024)** દોરા અથવા **Ribbon-Tied Pair (M011)** ના સંયુક્ત પુલ ફોર્સથી જ 1 સેલ આગળ ધકેલી શકાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m204_1","type":"M204","cells":[[8,8]],"params":{"weight":"heavy"},"hammerable":false}`

