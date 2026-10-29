# 06 — UI & QA: Phase 13
> Hidden Info (Mystery Basket) વિઝ્યુઅલ્સ, વૂલ ફ્લફ ફોગ શેડર્સ, લેન્ટર્ન ગ્લો VFX, ટિયર લિમિટ્સ, રેન્ડરિંગ પર્ફોર્મન્સ બજેટ અને Phase 13 QA Checklist.

**Related docs:** [Phase 13 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md)

---

## 1. Visual Design & Fog of War
- **Wool Fluff Cloud Shader:**
  - સોફ્ટ વૂલ ક્લાઉડ વિઝ્યુઅલ જે લિનન ફેબ્રિક પર રુંવાટીદાર ઊનના ગોટા જેવો દેખાય છે.
  - સ્કાઉટિંગ વખતે 250 ms માં ધુમ્મસ સોફ્ટ વાઇપ આઉટ સાથે ઓસરી જાય છે.
- **Painted Wall Trompe-l'œil:**
  - દોરો પસાર થતાં જ લાકડાની બનાવટી દિવાલ સફેદ એમ્બ્રોઇડરી ચોક લાઇનમાં ફેરવાઈ જાય છે.
- **Lantern Plate Warm Glow:**
  - દોરો પ્લેટ પર દબાતાં ગોલ્ડન એમ્બર લાઇટ સમગ્ર બોર્ડ પર ફેલાય છે અને વૂલ ફ્લફ સેમી-ટ્રાન્સપરન્ટ બને છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `m601_scout_reveal` | `gate_open` + `sparkle_stream` | સ્કાઉટ દોરાના પાથ આસપાસ ઊનની રુંવાટી સાફ થાય છે; તેજસ્વી વૂલ સ્પાર્ક્સ | `mediumImpact` |
| `m602_decoy_poof` | `pompom_poof` | ડેકોય ફ્લફ પર દોરો અડતાં ધુમાડાનો નાનો પફ ઉડે છે અને રસ્તો સાફ | `lightImpact` |
| `m603_painted_reveal` | `morph_flash` | નકલી દિવાલ ચોક લાઇનમાં રૂપાંતરિત થાય છે; સૂક્ષ્મ ડસ્ટ પફ | `selectionClick` |
| `m604_lantern_glow` | `lane_warp` | લેન્ટર્ન પ્લેટ દબાતાં ગરમ સોનેરી અજવાળું ફેલાય છે | `lightImpact` |

### Tier Budgets
- **Low Tier:** સિમ્પલ ઇન્સ્ટન્ટ ફોગ આલ્ફા કટ; મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 200 ms સોફ્ટ ફેડ અને વૂલ ડસ્ટ પફ; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** સંપૂર્ણ વૂલ ફાઇબર વિસર્જન પાર્ટીકલ્સ અને ડાયનેમિક લેન્ટર્ન શેડર્સ; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 13)
- **QA-P13-01 (Scout Thread):** સ્કાઉટ દોરો એક્ઝિટ થતાં જ તેના સમગ્ર પાથથી 1-સેલ રેડિયસનું ફોગ સાફ થાય છે.
- **QA-P13-02 (Decoy Fluff):** ડેકોય ફ્લફમાંથી દોરો નિર્બાધ રીતે પસાર થાય છે અને ફ્લફ અદૃશ્ય થાય છે.
- **QA-P13-03 (Painted Wall):** દોરો પસાર થતાં પેઇન્ટેડ વોલ પારદર્શક બને છે; કોઈ સ્નેગ થતો નથી.
- **QA-P13-04 (Lantern Plate):** દોરાનું બોડી પ્લેટ પર હોવા દરમિયાન ફોગ 40% ઓપેસિટી પર દેખાય છે; દોરો ખસતાં ફોગ ફરી અસ્પષ્ટ બને છે.
- **QA-P13-05 (0-Hearts Solvability):** L6001–6500 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P13-06 (Performance):** ફોગ શેડર્સ અને પાર્શિયલ ઓપેસિટી છતાં લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
- **QA-P13-07 (Remote Config):** `maxPhase < 13` પર Phase 13 નોડ્સ લૉક રહે છે.
- **QA-P13-08 (Review & Finale):** L6491 રિવ્યૂ લેવલ અને L6500 "The Unveiled Motif" સંપૂર્ણ રીતે રમી શકાય છે.

