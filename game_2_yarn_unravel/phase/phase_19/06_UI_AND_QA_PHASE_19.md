# 06 — UI & QA: Phase 19
> Remix B વિઝ્યુઅલ્સ, રોટર-ગ્રોથ કાઇનેમેટિક્સ, રિધમિક બેલ્ટ VFX, ટિયર લિમિટ્સ, રેન્ડરિંગ પર્ફોર્મન્સ બજેટ અને Phase 19 QA Checklist.

**Related docs:** [Phase 19 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md)

---

## 1. Visual Design & Kinematic Dynamics
- **Ivy Hoop Rotor Dynamics:**
  - 4×4 લાકડાનો એમ્બ્રોઇડરી રોટર જેના પર લીલા ઊનના વેલા જડેલા છે. ટેપ થતાં 220 ms માં 90° સ્મૂધ રોટેશન સાથે પાંદડાઓના લીલા સ્પાર્ક્સ ઉડે છે.
- **Twirl Weighted Thread Cues:**
  - ભારે ધાતુના કોરવાળો દોરો જે દરેક મૂવ પછી નાનો 360° સ્પીન કરીને ગુરુત્વાકર્ષણ દિશામાં સરકે છે.
- **Rhythm Belt Meter:**
  - કન્વેયર બેલ્ટ પર નાનો પલ્સિંગ સ્ટીચ મીટર જે બીટ મોમેન્ટ ($ON$) પર તેજસ્વી સોનેરી ગ્લો કરે છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `m901_twirl_fall` | `spool_roll` + `counter_pop` | દોરો 90° ટ્વિર્લ થઈને ગ્રેવિટીમાં સરકે છે; મેટાલિક સ્લાઇડ | `mediumImpact` |
| `m902_rotor_spin_grow` | `lane_warp` + `grow_burst` | રોટર 90° ફરે છે; નવા ખૂણામાંથી તાજા લીલા વેલા સ્પ્રાઉટ | `heavyImpact` |
| `m903_rhythm_step` | `counter_pop` | મેટ્રોનોમ બીટ પર બેલ્ટ 1 સેલ આગળ સ્નેપ થાય છે | `selectionClick` |
| `m904_seam_split_pass` | `morph_flash` + `burst_sparks` | સીમ એજમાંથી દોરો બીજા હૂપમાં બે પાતળા તંતુઓ બનીને પ્રવેશે છે | `mediumImpact` |

### Tier Budgets
- **Low Tier:** સિમ્પલ ઇન્સ્ટન્ટ રોટેશન અને સ્લાઇડ્સ; મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 200 ms સ્પીન અને સ્પ્રાઉટ એનિમેશન; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** સંપૂર્ણ ઓર્ગેનિક લીફ પાર્ટીકલ્સ, મેટાલિક થ્રેડ શિમર અને રોટર ક્લેક શેડોઝ; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 19)
- **QA-P19-01 (Twirl Weighted):** દોરો દરેક મૂવ પછી બરાબર 90° CW ફરે છે અને પછી ઉપલબ્ધ ગ્રેવિટી સેલમાં સ્લાઇડ થાય છે.
- **QA-P19-02 (Ivy Hoop Rotor):** રોટર ફરતાં આઇવી રૂટ્સ યોગ્ય સ્થિતિમાં આવે છે અને આગળનો ગ્રોથ સાચી દિશામાં વિસ્તરે છે.
- **QA-P19-03 (Rhythm Belt):** કન્વેયર માત્ર નિર્ધારિત બીટ પર જ ચાલે છે; ઑફ-બીટ પર દોરાઓ સ્થિર રહે છે.
- **QA-P19-04 (Seam Edge Split):** સીમમાંથી પસાર થતાં દોરો સચોટ 2 હાફ-પ્લાય તંતુઓમાં વહેંચાઈને બોર્ડ B માં આગળ વધે છે.
- **QA-P19-05 (0-Hearts Solvability):** L9001–9500 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P19-06 (Performance):** રોટેશન અને ડાયનેમિક ગ્રોથ એકસાથે હોવા છતાં લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
- **QA-P19-07 (Remote Config):** `maxPhase < 19` પર Phase 19 નોડ્સ લૉક રહે છે.
- **QA-P19-08 (Review & Finale):** L9491 રિવ્યૂ લેવલ અને L9500 "The Symphony of Motion" સંપૂર્ણ રીતે રમી શકાય છે.
