# 03 — Signature System & Base Mechanics: Phase 8
> Growth (Garden Knitting) signature system અને Phase 8 ના 4 નવા base mechanics (M351–M354) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 8 index](./README.md) · [01 Scope & Rules](./01_PHASE_8_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Growth (Garden Knitting)
- **Concept:** લાકડાના ક્રાફ્ટ બોર્ડ પર ગૂંથેલા લીલા ઊનના વેલાઓ (Ivy Yarn) છે, જે દરેક Move પછી સજીવ રીતે ખાલી સેલ્સમાં ફેલાય છે.
- **Expansion Logic:**
  - દર $N$ મૂવ્સ પછી, સૌથી જૂના ગ્રોથ સેલમાંથી ઘડિયાળના કાંટા મુજબ ($U \to R \to D \to L$) 2 ખાલી પડોશી સેલ્સમાં નવો આઇવી ગ્રોથ પ્રવેશે છે.
  - જો દોરાનું શરીર સેલ પર ઊભું હોય તો ગ્રોથ તે સેલમાં પ્રવેશી શકતો નથી (બ્લોક થાય છે).
  - આઇવી સેલ સિંગલ બ્લોકર તરીકે વર્તે છે; તેમાં દોરો ખેંચતાં સ્નેગ થાય છે (-1 Heart).
  - ગોલ્ડન સિઝર્સ (Hammer) વડે પ્રત્યેક આઇવી સેલ સ્નિપ કરી શકાય છે.

---

## 2. Base Mechanics Catalog Cards

### M351 — Ivy Yarn (Vine Spread+)
- **ID:** `M351` | **Themed Name:** Ivy Yarn | **Generic:** Vine Spread+ | **Intro:** L3511 | **Cat:** C | **Hammerable:** Yes (1 cell/snip)
- **Rule:** ગ્રીન વૂલ સ્પ્રાઉટ રૂટ. દર N (3–5) Moves ના અંતે 2 નવા ખાલી સેલ્સમાં શાખાઓ વિસ્તારે છે. જો તમામ 4 દિશાઓ બ્લોક હોય તો આ રૂટ સ્પ્રાઉટ કરવાનું બંધ કરે છે. સ્નિપ કરવાથી લક્ષિત સેલનો ગ્રોથ દૂર થાય છે.
- **JSON Format:** `{"id":"m351_1","type":"M351","cells":[[6,6]],"params":{"spreadInterval":3,"spreadCount":2},"hammerable":true}`

---

### M352 — Snip Tile (Pruner Tile)
- **ID:** `M352` | **Themed Name:** Snip Tile | **Generic:** Pruner Tile | **Intro:** L3631 | **Cat:** D/G | **Hammerable:** No
- **Rule:** બોર્ડ સેલ પર નાની ક્રાફ્ટ સિઝર્સ (કાતર) નું પ્રતીક છે. જ્યારે કોઈપણ દોરાની પુલ લાઇન આ ટાઇલ પરથી પસાર થાય છે, ત્યારે આ ટાઇલની આસપાસના તમામ 8 પડોશી સેલ્સમાં રહેલો આઇવી યાર્ન ગ્રોથ તાત્કાલિક કપાઈને સાફ થઈ જાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m352_1","type":"M352","cells":[[5,8]],"params":{"pruneRadius":1},"hammerable":false}`

---

### M353 — Seed Bead Thread (Seed Path)
- **ID:** `M353` | **Themed Name:** Seed Bead Thread | **Generic:** Seed Path | **Intro:** L3751 | **Cat:** P | **Hammerable:** Yes
- **Rule:** પૂંછડી પર નાનું વૂડન સીડ બીડ ધરાવતો દોરો. જ્યારે આ દોરો સફળતાપૂર્વક અનરૅવલ થઈને બહાર નીકળે છે, ત્યારે તેની પૂંછડીના મૂળ સેલ પર સીડ બીડ રહી જાય છે. આ સીડ બીડ પર 3-મૂવ કાઉન્ટર શરૂ થાય છે. જો 3 Moves પૂરા થતાં સેલ ખાલી હોય, તો તે સેલ કાયમી **Wooden Button (M001)** બની જાય છે! જો કોઈ દોરો તે સેલ પરથી પસાર થઈને ઊભો રહે તો સીડ કચડાઈને નષ્ટ થાય છે. હેમરેબલ છે.
- **JSON Format:** `{"id":"m353_1","type":"M353","cells":[[3,3],[3,4],[3,5]],"params":{"seedDelay":3},"hammerable":true}`

---

### M354 — Blossom Gate (Bloom Gate)
- **ID:** `M354` | **Themed Name:** Blossom Gate | **Generic:** Bloom Gate | **Intro:** L3871 | **Cat:** B | **Hammerable:** No
- **Rule:** બંધ ફૂલ આકારનો ક્રાફ્ટ ગેટ જે શરૂઆતમાં સિંગલ બ્લોકર છે. આ ગેટ સાથે જોડાયેલા K (2–4) પડોશી આઇવી ગ્રોથ સેલ્સ જ્યારે સાફ થાય છે (સ્નિપ ટાઇલ કે સિઝર્સથી), ત્યારે આ ગેટ સુંદર ખીલેલા ફૂલ (Blossom) માં રૂપાંતરિત થઈને કાયમી ધોરણે ખુલી જાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m354_1","type":"M354","cells":[[7,9]],"params":{"requiredPrunes":3},"hammerable":false}`

