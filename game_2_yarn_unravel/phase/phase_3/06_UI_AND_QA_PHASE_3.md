# 06 — UI & QA: Phase 3
> Day & Night Loom HUD, Visual Effects (VFX), ટિયર લિમિટ્સ, ઑન-ડિવાઇસ જનરેટર પર્ફોર્મન્સ બજેટ અને Phase 3 QA Checklist.

**Related docs:** [Phase 3 index](./README.md) · [VFX Implementation §4, §5](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md)

---

## 1. HUD & UI Additions
- **Sun/Moon Loom Dial Widget:**
  - Gameplay ટોપ HUD માં Move કાઉન્ટરની બાજુમાં લાકડાનું ગોળ લૂમ ડાયલ દેખાય છે.
  - ડાયલ પર 5 stitch dots દર્શાવાય છે. દરેક માન્ય Move પર એક dot ઘટે છે (5, 4, 3, 2, 1).
  - State A માં નાનો સોનેરી સૂર્ય આઇકોન ચમકે છે; State B માં ચાંદી જેવો અર્ધચંદ્ર આઇકોન ચમકે છે.
  - 1 Move બાકી હોય ત્યારે ડાયલ સોફ્ટ પલ્સ કરે છે જેથી ખેલાડીને આગામી સાયકલ સ્વિચની અગાઉથી ચેતવણી મળે.
- **Board Ambient Transition:**
  - State A (Day Loom): બોર્ડનું લિનન કાપડ ગરમ ક્રીમ યલો ટોન (`#FFF9F0`) ધારણ કરે છે.
  - State B (Night Loom): લિનન કાપડ શીતળ ટ્વાઇલાઇટ બ્લુ ટોન (`#EBF3FA`) તરફ સ્મૂધ 400 ms માં કલર ટ્રાન્ઝિશન કરે છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `cycle_shift_day_to_night` | `state_toggle` + `morph_flash` | બોર્ડ લિનન પર સોફ્ટ કૂલ ગ્લો રિપલ; લૂમ શટલ ડાયલ ક્લિક કરે છે | `lightImpact` |
| `cycle_shift_night_to_day` | `state_toggle` + `morph_flash` | ગરમ સનશાઇન ગ્લો બોર્ડના સેન્ટરમાંથી ફેલાય છે | `lightImpact` |
| `m101_latch_toggle` | `state_toggle` | લાકડાની લેચ 90° ફરીને ખુલે છે/બંધ થાય છે; 4 નાના લાકડાના પાર્ટીકલ્સ | `selectionClick` |
| `m102_bridge_toggle` | `lane_warp` | ડે બ્રિજ સોનેરી થ્રેડ લૂપ્સ સાથે ઊભો થાય છે અથવા ફ્લેટ બ્લોકર બની જાય છે | `selectionClick` |
| `m103_pompom_active` | `portal_whoosh` | નાઇટ પોમપોમ ફરતે લ્યુમિનેસન્ટ વૂલ ફ્લફ સ્પાર્કલ્સ એક્ટિવેટ થાય છે | `lightImpact` |
| `m104_eyelet_shift` | `morph_flash` | આઇલેટની રીંગ કલર A માંથી કલર B માં સ્મૂધ ગ્રેડિયન્ટ ફ્લૅશ કરે છે | `selectionClick` |

### Tier Budgets (અપરિવર્તિત)
- **Low Tier:** મહત્તમ 30 લાઈવ પાર્ટીકલ્સ; એમ્બિયન્ટ લૂમ ગ્લો ઓફ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** મહત્તમ 80 પાર્ટીકલ્સ; 30 fps ટ્રાન્ઝિશન; 4 dp સ્ક્રીન શેક.
- **High Tier:** મહત્તમ 150 પાર્ટીકલ્સ; ફુલ 60 fps પાર્ટિકલ બર્સ્ટ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 3)
- **QA-P3-01 (Cycle Mechanics):** બરાબર દર 5 Moves એ Day અને Night વચ્ચે state toggle થાય છે. Bump કે locked taps પર કાઉન્ટર બદલાતું નથી.
- **QA-P3-02 (M101 Loom Latch):** નિયુક્ત સ્ટેટમાં ઓપન રહે છે અને વિરુદ્ધ સ્ટેટમાં સિંગલ બ્લોકર તરીકે -1 Heart snag કરે છે.
- **QA-P3-03 (M102 Day Bridge):** સ્ટેટ A માં બ્રિજ ઓર્થોગોનલ લેયર્સ પાસ થવા દે છે; સ્ટેટ B માં સિંગલ બ્લોકર બને છે.
- **QA-P3-04 (M103 Night Pompom):** સ્ટેટ B માં જ પોર્ટલ ટ્રાન્સફર થાય છે; સ્ટેટ A માં પોમપોમ બ્લોકર બની જાય છે.
- **QA-P3-05 (M104 Twilight Eyelet):** સ્ટેટ A માં માત્ર colorA અને સ્ટેટ B માં માત્ર colorB દોરા પાસ થાય છે; અન્ય સ્નેગ થાય છે.
- **QA-P3-06 (On-Device Generation):** L1001–1500 ના તમામ બોર્ડ્સ CI metadata `phase_3_meta.bin` સાથે ૧૦૦% બાઇટ-આઇડેન્ટિકલ જનરેટ થાય છે.
- **QA-P3-07 (0-Hearts Solvability):** L1001–1500 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P3-08 (Performance):** 14×14 ગ્રીડ પર 40 દોરાઓ સાથે 2 GB RAM વાળા લો-ટિયર ફોન પર 60 fps જળવાય છે.
- **QA-P3-09 (Remote Config Rollout):** `maxPhase < 3` હોય તો Phase 3 મેપ નોડ્સ લોક રહે છે; `maxPhase >= 3` પર અનલૉક થાય છે.
- **QA-P3-10 (Review & Finale):** L1491 રિવ્યૂ લેવલ અને L1500 Phase Finale "Day & Night Tapestry" સફળતાપૂર્વક લોડ થઈને રમી શકાય છે.

