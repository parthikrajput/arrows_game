# 06 — UI & QA: Phase 11
> Linked Boards (Twin Hoops) વિઝ્યુઅલ્સ, ક્રોસ-હૂપ કેમેરા સ્માર્ટ ફ્રેમિંગ, સીમ એજ VFX, ટિયર લિમિટ્સ, રેન્ડરિંગ પર્ફોર્મન્સ બજેટ અને Phase 11 QA Checklist.

**Related docs:** [Phase 11 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md)

---

## 1. Visual Design & Twin Hoops Framing
- **Twin Hoops Camera Framing:**
  - બંને એમ્બ્રોઇડરી હૂપ્સ (Hoop A અને Hoop B) સ્ક્રીન પર સ્પષ્ટ રીતે દેખાય તે માટે સ્માર્ટ ડ્યુઅલ-વ્યૂ પોર્ટ્રેઇટ લેઆઉટ.
  - ખેલાડી એક હૂપ પરથી બીજા હૂપ પર સ્મૂધલી સ્લાઇડ કરી શકે છે અથવા પિંચ કરીને બંનેને એકસાથે જોઈ શકે છે.
- **Seam Edge Visuals:**
  - બંને હૂપ્સ વચ્ચે ગોલ્ડન સિલાઇનો ટાંકો (Zig-zag Stitch) જે દોરો પસાર થતાં શિમર કરે છે.
- **Relay Pompom Portals:**
  - બે મેચિંગ કલરના રુંવાટીદાર ઊનના પોમપોમ્સ જે એકબીજા સાથે જાદુઈ દોરા વડે જોડાયેલા હોવાનો ભાસ કરાવે છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `m501_seam_warp` | `lane_warp` | દોરો સીમમાંથી પસાર થઈને બીજા હૂપમાં પ્રવેશે છે; ઝિગ-ઝેગ સ્ટીચ શિમર | `lightImpact` |
| `m502_cross_key_unlock` | `key_unlock` + `sparkle_stream` | Hoop A પરથી કી નીકળતાં Hoop B નો ક્લેસ્પ તેજસ્વી સ્પાર્કલ્સ સાથે અનલૉક | `mediumImpact` |
| `m503_mirror_sync` | `morph_flash` | Hoop A અને Hoop B પર બંને ટ્વીન દોરાઓ એકસાથે સમાંતર અનરૅવલ થાય છે | `mediumImpact` |
| `m504_relay_jump` | `pompom_poof` | દોરો પોમપોમમાં અદૃશ્ય થાય છે અને બીજા પોમપોમમાંથી પોપ થઈને બહાર નીકળે છે | `lightImpact` |

### Tier Budgets
- **Low Tier:** સિમ્પલ ઇન્સ્ટન્ટ ક્રોસ-બોર્ડ ટ્રાન્ઝિશન; મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 200 ms સીમ ગ્લાઇડ એનિમેશન; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** સંપૂર્ણ ટ્વીન પોમપોમ સ્મોક પફ, ઝિગ-ઝેગ ગોલ્ડન થ્રેડ શિમર; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 11)
- **QA-P11-01 (Seam Edge):** Hoop A માંથી સીમ દ્વારા નીકળતો દોરો Hoop B ની યોગ્ય રો/કૉલમ અને સમાન દિશામાં બરાબર પ્રવેશે છે.
- **QA-P11-02 (Blocked Seam):** જો Hoop B નો ટાર્ગેટ સેલ બ્લોક હોય, તો દોરો સીમ પર સ્નેગ થઈને પાછો વળે છે (-1 Heart).
- **QA-P11-03 (Cross Charm):** Hoop A પરનો કી દોરો ક્લિયર થતાં જ Hoop B નો સંબંધિત ક્લેસ્પ ઓપન થાય છે.
- **QA-P11-04 (Mirror Hoop):** ટ્વીન દોરાઓ સાથે ટેપ થાય છે; જો કોઈ એક બ્લોક હોય તો બંને સ્નેગ થાય છે અને માત્ર 1 Heart જ કપાય છે.
- **QA-P11-05 (0-Hearts Solvability):** L5001–5500 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P11-06 (Dual Board Performance):** બે હૂપ્સ એકસાથે રેન્ડર થતાં છતાં લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
- **QA-P11-07 (Remote Config):** `maxPhase < 11` પર Phase 11 નોડ્સ લૉક રહે છે.
- **QA-P11-08 (Review & Finale):** L5491 રિવ્યૂ લેવલ અને L5500 "The Twin Hoops Symphony" સંપૂર્ણ રીતે રમી શકાય છે.

