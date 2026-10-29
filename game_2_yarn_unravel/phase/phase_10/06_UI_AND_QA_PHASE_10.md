# 06 — UI & QA: Phase 10
> Sequencing (Pattern Book) વિઝ્યુઅલ્સ, રિધમિક એનિમેશન VFX, ટિયર લિમિટ્સ, રેન્ડરિંગ પર્ફોર્મન્સ બજેટ અને Phase 10 QA Checklist.

**Related docs:** [Phase 10 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md)

---

## 1. Visual Design & Sequencing Indicators
- **Metronome Gate Visuals:**
  - નાનું લાકડાનું પેન્ડ્યુલમ જે દરેક મૂવ પર ડાબે-જમણે ડોલે છે; ગેટ ખુલ્લો હોય ત્યારે લીલો સોફ્ટ ગ્લો અને બંધ હોય ત્યારે લાલ બોર્ડર દર્શાવે છે.
- **Pattern Clasp UI:**
  - એમ્બ્રોઇડરી બેજ જેમાં જરૂરી રંગોના નાના ઊનના દડા ક્રમશઃ દેખાય છે. યોગ્ય દોરો બહાર નીકળતાં તે રંગ પર ગોલ્ડન ચેકમાર્ક લાગે છે.
- **Ordered Hem Markings:**
  - બોર્ડની કિનારી પર સુવર્ણ ક્રમાંકિત ટાંકા ($1, 2, 3$) જે યોગ્ય ક્રમ માટે તેજસ્વી પલ્સ કરે છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `m451_metronome_tick` | `counter_pop` | મેટ્રોનોમ સોય સ્નેપ થાય છે; સૂક્ષ્મ ટિક અવાજ સાથે વૂડન ક્લિક | `selectionClick` |
| `m452_pattern_match` | `sparkle_stream` | સાચો રંગ બહાર નીકળતાં ક્લેસ્પ બેજ પર સ્પાર્કલ પ્રગટ થાય છે | `lightImpact` |
| `m452_clasp_open` | `gate_open` | આખી સિક્વન્સ પૂર્ણ થતાં ક્લેસ્પ ખુલે છે અને ક્રાફ્ટ પિન સ્નેપ થાય છે | `heavyImpact` |
| `m453_ordered_snag` | `blocked_bump` | ખોટા ક્રમમાં દોરો અડતાં રેડ સ્નેગ ટ્વાંગ અને હાર્ટ શેક | `rigidImpact` |
| `m454_echo_pulse` | `lane_warp` | એકો કાર્ડ પર સમાન કલર રિપીટ થતાં મેચિંગ વેવ પ્રસરે છે | `lightImpact` |

### Tier Budgets
- **Low Tier:** સિમ્પલ ઇન્સ્ટન્ટ ગેટ સ્વિચિંગ; મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 150 ms મેટ્રોનોમ સ્વીપ એનિમેશન; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** સંપૂર્ણ રિધમિક પેન્ડ્યુલમ મોશન અને પેટર્ન ક્લેસ્પ ગોલ્ડન ડસ્ટ શાવર; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 10)
- **QA-P10-01 (Metronome Gate):** મેટ્રોનોમ ગેટ નિર્ધારિત મૂવ પેટર્ન મુજબ બરાબર ખુલે અને બંધ થાય છે; બંધ સ્થિતિમાં સોલિડ બ્લોકર છે.
- **QA-P10-02 (Pattern Clasp):** માત્ર સાચા રંગ ક્રમમાં જ ક્લેસ્પ ઓપન થાય છે; ખોટો રંગ નીકળતાં ક્રમ રિસેટ થતો નથી પણ પ્રગતિ થતી નથી.
- **QA-P10-03 (Ordered Hem):** ચડતા ક્રમ સિવાયના દોરાઓ હેમમાંથી નીકળતાં સ્નેગ થઈને પાછા વળે છે.
- **QA-P10-04 (Echo Card):** પ્રથમ $k$ રંગોનો ક્રમ આગામી $k$ રંગો દ્વારા રિપીટ થવો ફરજિયાત છે; વિસંગત રંગ ટેપ લૉક રહે છે.
- **QA-P10-05 (0-Hearts Solvability):** L4501–5000 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P10-06 (Performance):** 14×14 ગ્રીડ પર સિક્વન્સિંગ મિકેનિક્સ છતાં લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
- **QA-P10-07 (Remote Config):** `maxPhase < 10` પર Phase 10 નોડ્સ લૉક રહે છે.
- **QA-P10-08 (Review & Finale):** L4991 રિવ્યૂ લેવલ અને L5000 "The Master Pattern" સંપૂર્ણ રીતે રમી શકાય છે.

