# 06 — UI & QA: Phase 4
> Multi-Floor HUD, ફ્લોર સ્વિચર વિજેટ્સ, Visual Effects (VFX), ટિયર લિમિટ્સ, વર્ટિકલ રેન્ડરિંગ પર્ફોર્મન્સ બજેટ અને Phase 4 QA Checklist.

**Related docs:** [Phase 4 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md)

---

## 1. HUD & UI Additions
- **Floor Switcher Tab Widget:**
  - Gameplay સ્ક્રીનના જમણી બાજુ વર્ટિકલ ટેબ્સ દેખાય છે: `F1` (Embroidery Table), `F2` (Cutting Table), `F3` (Attic Loom).
  - સક્રિય ફ્લોર ગોલ્ડન લૂમ બોર્ડર સાથે હાઇલાઇટ થાય છે.
  - ખેલાડી ટેબ પર ટેપ કરે એટલે કેમેરા 250 ms માં સ્મૂધ ઇઝ-ઇન-આઉટ વર્ટિકલ ગ્લાઇડ સાથે તે ફ્લોર પર સ્વિચ થાય છે (0 Moves cost).
- **Floor Thread Counters:**
  - દરેક ફ્લોર ટેબની નીચે નાનો બેજ તે ફ્લોર પર બાકી રહેલા દોરાઓની સંખ્યા દર્શાવે છે (દા.ત. `F1: 12`, `F2: 8`).
- **Organza Transparency Rendering:**
  - ઓર્ગેન્ઝા સેલ્સ સેમિ-ટ્રાન્સપરન્ટ સિલ્ક શેડર (`alpha = 0.55`) સાથે રેન્ડર થાય છે જેથી નીચેનો ફ્લોર ઝાંખો દેખાય.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `floor_switch` | `lane_warp` | કેમેરા વર્ટિકલ ગ્લાઇડ; બેકગ્રાઉન્ડ લિનન શેડ સ્મૂધલી શિફ્ટ થાય છે | `selectionClick` |
| `m151_stair_traverse` | `lane_warp` | સ્ટીલ સ્પૂલ સીડી ગોળ ફરે છે; સોય સીડીમાં પ્રવેશી લક્ષ્ય ફ્લોર પર સ્પાર્કલ સાથે પ્રગટ થાય છે | `lightImpact` |
| `m152_organza_tap` | `morph_flash` | ઓર્ગેન્ઝા કાપડ પર નાની સિલ્ક રિપલ રિંગ; નીચેનો દોરો હાઇલાઇટ થઈને ખેંચાય છે | `selectionClick` |
| `m153_drop_hole` | `dust_puff` + `lane_warp` | દોરો કાણામાં સરકીને નીચે ડ્રોપ થાય છે; કાણામાંથી 4 નાના વૂલ ટફ્ટ્સ ઉડે છે | `lightImpact` |
| `m154_lift_operate` | `state_toggle` | લાકડાની બોબિન લિફ્ટ કેબલ ટેન્શન સાથે ઊંચી/નીચી થાય છે; રેચેટ ક્લિક સાઉન્ડ | `mediumImpact` |

### Tier Budgets
- **Low Tier:** એક સમયે માત્ર સક્રિય ફ્લોર જ મેમરીમાં ડ્રો થાય છે (અન્ય ફ્લોર્સ હાઇડ); મહત્તમ 30 પાર્ટીકલ્સ; 0 dp શેક.
- **Mid Tier:** બેકગ્રાઉન્ડ ફ્લોર બ્લર વગર લો-રેઝોલ્યુશનમાં કેશ્ડ; 80 પાર્ટીકલ્સ; 4 dp શેક.
- **High Tier:** ત્રણેય ફ્લોર્સ સંપૂર્ણ સ્મૂધ ગ્લાઇડ અને ડેપ્થ શેડો સાથે સક્રિય; 150 પાર્ટીકલ્સ; 6 dp શેક.

---

## 3. QA Checklist (Phase 4)
- **QA-P4-01 (Floor Switcher):** F1/F2/F3 ટેબ્સથી કેમેરા સાચા ફ્લોર પર સ્વિચ થાય છે; 0 Moves ખર્ચ થાય છે.
- **QA-P4-02 (M151 Stairs):** સીડીમાં પ્રવેશેલો દોરો લક્ષ્ય ફ્લોર પર સમાન (x, y) અને દિશામાં સાચી રીતે અનરૅવલ થાય છે.
- **QA-P4-03 (M152 Organza):** ઓર્ગેન્ઝા સેલ નીચે રહેલા દોરાઓ ઉપરથી જોઈ અને ટેપ કરી શકાય છે.
- **QA-P4-04 (M153 Drop Hole):** દોરો કાણા પર પહોંચી નીચેના ફ્લોર પર રિલોકેટ થાય છે (1 Move ખર્ચ).
- **QA-P4-05 (M154 Bobbin Lift):** લિફ્ટ પર સોય ઊભી હોય ત્યારે ટેપ કરવાથી દોરો અન્ય ફ્લોર પર જાય છે.
- **QA-P4-06 (All Floors Clear Win):** ત્રણેય ફ્લોર્સ સંપૂર્ણ ક્લિયર થાય ત્યારે જ જીત જાહેર થાય છે.
- **QA-P4-07 (0-Hearts Solvability):** L1501–2000 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P4-08 (Memory Budget):** 3 ફ્લોર્સ રેન્ડર થવા છતાં લો-ટિયર ડિવાઇસ પર RSS મેમરી <= 250 MB રહે છે.
- **QA-P4-09 (Remote Config):** `maxPhase < 4` પર Phase 4 નોડ્સ લોક રહે છે.
- **QA-P4-10 (Review & Finale):** L1991 રિવ્યૂ લેવલ અને L2000 "The Three-Tier Quilt" ત્રણેય ફ્લોર્સ સાથે યોગ્ય રીતે ચાલે છે.

