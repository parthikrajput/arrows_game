# 06 — UI & QA: Phase 6
> Lamplight Atelier ઓપ્ટિકલ વિઝ્યુઅલ્સ, કલર ગ્લો શૅડર્સ, ટિયર લિમિટ્સ, બીમ રે-કાસ્ટિંગ પર્ફોર્મન્સ બજેટ અને Phase 6 QA Checklist.

**Related docs:** [Phase 6 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md)

---

## 1. Visual Design & Beam Rendering
- **Light Beams (`BlendMode.plus`):**
  - પ્રકાશ કિરણો લાઇન-સેગમેન્ટ્સ તરીકે `BlendMode.plus` સાથે ડ્રો થાય છે.
  - કોઈ runtime `MaskFilter.blur` વાપરવામાં આવતો નથી; સોફ્ટ એજ ગ્લો pre-baked આલ્ફા ગ્રેડિયન્ટ સ્ટ્રોક દ્વારા રચાય છે.
- **Shadow Pockets (અંધારા સેલ્સ):**
  - ક્રાફ્ટ બોર્ડના જે ભાગમાં પ્રકાશ નથી પહોંચતો ત્યાં સોફ્ટ ટ્વાઇલાઇટ વિગ્નેટ શેડર (`alpha = 0.40`) લાગુ પડે છે, જે કિરણ અડતાં જ 150 ms માં અદૃશ્ય થાય છે.
- **Prism Clasp Indicators:**
  - પ્રિઝમ ક્લેસ્પ પર નાના ઇન્ડિકેટર લેમ્પ્સ (0/2, 1/2, 2/2) દર્શાવે છે કે કેટલા કિરણો હાલ આપાત થઈ રહ્યા છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `beam_ignite` | `beam_glow` | વિન્ટેજ બ્રાસ લેમ્પ ફિલામેન્ટ ગ્લો કરે છે; સોનેરી પ્રકાશ કિરણ સીધું પ્રસરે છે | `lightImpact` |
| `m251_filter_pass` | `morph_flash` | સફેદ કિરણ ટિન્ટેડ ગ્લાસમાંથી પસાર થઈને તેજસ્વી રંગ ધારણ કરે છે | `selectionClick` |
| `m252_prism_unlock` | `state_toggle` + `morph_flash` | 2 કિરણો મળતાં પ્રિઝમ ક્લેસ્પમાં ગોલ્ડન સ્ટારબર્સ્ટ ફ્લૅશ; ક્લેસ્પ અનલૉક | `heavyImpact` |
| `m253_lamp_tick` | `state_toggle` | અવરગ્લાસ લેમ્પ મુવ કાઉન્ટર પર ઑન/ઑફ થાય છે; હળવો ક્લિક સાઉન્ડ | `selectionClick` |
| `m254_shadow_lift` | `fog_dissolve` | કિરણ સેલમાં પ્રવેશે છે; અંધારું ઓગળીને સોય અને દોરાની પેટર્ન પ્રગટ થાય છે | `lightImpact` |

### Tier Budgets
- **Low Tier:** સિમ્પલ સોલિડ કલર્ડ લાઇન્સ (નો બ્લૂમ પાર્ટીકલ્સ); મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** સોફ્ટ આલ્ફા ગ્રેડિયન્ટ બીમ્સ; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** ફુલ ઓપ્ટિકલ ક્રોમેટિક પ્રિઝમ્સ અને ડસ્ટ મોટ્સ; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 6)
- **QA-P6-01 (Ray Casting):** કિરણો લૅમ્પમાંથી સીધી રેખામાં પ્રવાસ કરે છે અને બ્લોકર્સ કે દોરાના શરીર દ્વારા અટકે છે.
- **QA-P6-02 (Dynamic Beam Extension):** દોરો અનરૅવલ થતાં જ ખાલી થયેલા સેલ્સમાંથી કિરણ તાત્કાલિક આગળ વધે છે.
- **QA-P6-03 (M251 Tinted Glass):** કિરણ કાચનો કલર ધારણ કરે છે અને માત્ર મેચિંગ સન-કેચર્સને જ ઓપન કરે છે.
- **QA-P6-04 (M252 Prism Clasp):** બરાબર $\ge 2$ કિરણો એકસાથે મળવાથી જ ક્લેસ્પ અનલૉક થાય છે.
- **QA-P6-05 (M253 Hourglass Lamp):** દર N મૂવ્સ પર લેમ્પ નિયમિતપણે ઑન/ઑફ થાય છે; કોઈ વોલ-ક્લોક ટાઈમર નથી.
- **QA-P6-06 (M254 Shadow Pocket):** અંધારા સેલમાં રહેલો દોરો લૉક રહે છે; કિરણ પડતાં જ ટેપ કરવા સક્ષમ બને છે.
- **QA-P6-07 (0-Hearts Solvability):** L2501–3000 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P6-08 (Performance):** 14×14 ગ્રીડ પર 5 લેમ્પ્સ સાથે લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
- **QA-P6-09 (Remote Config):** `maxPhase < 6` પર Phase 6 નોડ્સ લોક રહે છે.
- **QA-P6-10 (Review & Finale):** L2991 રિવ્યૂ લેવલ અને L3000 "Atelier Chandelier Tapestry" સંપૂર્ણ રીતે રમી શકાય છે.

