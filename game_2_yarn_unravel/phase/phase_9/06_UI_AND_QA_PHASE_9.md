# 06 — UI & QA: Phase 9
> Split & Merge (Ply & Twist) વિઝ્યુઅલ્સ, થ્રેડ સ્પ્લિટ/મર્જ VFX, ટિયર લિમિટ્સ, રેન્ડરિંગ પર્ફોર્મન્સ બજેટ અને Phase 9 QA Checklist.

**Related docs:** [Phase 9 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md)

---

## 1. Visual Design & Split/Merge Rendering
- **Twisting Pad Visuals:**
  - લાકડાના ફ્રેમ પર વણાયેલું સર્પાકાર વૂલ પેડ, જે બે સક્રિય સોય આવતાં ગોલ્ડન પલ્સ સાથે પ્રકાશિત થાય છે.
  - ટેપ થતાં બંને દોરા 180 ms માં વળાઈને (twist) એક જાડા દોરામાં ફેરવાય છે.
- **Double Split Visuals:**
  - સોય સ્પ્લિટરમાં પ્રવેશતાં બે પાતળા તંતુઓમાં વિભાજીત થાય છે; દરેક તંતુ મૂળ દોરા કરતાં 50% પાતળો દેખાય છે.
- **Rejoin Gate Visuals:**
  - ક્રાફ્ટ બકલ જે બંને પ્લીસ પાસ ન થાય ત્યાં સુધી અડધો ચમકે છે, અને બંને પ્લીસ નીકળતાં સંપૂર્ણ અનલૉક થાય છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `m401_twisting_merge` | `morph_flash` + `lane_warp` | બે દોરા વળાઈને એક થાય છે; ગોલ્ડન વૂલ ટ્વિસ્ટ સ્પાર્ક્સ | `mediumImpact` |
| `m402_double_split` | `burst_sparks` | સોય બે સમાંતર તંતુઓમાં વહેંચાય છે; નાના વૂલ ફ્લફ સ્પ્લિટ્સ | `lightImpact` |
| `m403_stitch_lock_open` | `key_unlock` | કી દોરો બહાર નીકળતાં સ્ટીચ લૉક ખુલે છે; સિલ્વર શિમર | `selectionClick` |
| `m404_rejoin_gate_open` | `gate_open` | બંને પ્લીસ બહાર નીકળતાં બકલ ગેટ સ્નેપ ઓપન થાય છે | `heavyImpact` |

### Tier Budgets
- **Low Tier:** સિમ્પલ ઇન્સ્ટન્ટ સ્પ્લિટ/મર્જ; મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 180 ms ટ્વિસ્ટિંગ એનિમેશન; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** સંપૂર્ણ વૂલ ફાઇબર ટ્વિસ્ટ પાર્ટીકલ્સ અને શિમર ગ્લો; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 9)
- **QA-P9-01 (Twisting Pad):** બે સોય પેડ પર આવતાં જ પેડ ટેપ-સક્રિય થાય છે અને 1 Move માં બંને દોરા મર્જ થાય છે.
- **QA-P9-02 (Double Split):** દોરો સ્પ્લિટરમાં પ્રવેશતાં બંને નવા દોરા મૂળ દિશા જાળવી રાખીને સમાંતર આગળ વધે છે.
- **QA-P9-03 (M403 Stitch Lock):** કી દોરો બહાર ન નીકળે ત્યાં સુધી નિર્ધારિત સેગમેન્ટ લૉક રહે છે; ટેપ કરવાથી સ્નેગ નહીં પણ લૉક્ડ નોટિફિકેશન મળે છે.
- **QA-P9-04 (M404 Rejoin Gate):** બંને સ્પ્લિટ થયેલા દોરા પસાર થયા પછી જ ગેટ કાયમી ઓપન થાય છે.
- **QA-P9-05 (0-Hearts Solvability):** L4001–4500 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P9-06 (Performance):** 14×14 ગ્રીડ પર સ્પ્લિટ અને મર્જ મિકેનિક્સ છતાં લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
- **QA-P9-07 (Remote Config):** `maxPhase < 9` પર Phase 9 નોડ્સ લૉક રહે છે.
- **QA-P9-08 (Review & Finale):** L4491 રિવ્યૂ લેવલ અને L4500 "The Grand Tapestry Knot" સંપૂર્ણ રીતે રમી શકાય છે.

