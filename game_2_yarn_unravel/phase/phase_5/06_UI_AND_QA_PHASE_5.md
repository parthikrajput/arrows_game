# 06 — UI & QA: Phase 5
> Crate Workshop વિઝ્યુઅલ્સ, કાઇનેટિક VFX, ટિયર લિમિટ્સ, પુશ ફિઝિક્સ પર્ફોર્મન્સ બજેટ અને Phase 5 QA Checklist.

**Related docs:** [Phase 5 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md)

---

## 1. Visual Design & Crate Styling
- **Notions Crates (સામાન્ય ક્રેઇટ્સ):** બોર્ડના લિનન સાથે મેચ થતા હળવા પાઇન લાકડાના 1-સેલ બોક્સિસ, જેના પર નાની સ્ટીલની હેન્ડલ પિન લાગેલી છે.
- **Satin Crates (M202):** ચળકતા પિંક/સિલ્વર સાટિન ફેબ્રિકમાં વીંટાળેલી સ્મૂધ ક્રેઇટ, જે લપસતી વખતે સોફ્ટ ગ્લો કરે છે.
- **Charm Crates (M203):** ક્રેઇટની ટોચ પર મેચિંગ કલરનું ગોલ્ડન એમ્બોસ્ડ ચાર્મ પ્રતીક.
- **Iron Crates (M204):** ઘેરા સ્ટીલ રંગની ભારે કાસ્ટ આયર્ન ક્રેઇટ, રિવેટ્સ અને હેવી વજન પ્રતીક સાથે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `crate_push_step` | `dust_puff` | લાકડાની ક્રેઇટ લિનન પર સરકે છે; 4 નાના લાકડાના છોલ અને ધૂળના પાર્ટીકલ્સ | `lightImpact` |
| `m201_pit_fill` | `lane_warp` + `dust_puff` | ક્રેઇટ પિટમાં સમાઈ જાય છે; કાપડ સપાટ થતાં ગોલ્ડન સ્ટીચ રિપલ | `mediumImpact` |
| `m202_satin_slide` | `lane_warp` | સાટિન ક્રેઇટ સતત લપસે છે; પાછળ સિલ્કી સ્લાઇડિંગ ટ્રેઇલ સ્પાર્કલ્સ | `lightImpact` |
| `m203_charm_unlock` | `state_toggle` | ચાર્મ ક્લેસ્પમાં ફિટ થઈને સોનેરી સ્પાર્કલ્સ સાથે ક્રેઇટ અદૃશ્ય થાય છે | `mediumImpact` |
| `m204_iron_push` | `blocker_hit_hard` + `dust_puff` | હેવી આયર્ન ક્રેઇટ ભારે અવાજ સાથે ખસે છે; નાની મેટાલિક સ્પાર્ક | `heavyImpact` |
| `iron_snag_failed` | `bump_flash` | સામાન્ય દોરો અથડાતાં આયર્ન ક્રેઇટ અડગ રહે છે; દોરો જોરદાર twang સાથે પાછો વળે છે | `mediumImpact` |

### Tier Budgets
- **Low Tier:** મહત્તમ 30 લાઈવ પાર્ટીકલ્સ; ક્રેઇટ સ્લાઇડિંગ મોશન બ્લર ઓફ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** મહત્તમ 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** મહત્તમ 150 પાર્ટીકલ્સ; ફુલ ડસ્ટ પફ અને સિલ્કી ટ્રેઇલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 5)
- **QA-P5-01 (Standard Push):** દોરો અનરૅવલ થતાં સામેની ક્રેઇટને પાછળ ખાલી સેલ હોય તો જ 1 સેલ આગળ ધકેલે છે.
- **QA-P5-02 (Blocked Crate Snag):** ક્રેઇટ પાછળ અવરોધ હોય તો ક્રેઇટ ખસતી નથી અને દોરો સ્નેગ થાય છે (-1 Heart).
- **QA-P5-03 (M201 Crate Pit):** ક્રેઇટ પિટમાં પડતાં પિટ ભરાઈને સામાન્ય ક્લિયર ફ્લોર બની જાય છે.
- **QA-P5-04 (M202 Satin Crate):** સાટિન ક્રેઇટ જ્યાં સુધી કોઈ બ્લોકર ન આવે ત્યાં સુધી સતત લપસીને આગળ વધે છે.
- **QA-P5-05 (M203 Charm Crate):** ચાર્મ ક્રેઇટ મેચિંગ ક્લેસ્પ પર પહોંચતાં ક્લેસ્પ કાયમી અનલૉક થાય છે અને ક્રેઇટ ક્લિયર થાય છે.
- **QA-P5-06 (M204 Iron Crate):** માત્ર Chunky Chenille અથવા Ribbon Pairs જ આયર્ન ક્રેઇટ ધકેલી શકે છે; સામાન્ય દોરો સ્નેગ થાય છે.
- **QA-P5-07 (0-Hearts Solvability):** L2001–2500 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P5-08 (Performance):** 14×14 ગ્રીડ પર 6 ક્રેઇટ્સ અને 40 દોરાઓ સાથે 2 GB RAM વાળા ફોન પર 60 fps જળવાય છે.
- **QA-P5-09 (Remote Config):** `maxPhase < 5` પર Phase 5 નોડ્સ લોક રહે છે.
- **QA-P5-10 (Review & Finale):** L2491 રિવ્યૂ લેવલ અને L2500 "Master Workshop Tapestry" સફળતાપૂર્વક રમી શકાય છે.

