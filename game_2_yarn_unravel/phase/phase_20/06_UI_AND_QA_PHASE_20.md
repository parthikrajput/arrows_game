# 06 — UI & QA: Phase 20
> Grand Master (The Endless Tapestry) વિઝ્યુઅલ્સ, L10,000 Grand Finale સિનેમેટિક એનિમેશન, ગ્રાન્ડ માસ્ટર સેરેમની, ટિયર બજેટ્સ અને Phase 20 QA Checklist.

**Related docs:** [Phase 20 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md)

---

## 1. Visual Design & Grand Finale Cinematics
- **Moving Guardian Boss Stature:**
  - 2×2 વિશાળ મખમલ પિનકુશન જે લિનન ફેબ્રિક પર યાંત્રિક ગિયર્સના સોફ્ટ વાઇબ્રેશન સાથે ચાલે છે.
- **Level 10,000 Grand Finale Aesthetic:**
  - સોનાના તારથી ગૂંથેલી વિશેષ 14×14 ફ્રેમ; તમામ 19 સિસ્ટમ્સના વિઝ્યુઅલ એલિમેન્ટ્સ સુમેળથી રજૂ થાય છે.
- **Grand Master Ceremony:**
  - L10,000 પૂર્ણ થતાં સંપૂર્ણ સ્ક્રીન પર સમગ્ર 10,000 લેવલ્સમાંથી બનેલી અદ્ભુત "Endless Tapestry" નો 1,800 ms નો સિનેમેટિક કેમેરા પેન-આઉટ થાય છે, જેમાં "Grand Master Weaver" ગોલ્ડન બેજ ચમકે છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `m951_moving_step` | `spool_roll` + `counter_pop` | મૂવિંગ ગાર્ડિયન 1 સેલ આગળ વધે છે; ગિયર સ્પીન અને થમ્પ | `mediumImpact` |
| `m952_omni_unlock` | `gate_open` + `sparkle_stream` | ક્રોમેટિક પ્રિઝમ ગેટ તમામ રંગોના સ્પાર્કલ્સ સાથે ખુલે છે | `heavyImpact` |
| `m953_spool_dispense` | `grow_burst` + `lane_warp` | સેન્ટ્રલ બોબિનમાંથી નવો સોનેરી દોરો અનવાઇન્ડ થઈને બોર્ડ પર આવે છે | `lightImpact` |
| `m954_master_key_flash` | `key_unlock` + `morph_flash` | માસ્ટર કી સમગ્ર બોર્ડના લોક્સને એકસાથે ઓપન કરે છે | `heavyImpact` |
| `l10000_grand_celebration` | `confetti_shower` + `royal_sparkles` | 10,000 લેવલ્સ પૂર્ણ થવાની ભવ્ય ઉજવણી; ગોલ્ડન વૂલ કોન્ફેટી | `heavyImpact` |

### Tier Budgets
- **Low Tier:** સિમ્પલ ઇન્સ્ટન્ટ ગાર્ડિયન સ્ટેપ અને સેરેમની બેનર; મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 200 ms સિનેમેટિક એનિમેશન અને કોન્ફેટી; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** સંપૂર્ણ સિનેમેટિક કેમેરા ઝૂમ, ગોલ્ડન વૂલ થ્રેડ શાવર અને રોયલ પર્લ બેજ પાર્ટીકલ્સ; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 20)
- **QA-P20-01 (Moving Guardian):** ગાર્ડિયન દર 2 મૂવ્સે નિર્ધારિત પેટ્રોલ પાથ પર બરાબર 1 સેલ આગળ વધે છે.
- **QA-P20-02 (Omni Gate):** ત્રણ શરતો (લાઇટ બીમ + કલર + સાયકલ સ્ટેટ) સંતોષાય ત્યારે જ ઓપન થાય છે.
- **QA-P20-03 (Grand Loom Spool):** વર્તમાન દોરો બહાર નીકળતાં જ બોબિનમાંથી આગામી દોરો યોગ્ય રીતે અનવાઇન્ડ થાય છે.
- **QA-P20-04 (Master Weaver Key):** કી દોરો બહાર નીકળતાં તમામ ક્લેસ્પ્સ અને લોક્સ એકસાથે અનલૉક થાય છે.
- **QA-P20-05 (Level 10,000 Solvability):** L10,000 "The Endless Tapestry" 0 hearts અને 0 boosters વડે 100% સોલ્વેબલ છે.
- **QA-P20-06 (Endgame Transition):** L10,000 વિન પછી ગેમ સ્ટેટ ક્રેશ વગર એન્ડગેમ લૂપ ("New patterns coming soon" + Daily Stitch) માં સ્મૂધલી ટ્રાન્ઝિશન થાય છે.
- **QA-P20-07 (Remote Config):** `maxPhase < 20` પર Phase 20 નોડ્સ લૉક રહે છે.
- **QA-P20-08 (Performance):** તમામ સિસ્ટમ્સ એકસાથે ચાલતી હોવા છતાં લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
