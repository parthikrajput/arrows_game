# 06 — UI & QA: Phase 15
> Conveyors & Tracks (Feed Dog Factory) વિઝ્યુઅલ્સ, બેલ્ટ ટ્રેડ એનિમેશન, ગિયર મિકેનિક્સ VFX, ટિયર લિમિટ્સ, રેન્ડરિંગ પર્ફોર્મન્સ બજેટ અને Phase 15 QA Checklist.

**Related docs:** [Phase 15 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md)

---

## 1. Visual Design & Conveyor Motion
- **Feed Dog Tread Texture:**
  - લિનન ક્રાફ્ટ બોર્ડ પર સ્ટીલના નાના દાંતાવાળા બેલ્ટ્સ જે મૂવ્સ સાથે આગળ વધતા હોય તેવા ગતિશીલ શેવરોન માર્કર્સ ($\gg$) દર્શાવે છે.
  - દિશા બદલાતી વખતે બેલ્ટ પર લાલ-લીલી ફ્લિપ ફ્લેશ થાય છે.
- **Track Loop Circuit:**
  - ગોળાકાર સ્ટીચ લૂપ જેમાં નિયુક્ત એક્ઝિટ સેલ પર સોનેરી એમ્બ્રોઇડરી એરો સતત પલ્સ કરે છે.
- **Clutch Lever Visuals:**
  - લાકડાનું યાંત્રિક લીવર જે ચાલુ સ્થિતિમાં ગ્રીન ઇન્ડિકેટર અને બંધ સ્થિતિમાં રેડ વૂડન સ્ટોપર દર્શાવે છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `m701_switch_toggle` | `lane_warp` | સ્વિચ ફરે છે; બેલ્ટ જંકશનનો એરો સ્નેપ થઈને નવી દિશા પકડે છે | `selectionClick` |
| `m702_belt_reverse` | `morph_flash` | રિવર્સિંગ બેલ્ટની દિશા ઊંધી થાય છે; ગિયર સ્પીન ક્લેક | `mediumImpact` |
| `m703_lever_click` | `counter_pop` | ક્લચ લીવર ખેંચાય છે; બેલ્ટ્સ અટકે છે અથવા ચાલુ થાય છે | `lightImpact` |
| `m704_loop_step` | `spool_roll` | દોરો ટ્રેક લૂપ પર 1 સેલ આગળ સરકે છે; સ્મૂધ વૂલ સ્લાઇડ | `lightImpact` |

### Tier Budgets
- **Low Tier:** સિમ્પલ ઇન્સ્ટન્ટ બેલ્ટ શિફ્ટ; મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 180 ms સ્લાઇડ ટ્રેડ એનિમેશન; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** સંપૂર્ણ મિકેનિકલ ફીડ ડોગ ટ્રેડ મોશન, ગિયર ક્લેક્સ અને સોફ્ટ યાર્ન શેડોઝ; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 15)
- **QA-P15-01 (Feed Dog Conveyors):** બેલ્ટ પર સ્થિત દોરાઓ દરેક વેલિડ મૂવના અંતે દિશા મુજબ 1 સેલ આગળ ખસે છે જો આગળનો સેલ મુક્ત હોય.
- **QA-P15-02 (Belt Switch):** સ્વિચ ટેપ થતાં જ 1 Move વપરાય છે અને કન્વેયર નવી શાખા તરફ સચોટ દોરાઓને વાળે છે.
- **QA-P15-03 (Reversing Belt):** દર N મૂવ્સે બેલ્ટની દિશા 180° ફ્લિપ થાય છે અને કાઉન્ટડાઉન બેજ સચોટ અપડેટ થાય છે.
- **QA-P15-04 (Track Loop):** ટ્રેક પરનો દોરો સતત ફરે છે અને માત્ર તેના એક્ઝિટ સેલ પર પહોંચતાં જ અનરૅવલ થઈ શકે છે.
- **QA-P15-05 (0-Hearts Solvability):** L7001–7500 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P15-06 (Performance):** બહુવિધ સક્રિય કન્વેયર્સ હોવા છતાં લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
- **QA-P15-07 (Remote Config):** `maxPhase < 15` પર Phase 15 નોડ્સ લૉક રહે છે.
- **QA-P15-08 (Review & Finale):** L7491 રિવ્યૂ લેવલ અને L7500 "The Feed Dog Engine" સંપૂર્ણ રીતે રમી શકાય છે.

