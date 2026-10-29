# 06 — UI & QA: Phase 16
> Keys Deluxe (Jewel Box) વિઝ્યુઅલ્સ, કી ક્રાફ્ટિંગ એનિમેશન, સ્કેલેટન ચાર્મ VFX, ટિયર લિમિટ્સ, રેન્ડરિંગ પર્ફોર્મન્સ બજેટ અને Phase 16 QA Checklist.

**Related docs:** [Phase 16 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md)

---

## 1. Visual Design & Charm Rendering
- **Jeweled Charms Aesthetics:**
  - સોનાના નાના લોકેટ્સ અને રત્નજડિત બટન્સ જે સોયના માથા પર ચમકે છે.
  - ચાર્મ ચેઇન્સ પર નાના સુવર્ણ આંકડા ($1, 2, 3$) સ્પષ્ટ રીતે પ્રદર્શિત થાય છે.
- **Key Forging Animation:**
  - બે હાફ-ચાર્મ્સ સ્ક્રીનની મધ્યમાં આવીને 220 ms માં સ્પાર્કલ્સ સાથે જોડાય છે અને ગોલ્ડન ગ્રાન્ડ કીમાં રૂપાંતરિત થાય છે.
- **Skeleton Key Mastery:**
  - સ્કેલેટન કી દોરાના માથા પર ચમકતી ગોલ્ડન માસ્ટર કી જે પસાર થતાં કોઈપણ કલર્ડ ક્લેસ્પને ઓટો-અનલૉક કરે છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `m751_chain_step` | `counter_pop` | આગામી ચાર્મ ટેપ-સક્ષમ બને છે; ગોલ્ડન બેજ શિમર | `selectionClick` |
| `m752_craft_forge` | `morph_flash` + `sparkle_stream` | બંને અર્ધભાગો જોડાઈને સોનેરી કી બને છે; ભવ્ય સ્પાર્કલ્સ બર્સ્ટ | `heavyImpact` |
| `m753_skeleton_unlock` | `key_unlock` | સ્કેલેટન કી કોઈપણ ક્લેસ્પને સ્નેપ ઓપન કરે છે | `mediumImpact` |
| `m754_color_swap` | `lane_warp` | સ્વેપ હૂપ ટેપ થતાં બંને દોરાઓના કી કલર્સ ચમકીને બદલાય છે | `lightImpact` |

### Tier Budgets
- **Low Tier:** સિમ્પલ ઇન્સ્ટન્ટ કી અનલૉક; મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 200 ms ક્રાફ્ટિંગ સ્પાર્ક્સ અને ગોલ્ડન ફ્લેશ; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** સંપૂર્ણ જ્વેલ્ડ શિમર, કી ફોર્જિંગ લાઈટ બર્સ્ટ અને ડસ્ટ ટ્રેલ્સ; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 16)
- **QA-P16-01 (Charm Chain):** ચાર્મ્સ માત્ર નિર્ધારિત ક્રમ ($1 \to 2 \to 3$) માં જ કલેક્ટ થાય છે; ક્રમ તૂટતાં લૉક્ડ ટેપ રિસ્પોન્સ મળે છે.
- **QA-P16-02 (Charm Crafting):** બંને હાફ-ચાર્મ દોરા બહાર નીકળતાં જ કમ્પ્લીટ કી ફોર્જ થાય છે અને ગ્રાન્ડ ક્લેસ્પ ખુલે છે.
- **QA-P16-03 (Skeleton Charm):** સ્કેલેટન કી કોઈપણ રંગના ક્લેસ્પને કોઈપણ કલર મેચિંગ વગર અનલૉક કરે છે.
- **QA-P16-04 (Charm Swap Hoop):** સ્વેપ હૂપ ટેપ થતાં જ 1 Move વપરાય છે અને લિંક થયેલા દોરાઓના કી કલર્સ પરસ્પર બદલાય છે.
- **QA-P16-05 (0-Hearts Solvability):** L7501–8000 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P16-06 (Performance):** જ્વેલ્ડ ચાર્મ્સ અને ફોર્જિંગ એનિમેશન છતાં લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
- **QA-P16-07 (Remote Config):** `maxPhase < 16` પર Phase 16 નોડ્સ લૉક રહે છે.
- **QA-P16-08 (Review & Finale):** L7991 રિવ્યૂ લેવલ અને L8000 "The Master Jewel Box" સંપૂર્ણ રીતે રમી શકાય છે.

