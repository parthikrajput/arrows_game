# 04 — Variants & Modifiers: Phase 3
> Phase 3 ના 45 variant slots, 10 craft modifiers ના ચોક્કસ નિયમો અને Base Mechanics (M101–M104) સાથેના combinations.

**Related docs:** [Phase 3 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_1001_1500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. The 10 Craft Modifiers
Phase 3 ના variant slots નીચેના 10 માનક modifiers નો ઉપયોગ કરે છે:

| # | Modifier | Yarn Flavour Name | નિયમ અને ક્રિયાપ્રતિક્રિયા |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | ઇન્સ્ટન્સ જ્યાં સુધી પડોશના K દોરા બહાર ન નીકળે ત્યાં સુધી નિષ્ક્રિય રહે છે. બ્લોકર્સ બ્લોક રાખે છે; ઇન્ટરેક્ટિવ ટેપ લૉક રહે છે. |
| 2 | `Colored(c)` | **Dyed** | અસર માત્ર c કલરના દોરાને જ લાગુ પડે છે; અન્ય કલર માટે સેલ સિંગલ બ્લોકર તરીકે વર્તે છે. |
| 3 | `Fogged` | **Fluffed** | ઇન્સ્ટન્સ વૂલ ફ્લફ (M010) નીચે ઢંકાયેલું રહે છે; પડોશી દોરો નીકળે ત્યારે ક્લિયર થાય છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે સમાન ઇન્સ્ટન્સ રિબનથી જોડાયેલા હોય છે; એકમાં ફેરફાર બંનેમાં એકસાથે લાગુ પડે છે. |
| 5 | `Countdown(N)` | **Basting** | દરેક માન્ય Move પર કાઉન્ટર 1 ઘટે છે; 0 થતાં કાયમી અનલૉક અથવા અદૃશ્ય થાય છે. |
| 6 | `Phasing` | **Sheer Silk** | ઓડ/ઇવન મૂવ્સ પર સોલિડ અને ઘોસ્ટ ફેઝ વચ્ચે સ્વિચ થાય છે. |
| 7 | `Armored` | **Thimble-Reinforced** | ક્લિયર થવા માટે 2 હિટ્સ અથવા સ્નિપ્સની જરૂર પડે છે. |
| 8 | `Layered` | **Multi-Layer** | કાપડના ચોક્કસ લેયર (Layer 0, 1, 2) પર જ અસ્તિત્વ ધરાવે છે. |
| 9 | `Mirrored` | **Reflected** | મિરર એક્સિસ પર સામસામે જોડિયા સ્વરૂપે મૂવ થાય છે. |
| 10 | `Growing` | **Knit-Expanding** | દર N મૂવ્સ પર ખાલી સેલમાં 1 સેગમેન્ટ આગળ વધે છે. |

---

## 2. 45 Variant Slots Architecture
Phase 3 ના 45 variant blocks (Blocks 3–13, 15–25, 27–37, 39–49) Base Mechanics M101–M104 ને ઉપર્યુક્ત modifiers સાથે જોડે છે:

### Blocks 3–13: M101 (Loom Latch) Variants
- **Block 3 (L1021):** M101 × Knotted (Loom Latch જે K દોરા નીકળે પછી જ સાયકલિંગ શરૂ કરે છે).
- **Block 4 (L1031):** M101 × Dyed (ચોક્કસ કલરનો દોરો જ સાયકલ ઓપનિંગનો લાભ લઈ શકે).
- **Block 5 (L1041):** M101 × Fluffed (વૂલ ફ્લફ નીચે છુપાયેલી લેચ).
- **Block 6 (L1051):** M101 × Ribbon-Tied (બે લેચ જોડાયેલી; બંને એકસાથે Day માં ખુલે).
- **Block 7 (L1061):** M101 × Basting (N મૂવ્સ પછી કાયમી ઓપન રહેતી સાયકલ લેચ).
- **Block 8 (L1071):** M101 × Sheer Silk (ફેઝિંગ ફેબ્રિક લેચ).
- **Block 9 (L1081):** M101 × Thimble-Reinforced (2 સાયકલ પૂર્ણ થયા પછી જ મુક્ત થાય).
- **Block 10 (L1091):** M101 × Layered (ઉપરના ફેબ્રિક લેયર પર જ અસર કરતી લેચ).
- **Block 11 (L1101):** M101 × Reflected (મિરર એક્સિસ પર પરસ્પર સાયકલિંગ લેચ).
- **Block 12 (L1111):** M101 × Knit-Expanding (વિસ્તરતી વૂલ ટેન્ગલ સાથે જોડાયેલ લેચ).
- **Block 13 (L1121):** M101 Multi-Combination (Knotted + Dyed Loom Latch).

### Blocks 15–25: M102 (Day Bridge) Variants
- **Blocks 15–25 (L1141–1250):** Day Bridge ને Knotted (L1141), Dyed (L1151), Fluffed (L1161), Ribbon-Tied (L1171), Basting (L1181), Sheer Silk (L1191), Thimble-Reinforced (L1201), Layered (L1211), Reflected (L1221), Knit-Expanding (L1231) અને Multi-Mix (L1241) સાથે સ્લોટ કરવામાં આવ્યા છે.

### Blocks 27–37: M103 (Night Pompom) Variants
- **Blocks 27–37 (L1261–1370):** Night Pompom પોર્ટલ્સને Fluffed Pompom (L1261), Dyed Pompom (L1271), Knotted Pompom (L1281), Ribbon-Tied Pompom (L1291), Basting Pompom (L1301) સહિતના સ્લોટ્સમાં ગોઠવવામાં આવ્યા છે.

### Blocks 39–49: M104 (Twilight Eyelet) Variants & Multi-Base Combinations
- **Blocks 39–49 (L1381–1490):** Twilight Eyelet ને Knotted (L1381), Fluffed (L1391), Ribbon-Tied (L1401), Basting (L1411), તેમજ M101 + M102 કૉમ્બો (L1441), M101 + M103 કૉમ્બો (L1461), M102 + M104 કૉમ્બો (L1481) સાથે અંતિમ રેમ્પમાં મુકાયા છે.

---

## 3. Solver & Invariant Rules
1. **0-Hearts Solvability:** તમામ 45 variants CI validator દ્વારા ચકાસાય છે. સાયકલ સ્ટેટના કારણે કોઈ દોરો અનંત લૉકમાં ન ફસાય તેની ખાતરી કરવામાં આવે છે.
2. **Deterministic Parity:** Sheer Silk અને Basting કાઉન્ટર્સ standard §16.17 ક્રમ મુજબ `moveCount` વધ્યા પહેલાં કે પછી બરાબર નિર્ધારિત ક્રમે મૂલ્યાંકન કરે છે.

