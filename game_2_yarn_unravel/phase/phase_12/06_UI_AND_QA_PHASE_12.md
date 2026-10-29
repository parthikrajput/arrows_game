# 06 — UI & QA: Phase 12
> Gravity (Hanging Loom) વિઝ્યુઅલ્સ, ગુરુત્વાકર્ષણ એરો UI, ડ્રોપિંગ બટન્સ VFX, ટિયર લિમિટ્સ, રેન્ડરિંગ પર્ફોર્મન્સ બજેટ અને Phase 12 QA Checklist.

**Related docs:** [Phase 12 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md)

---

## 1. Visual Design & Gravity Indicators
- **Plumb Bob Gravity Indicator:**
  - સ્ક્રીનના ખૂણે લટકતો પિત્તળનો ઓળંબો (Plumb Bob) જે હંમેશાં વર્તમાન ગુરુત્વાકર્ષણની દિશા ($\downarrow, \leftarrow, \uparrow, \rightarrow$) તરફ નમેલો દેખાય છે.
  - દિશા બદલાતી વખતે 250 ms નો સ્મૂધ પેન્ડ્યુલમ સ્વીંગ થાય છે.
- **Dropping Buttons Dynamics:**
  - લાકડાના બટનો સ્લાઇડ થતાં લિનન પર હળવી વુડ-સ્લાઇડિંગ ડસ્ટ દર્શાવે છે અને અથડાતાં સોફ્ટ વૂડન ક્લેટર સાઉન્ડ આવે છે.
- **Float Patch Visuals:**
  - ચમકતી સિલ્ક બોર્ડર સાથેનો આછો વાદળી પેચ જેના પરની વસ્તુઓ હવામાં સહેજ તરતી (floating) હોય તેવો ભાસ થાય છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `m551_gravity_shift` | `lane_warp` + `morph_flash` | ઓળંબો ફરે છે; આખા બોર્ડ પર હળવો ગ્રેવિટી વેવ પ્રસરે છે | `mediumImpact` |
| `m552_button_slide` | `spool_roll` | લાકડાનું બટન સરકે છે; પાછળ નાના વૂડન ફાઇબર સ્પાર્ક્સ | `selectionClick` |
| `m552_button_impact` | `hammer_impact` | બટન દિવાલ સાથે અથડાઈને અટકે છે; સોલિડ વૂડન થમ્પ | `lightImpact` |
| `m554_weighted_shift` | `counter_pop` | ભારે ધાતુનો દોરો 1 સેલ નીચે ખસે છે; મેટાલિક ક્લિક | `lightImpact` |

### Tier Budgets
- **Low Tier:** સિમ્પલ ઇન્સ્ટન્ટ સ્લાઇડ્સ; મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 200 ms સ્લાઇડ એનિમેશન; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** સંપૂર્ણ પેન્ડ્યુલમ મોશન, વૂડન ડસ્ટ ટ્રેલ્સ અને સોફ્ટ શેડોઝ; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 12)
- **QA-P12-01 (Plumb Lever):** ઓળંબો ટેપ થતાં જ 1 Move વપરાય છે અને ગુરુત્વાકર્ષણની દિશા આગળ વધે છે.
- **QA-P12-02 (Dropping Buttons):** તમામ અનગૂંથેલા બટનો ગુરુત્વાકર્ષણની દિશામાં અવરોધ સુધી સરકે છે; વચ્ચે આવતી સોય સાથે અથડાય છે.
- **QA-P12-03 (Float Patch):** ફ્લોટ પેચ પર રહેલી કોઈપણ વસ્તુ ગ્રેવિટી શિફ્ટથી સંપૂર્ણ અપ્રભાવિત રહે છે.
- **QA-P12-04 (Weighted Thread):** ભારે દોરો દરેક મૂવ પછી ગ્રેવિટી દિશામાં 1 સેલ ટ્રાન્સલેટ થાય છે જો લક્ષિત સેલ્સ ખાલી હોય.
- **QA-P12-05 (0-Hearts Solvability):** L5501–6000 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P12-06 (Performance):** ગ્રેવિટી ફિઝિક્સ કેલ્ક્યુલેશન છતાં લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
- **QA-P12-07 (Remote Config):** `maxPhase < 12` પર Phase 12 નોડ્સ લૉક રહે છે.
- **QA-P12-08 (Review & Finale):** L5991 રિવ્યૂ લેવલ અને L6000 "The Plumb Line Tapestry" સંપૂર્ણ રીતે રમી શકાય છે.

