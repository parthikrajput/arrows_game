# 03 — Signature System & Base Mechanics: Phase 14
> Mirror Worlds (Looking-Glass Quilt) signature system અને Phase 14 ના 4 નવા base mechanics (M651–M654) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 14 index](./README.md) · [01 Scope & Rules](./01_PHASE_14_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Mirror Worlds (Looking-Glass Quilt)
- **Concept:** ક્વિલ્ટિંગ ક્રાફ્ટમાં મિરર સિમેટ્રી (દર્પણ સમપ્રમાણતા) એક સુંદર ડિઝાઇન સિદ્ધાંત છે. Looking-Glass Quilt માં બોર્ડ મધ્ય રેખા (Mirror Seam) વડે બે સમપ્રમાણ અર્ધભાગોમાં વહેંચાયેલું હોય છે, જ્યાં બંને બાજુના ટ્વીન દોરાઓ એકસાથે અથવા વિરુદ્ધ દિશામાં ચાલે છે.
- **Rules & Mechanics:**
  - ટ્વીન દોરાઓને અલગ-અલગ ટેપ કરી શકાતા નથી; એક પર ટેપ કરતાં બંને સિંક્રનાઇઝ્ડ થાય છે.
  - જો બંને દોરાઓના રસ્તા ખુલ્લા હોય તો જ તેઓ સફળતાપૂર્વક અનરૅવલ થાય છે; જો કોઈ એક પણ બ્લોક હોય તો બંને સ્નેગ થાય છે, પરંતુ કુલ -1 Heart જ ગુમાવાય છે.
  - તમામ મિરર પઝલ્સ 0-hearts solvable પાથ ધરાવે છે.

---

## 2. Base Mechanics Catalog Cards

### M651 — Mirror Seam (Mirror Axis)
- **ID:** `M651` | **Themed Name:** Mirror Seam | **Generic:** Mirror Axis | **Intro:** L6511 | **Cat:** T/E | **Hammerable:** No
- **Rule:** બોર્ડની મધ્યમાં રહેલી સિલ્વર થ્રેડ મિરર સીમ (વર્ટિકલ અથવા હોરિઝોન્ટલ). સીમની સામસામે રહેલા ટ્વીન દોરાઓ જોડાયેલા હોય છે. એક પર ટેપ કરતાં બંને એકસાથે બહાર નીકળે છે (બંને પાથ ક્લિયર હોવા ફરજિયાત છે; અન્યથા બંને સ્નેગ થાય છે, -1 Heart). હેમરેબલ નથી.
- **JSON Format:** `{"id":"m651_1","type":"M651","cells":[[0,7],[1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[7,7],[8,7],[9,7],[10,7],[11,7]],"params":{"axis":"vertical","x":7},"hammerable":false}`

---

### M652 — Reflect Clasp (Reflect Lock)
- **ID:** `M652` | **Themed Name:** Reflect Clasp | **Generic:** Reflect Lock | **Intro:** L6631 | **Cat:** K/B | **Hammerable:** No
- **Rule:** મિરર સીમની બંને બાજુએ સમાન અંતરે ગોઠવાયેલી બે ક્લેસ્પની જોડી. જ્યારે ખેલાડી એક બાજુના ક્લેસ્પને તેની નિયુક્ત કી વડે અનલૉક કરે છે, ત્યારે બીજી બાજુનો ક્લેસ્પ કોઈ અલગ કી વગર તાત્કાલિક આપોઆપ પ્રતિબિંબિત થઈને ખુલી જાય છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m652_1","type":"M652","cells":[[4,3],[4,11]],"params":{"twinClaspId":"m652_1_b"},"hammerable":false}`

---

### M653 — Twin Quilt (Twin Board)
- **ID:** `M653` | **Themed Name:** Twin Quilt | **Generic:** Twin Board | **Intro:** L6751 | **Cat:** D/G | **Hammerable:** No
- **Rule:** બોર્ડના એક અર્ધભાગ પરનો ઇન્ટરેક્ટિવ સ્વિચ કે ટૉગલ પેચ. ખેલાડી આ ટૉગલ પર ટેપ કરે છે (1 Move વપરાય છે), ત્યારે મિરર અક્ષની સામે રહેલો પ્રતિબિંબિત ટૉગલ આપોઆપ તે જ સમયે સમાન અવસ્થા ધારણ કરે છે (દા.ત. એક બાજુનો ગેટ ખૂલે તો મિરર ગેટ પણ ખૂલે). હેમરેબલ નથી.
- **JSON Format:** `{"id":"m653_1","type":"M653","cells":[[2,4],[2,10]],"params":{"linkedToggle":"m653_1_b"},"hammerable":false}`

---

### M654 — Inverse Thread (Inverse Path)
- **ID:** `M654` | **Themed Name:** Inverse Thread | **Generic:** Inverse Path | **Intro:** L6871 | **Cat:** P | **Hammerable:** Yes
- **Rule:** મુખ્ય દોરા સાથે વિરોધાભાસી રીતે જોડાયેલો દોરો. જ્યારે મુખ્ય દોરો આગળ વધે છે (દિશા `dir`), ત્યારે આ ઇન્વર્સ દોરો બરાબર તેની 180° વિરુદ્ધ દિશામાં (`opposite(dir)`) ગતિ કરીને બહાર નીકળવાનો પ્રયત્ન કરે છે. હેમરેબલ છે.
- **JSON Format:** `{"id":"m654_1","type":"M654","cells":[[8,2],[8,3],[8,4]],"params":{"primaryThreadId":"t_08","inverse":true},"hammerable":true}`

