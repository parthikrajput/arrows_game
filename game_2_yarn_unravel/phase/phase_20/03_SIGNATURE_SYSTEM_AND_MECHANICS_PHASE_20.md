# 03 — Signature System & Base Mechanics: Phase 20
> Grand Master (The Endless Tapestry) signature system અને Phase 20 ના 4 Master mechanics (M951–M954) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 20 index](./README.md) · [01 Scope & Rules](./01_PHASE_20_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7, §9](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: The Endless Tapestry
- **Concept:** 1 થી 19 તબક્કાઓનો મહાસંગમ. સમગ્ર ગેમપ્લે મિકેનિક્સ એક વિશાળ અનંત ટેપેસ્ટ્રીમાં ગૂંથાય છે.
- **Invariants:** તમામ લેવલ્સ 0 hearts lost અને 0 boosters સાથે 100% સોલ્વેબલ છે.

---

## 2. Master Mechanics Catalog Cards

### M951 — Moving Guardian (Living Tapestry)
- **ID:** `M951` | **Themed Name:** Moving Guardian | **Generic:** Moving Guardian | **Intro:** L9511 | **Cat:** X/B | **Hammerable:** No
- **Rule:** બોર્ડ પર 2×2 કદનો વિશાળ જીવંત પિનકુશન ગાર્ડિયન (8 HP). સ્થિર રહેવાને બદલે દર 2 પ્લેયર મૂવ્સ પછી નિર્ધારિત પાથ પર 1 સેલ આગળ ખસે છે. ખેલાડીએ તેની ગતિવિધિનો અંદાજ લગાવીને દોરાઓ તેની નજીકથી ખેંચીને પિનો કાઢવી પડે છે. HP 0 થતાં કાયમી ઓગળી જાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m951_1","type":"M951","cells":[[4,4],[4,5],[5,4],[5,5]],"params":{"hp":8,"moveInterval":2,"patrolPath":[[4,4],[4,8],[8,8],[8,4]]},"hammerable":false}`

---

### M952 — Omni Gate (Chromatic Prism Gate)
- **ID:** `M952` | **Themed Name:** Omni Gate | **Generic:** Chromatic Prism Gate | **Intro:** L9631 | **Cat:** B | **Hammerable:** No
- **Rule:** સર્વવ્યાપી ક્રાફ્ટ ગેટ. આ ગેટ વિવિધ શરતો (સૂર્યપ્રકાશ બીમ, મેચિંગ કલર અને સાયકલ સ્ટેટ A) ત્રણેય એકસાથે સંતોષાય ત્યારે જ ખુલે છે. તે રમતમાં અંતિમ તાર્કિક અવરોધ તરીકે કામ કરે છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m952_1","type":"M952","cells":[[6,7]],"params":{"requiredBeam":true,"requiredColor":"red","requiredCycle":"A"},"hammerable":false}`

---

### M953 — Grand Loom Spool (Infinity Bobbin)
- **ID:** `M953` | **Themed Name:** Grand Loom Spool | **Generic:** Infinity Bobbin | **Intro:** L9751 | **Cat:** P/T | **Hammerable:** No
- **Rule:** સેન્ટ્રલ બોબિન ડિસ્પેન્સર. જ્યારે તેના પરથી એક દોરો સંપૂર્ણપણે બહાર નીકળી જાય છે, ત્યારે તે જ સ્પૂલમાંથી બીજો નવો દોરો આપોઆપ અનવાઇન્ડ થઈને બોર્ડ પર પ્રગટ થાય છે (કુલ 2-3 ક્રમિક દોરાઓ). હેમરેબલ નથી.
- **JSON Format:** `{"id":"m953_1","type":"M953","cells":[[2,8]],"params":{"storedThreads":["t_inner_1","t_inner_2"]},"hammerable":false}`

---

### M954 — Master Weaver Key (Grand Skeleton Charm)
- **ID:** `M954` | **Themed Name:** Master Weaver Key | **Generic:** Grand Skeleton Charm | **Intro:** L9871 | **Cat:** K | **Hammerable:** Yes (1 key/snip)
- **Rule:** ગ્રાન્ડ માસ્ટર વિવરની સુવર્ણ કી. જ્યારે આ દોરો અનરૅવલ થાય છે, ત્યારે તે બોર્ડ પરના તમામ પ્રકારના ક્લેસ્પ્સ, રિફ્લેક્ટ લોક્સ અને સેગમેન્ટ લોક્સને એકસાથે કાયમી અનલૉક કરવાની શક્તિ ધરાવે છે. હેમરેબલ છે.
- **JSON Format:** `{"id":"m954_1","type":"M954","cells":[[9,3],[9,4],[9,5]],"params":{"unlocksAll":true},"hammerable":true}`
