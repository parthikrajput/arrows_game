# 06 — UI & QA: Phase 8
> Garden Knitting વિઝ્યુઅલ્સ, વેલાઓના ગ્રોથ VFX, ટિયર લિમિટ્સ, સ્પ્રાઉટિંગ રેન્ડરિંગ પર્ફોર્મન્સ બજેટ અને Phase 8 QA Checklist.

**Related docs:** [Phase 8 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md)

---

## 1. Visual Design & Sprouting Rendering
- **Ivy Yarn Visuals:**
  - આઇવી યાર્ન સેલ્સ ગ્રીન ટ્વિસ્ટેડ વૂલ થ્રેડ અને નાના ક્રોસ-સ્ટીચ પાંદડાઓ સાથે રેન્ડર થાય છે.
  - વિસ્તરણ વખતે નવો સેલ 200 ms માં સોફ્ટ સ્પ્રિંગ-આઉટ ઇઝિંગ સાથે બોર્ડ લિનન પર દોરાય છે.
- **Snip Tile Icons:**
  - નાની સ્ટીલ કાતરનું ગોલ્ડન આઇકોન જે પુલ લાઇન ટચ થતાં 360° સ્નિપ સ્પીન દર્શાવે છે.
- **Blossom Gate Bloom Animation:**
  - બંધ કળીમાંથી 6 ગુલાબી/સફેદ એમ્બ્રોઇડરી પાંખડીઓ ખીલીને સેલની કિનારી પર ગોઠવાઈ જાય છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `m351_ivy_spread` | `grow_burst` | લીલા ઊનનો વેલો પડોશી સેલમાં ફૂટે છે; 4 નાના લીલા વૂલ ફાઇબર પાર્ટીકલ્સ | `lightImpact` |
| `m352_snip_prune` | `hammer_impact` + `lane_warp` | કાતર ઝડપથી સ્નિપ કરે છે; આસપાસના 8 સેલ્સમાંથી કપાયેલા પાંદડા અને ઊન ઉડે છે | `mediumImpact` |
| `m353_seed_drop` | `counter_pop` | સોય બહાર નીકળતાં નાનું લાકડાનું સીડ બીડ ડ્રોપ થાય છે; કાઉન્ટર બેજ '3' પ્રગટ | `selectionClick` |
| `seed_mature_button` | `morph_flash` | સીડ બીડ મોટું થઈને વૂડન બટન (M001) માં રૂપાંતરિત થાય છે | `lightImpact` |
| `m354_blossom_bloom` | `gate_open` | ગુલાબી એમ્બ્રોઇડરી ફૂલ ખીલે છે; સોનેરી પોલેન સ્પાર્કલ્સ સાથે રસ્તો ખુલે છે | `heavyImpact` |

### Tier Budgets
- **Low Tier:** વેલાનું વિસ્તરણ સિમ્પલ 0 ms ડ્રો (નો સ્પ્રાઉટ પાર્ટીકલ્સ); મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 200 ms સ્પ્રાઉટ ગ્રોથ એનિમેશન; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** ફુલ ઓર્ગેનિક લીફ પાર્ટીકલ્સ અને બ્લોસમ પેટલ શાવર; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 8)
- **QA-P8-01 (Ivy Spread):** દર N મૂવ્સ પર આઇવી યાર્ન નિર્ધારિત દિશા પ્રાધાન્યતા સાથે બરાબર 2 ખાલી સેલ્સમાં વિસ્તરે છે.
- **QA-P8-02 (Thread Block):** દોરાનું શરીર જે સેલ પર હોય ત્યાં આઇવી ગ્રોથ પ્રવેશી શકતો નથી.
- **QA-P8-03 (M352 Snip Tile):** પુલ લાઇન ટાઇલ પરથી પસાર થતાં 8 પડોશી સેલ્સના વેલા તાત્કાલિક સાફ થાય છે.
- **QA-P8-04 (M353 Seed Bead):** પૂંછડી પર સીડ બીડ મુકાય છે અને 3 મૂવ્સમાં વૂડન બટન બને છે; દોરો ઉપર આવતાં સીડ કચડાઈ જાય છે.
- **QA-P8-05 (M354 Blossom Gate):** K પડોશી ગ્રોથ સાફ થતાં જ ગેટ કાયમી ઓપન થાય છે.
- **QA-P8-06 (0-Hearts Solvability):** L3501–4000 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P8-07 (Performance):** 14×14 ગ્રીડ પર સક્રિય ગ્રોથ હોવા છતાં લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
- **QA-P8-08 (Remote Config):** `maxPhase < 8` પર Phase 8 નોડ્સ લોક રહે છે.
- **QA-P8-09 (Review & Finale):** L3991 રિવ્યૂ લેવલ અને L4000 "The Blooming Quilt" સંપૂર્ણ રીતે રમી શકાય છે.

