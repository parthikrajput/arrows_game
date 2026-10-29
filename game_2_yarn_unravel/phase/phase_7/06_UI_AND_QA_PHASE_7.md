# 06 — UI & QA: Phase 7
> Turning Table રોટેશનલ વિઝ્યુઅલ્સ, એન્ગ્યુલર VFX, ટિયર લિમિટ્સ, કેનવાસ ટ્રાન્સફોર્મ પર્ફોર્મન્સ બજેટ અને Phase 7 QA Checklist.

**Related docs:** [Phase 7 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md)

---

## 1. Visual Design & Rotation Rendering
- **Sub-Board Rotor Transform (`canvas.rotate`):**
  - 4×4 રોટરના એલિમેન્ટ્સને વ્યક્તિગત રીતે ફરીથી ડ્રો કરવાને બદલે, કેનવાસ મેટ્રિક્સ ટ્રાન્સફોર્મ (`canvas.save() -> canvas.translate() -> canvas.rotate() -> canvas.restore()`) વડે સિંગલ પાસમાં સ્મૂધ 250 ms માં ફેરવવામાં આવે છે.
- **Turning Hem Border Animation:**
  - બોર્ડની કિનારી પર ઓપન ગેપ્સ 1 સેલ આગળ વધતાં સ્મૂધ સ્લાઇડિંગ ફેબ્રિક સ્ટીચ એનિમેશન ચાલે છે.
- **Tangled Thread Visual State:**
  - જે દોરો ટેન્ગલ્ડ બને છે તેની સોય પર નાનો લાલ લૉક આઇકોન અને હળવો ડલ આલ્ફા શેડ (`alpha = 0.75`) દેખાય છે જેથી ખેલાડી સમજી શકે કે તે હાલ ટેપ કરવા માટે ઉપલબ્ધ નથી.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `rotor_rotate_tap` | `rotate_swoosh` | 4×4 હૂપ રોટર 90° CW ફરે છે; લાકડાની રિંગ્સ ફરતે ગોળાકાર વૂલ સ્વોશ લાઇન | `mediumImpact` |
| `m302_hem_shift` | `state_toggle` | બોર્ડની કિનારી પર ઓપન ગેપ 1 સેગમેન્ટ CW ખસે છે; સોફ્ટ થ્રેડ સ્લાઇડ સાઉન્ડ | `selectionClick` |
| `m303_twirl_tick` | `morph_flash` | ટ્વિર્લ દોરાની સોય 90° ક્લોકવાઇઝ ફરે છે; સોયની આંખમાંથી નાનો સિલ્વર સ્પાર્ક | `selectionClick` |
| `m304_pin_pop` | `state_toggle` | બ્રાસ સેફ્ટી પિન સ્પ્રિંગ ટેન્શન સાથે અનક્લિપ થાય છે; ગોલ્ડન પાર્ટિકલ બર્સ્ટ | `lightImpact` |
| `tangled_denied_tap` | `denied_nudge` | ટેન્ગલ્ડ દોરો ટેપ કરતાં સોફ્ટ 3-સાયકલ સાઇડ વૉબલ; લૉક બેજ પોપ | `selectionClick` |

### Tier Budgets
- **Low Tier:** રોટેશન સિમ્પલ 0 ms સ્નેપ (નો મોશન બ્લર); મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 200 ms ઇઝ-ઇન-આઉટ રોટેશન; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** 250 ms સ્મૂધ એન્ગ્યુલર ઇનર્શિયા + વૂલ ટ્રેઇલ્સ; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 7)
- **QA-P7-01 (Hoop Rotor):** 4×4 રોટર ટેપ કરતાં અંદરના દોરાઓ અને બ્લોકર્સ સાચા 90° CW કોઓર્ડિનેટ્સ પર ટ્રાન્સફોર્મ થાય છે (1 Move).
- **QA-P7-02 (Boundary Lock):** અર્ધ-અંદર અર્ધ-બહાર દોરો હોય તો રોટર ટેપ લૉક રહે છે અને 0 Move ખર્ચ થાય છે.
- **QA-P7-03 (M302 Turning Hem):** દરેક માન્ય Move પછી એક્ઝિટ ગેપ બરાબર 1 સેગમેન્ટ CW ફરે છે.
- **QA-P7-04 (M303 Twirl Thread):** દરેક માન્ય Move પછી ટ્વિર્લ દોરાની સોય 90° CW ફરે છે; યોગ્ય દિશામાં જ અનરૅવલ થાય છે.
- **QA-P7-05 (M304 Ratchet Pin):** જ્યાં સુધી કી-દોરો ન નીકળે ત્યાં સુધી રોટર ફરતું નથી.
- **QA-P7-06 (Tangled State):** સોય પોતાના શરીર તરફ પોઇન્ટ કરે ત્યારે દોરો લૉક રહે છે; 0 Heart lost, 0 Move.
- **QA-P7-07 (0-Hearts Solvability):** L3001–3500 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P7-08 (Performance):** રોટેશન દરમિયાન કેનવાસ મેટ્રિક્સ ટ્રાન્સફોર્મથી 60 fps જળવાય છે (રાસ્ટર p95 < 8 ms).
- **QA-P7-09 (Remote Config):** `maxPhase < 7` પર Phase 7 નોડ્સ લોક રહે છે.
- **QA-P7-10 (Review & Finale):** L3491 રિવ્યૂ લેવલ અને L3500 "The Kaleidoscope Quilt" સંપૂર્ણ રીતે રમી શકાય છે.

