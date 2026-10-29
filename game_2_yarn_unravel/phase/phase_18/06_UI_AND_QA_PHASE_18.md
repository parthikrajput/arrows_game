# 06 — UI & QA: Phase 18
> Remix A વિઝ્યુઅલ્સ, કમ્પોઝિટ મલ્ટિ-સિસ્ટમ VFX, ટિયર લિમિટ્સ, રેન્ડરિંગ પર્ફોર્મન્સ બજેટ અને Phase 18 QA Checklist.

**Related docs:** [Phase 18 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md)

---

## 1. Visual Design & Composite UI
- **Multi-System HUD:**
  - સ્ક્રીનના ઉપરના ભાગમાં ડે/નાઈટ સાયકલ ટાઈમર અને મલ્ટિ-ફ્લોર સ્વિચર બંને એકસાથે કોમ્પેક્ટ સ્વરૂપે સુમેળથી ગોઠવાયેલા હોય છે.
- **Layer & Optical Depth:**
  - ફ્લોર બીમ જ્યારે પારદર્શક ઓર્ગેન્ઝા ફેબ્રિકમાંથી નીચે પસાર થાય છે ત્યારે સોફ્ટ 3D પેરાલેક્સ ડેપ્થ ઇફેક્ટ રેન્ડર થાય છે.
- **Satin Charm Crate Glow:**
  - સોનેરી ચાર્મ ધરાવતો સાટિન ક્રેટ ચમકતી ગોલ્ડન બોર્ડર સાથે સ્લાઇડ થાય છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `m851_cycle_crate_push` | `spool_roll` + `lane_warp` | સાયકલ ક્રેટ સરકે છે; ડે/નાઈટ સ્ટેટ મુજબ વૂડન ક્લિક | `mediumImpact` |
| `m852_floor_beam_pass` | `sparkle_stream` | લાઈટ બીમ માળ પાર કરે છે; બંને માળે ગોલ્ડન પ્રિઝમ સ્પાર્ક્સ | `lightImpact` |
| `m853_fogged_stair_reveal`| `pompom_poof` + `gate_open` | સીડી પરથી વૂલ ફ્લફ હટી જાય છે અને સીડી પ્રગટ થાય છે | `mediumImpact` |
| `m854_satin_unlock` | `key_unlock` + `morph_flash` | સાટિન ક્રેટ ક્લેસ્પ સાથે અથડાતાં લૉક સ્નેપ ઓપન થાય છે | `heavyImpact` |

### Tier Budgets
- **Low Tier:** સિમ્પલ ઇન્સ્ટન્ટ સ્લાઇડ્સ અને બીમ રેન્ડર; મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 180 ms પેરાલેક્સ એનિમેશન; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** સંપૂર્ણ મલ્ટિ-લેયર ઑપ્ટિકલ શેડર્સ, વૂલ ડસ્ટ પફ અને ક્રેટ સ્લાઇડ શેડોઝ; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 18)
- **QA-P18-01 (Cycle Crate):** સાયકલ ક્રેટ માત્ર માન્ય સ્ટેટમાં જ ધકેલી શકાય છે; અમાન્ય સ્ટેટમાં સિંગલ બ્લોકર તરીકે રહે છે.
- **QA-P18-02 (Floor Beam):** બીમ પારદર્શક માળમાંથી નીચે પસાર થઈને લક્ષિત સન-કેચરને સચોટ પ્રકાશિત કરે છે.
- **QA-P18-03 (Fogged Stair):** દોરો પસાર થતાં જ ફોગ સાફ થાય છે અને સીડી કાયમી દૃશ્યમાન રહે છે.
- **QA-P18-04 (Satin Charm Crate):** સાટિન ક્રેટ સ્લાઇડ થઈને લક્ષિત ક્લેસ્પ પર પહોંચતાં જ ક્લેસ્પ ઓપન થાય છે.
- **QA-P18-05 (0-Hearts Solvability):** L8501–9000 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P18-06 (Multi-System Performance):** મલ્ટિપલ સિસ્ટમ્સ (બીમ્સ + ક્રેટ્સ + સાયકલ્સ) સક્રિય હોવા છતાં લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
- **QA-P18-07 (Remote Config):** `maxPhase < 18` પર Phase 18 નોડ્સ લૉક રહે છે.
- **QA-P18-08 (Review & Finale):** L8991 રિવ્યૂ લેવલ અને L9000 "The Grand Atelier Loom" સંપૂર્ણ રીતે રમી શકાય છે.
