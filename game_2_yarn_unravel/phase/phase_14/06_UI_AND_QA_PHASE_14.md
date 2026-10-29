# 06 — UI & QA: Phase 14
> Mirror Worlds (Looking-Glass Quilt) વિઝ્યુઅલ્સ, મિરર એક્સિસ સ્ટાઇલિંગ, સિમેટ્રી શિમર VFX, ટિયર લિમિટ્સ, રેન્ડરિંગ પર્ફોર્મન્સ બજેટ અને Phase 14 QA Checklist.

**Related docs:** [Phase 14 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md)

---

## 1. Visual Design & Mirror Symmetry
- **Mirror Seam Visuals:**
  - ક્વિલ્ટની મધ્યમાં આવેલી ચાંદીની ઝિગ-ઝેગ સ્ટીચ જે સતત સોફ્ટ સિલ્વર શિમર પ્રદર્શિત કરે છે.
  - ખેલાડી જ્યારે એક દોરા પર આંગળી મૂકે છે, ત્યારે મિરર દોરો પણ ચમકીને તેની સિંક સ્થિતિ બતાવે છે.
- **Reflect Clasp Styling:**
  - બંને બાજુએ સરખા દેખાતા એમ્બ્રોઇડરી ક્લેસ્પ્સ જે એક ખુલે ત્યારે બીજા પરથી પ્રકાશનું કિરણ પસાર થાય છે.
- **Inverse Thread Cues:**
  - ઇન્વર્સ દોરાના નીડલ હેડ પર વિરુદ્ધ દિશા દર્શાવતો નાનો ગ્લાસ એરો માર્કર હોય છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `m651_mirror_unravel` | `lane_warp` + `sparkle_stream` | બંને ટ્વીન દોરાઓ એકસાથે સમાંતર અનરૅવલ થાય છે; સિલ્વર સ્પાર્કલ ટ્રેલ | `mediumImpact` |
| `m652_reflect_unlock` | `key_unlock` + `morph_flash` | એક ક્લેસ્પ ખૂલતાં જ મિરર સીમ દ્વારા લાઇટ બર્સ્ટ બીજી બાજુ જાય છે | `heavyImpact` |
| `m653_twin_quilt_flip` | `counter_pop` | ક્વિલ્ટ ટૉગલ ફ્લિપ થતાં બંને બાજુઓ સિંક સ્ટેટ અપડેટ કરે છે | `selectionClick` |
| `m654_inverse_motion` | `spool_roll` | ઇન્વર્સ દોરો વિરુદ્ધ દિશામાં સરકે છે; ગ્લાસ શિમર ઇફેક્ટ | `lightImpact` |

### Tier Budgets
- **Low Tier:** સિમ્પલ ઇન્સ્ટન્ટ ટ્વીન અનરૅવલ; મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 180 ms સિલ્વર શિમર અને મિરર વેવ; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** સંપૂર્ણ સિલ્વર થ્રેડ રિફ્લેક્શન પાર્ટીકલ્સ અને ડ્યુઅલ શિમર ગ્લો; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 14)
- **QA-P14-01 (Mirror Seam):** ટ્વીન દોરાઓ એકસાથે અનરૅવલ થાય છે જો બંને પાથ ક્લિયર હોય.
- **QA-P14-02 (Twin Snag):** જો કોઈ એક પણ ટ્વીન દોરો બ્લોક હોય, તો બંને સ્નેગ થાય છે અને કુલ માત્ર 1 Heart જ કપાય છે.
- **QA-P14-03 (Reflect Clasp):** એક ક્લેસ્પ કી દ્વારા અનલૉક થતાં મિરર ક્લેસ્પ આપોઆપ કાયમી ખુલી જાય છે.
- **QA-P14-04 (Inverse Thread):** મુખ્ય દોરો આગળ વધતાં ઇન્વર્સ દોરો ચોક્કસ 180° વિરુદ્ધ દિશામાં ગતિ કરે છે.
- **QA-P14-05 (0-Hearts Solvability):** L6501–7000 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P14-06 (Performance):** ડ્યુઅલ સિંક્રનાઇઝ્ડ સ્ટીચિંગ મોશન છતાં લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
- **QA-P14-07 (Remote Config):** `maxPhase < 14` પર Phase 14 નોડ્સ લૉક રહે છે.
- **QA-P14-08 (Review & Finale):** L6991 રિવ્યૂ લેવલ અને L7000 "The Looking-Glass Masterpiece" સંપૂર્ણ રીતે રમી શકાય છે.

