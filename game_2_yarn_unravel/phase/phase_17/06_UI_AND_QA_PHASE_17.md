# 06 — UI & QA: Phase 17
> Guardians (Pincushion Court) વિઝ્યુઅલ્સ, પિનકુશન HP બાર્સ, ડેમેજ ઇમ્પેક્ટ VFX, ટિયર લિમિટ્સ, રેન્ડરિંગ પર્ફોર્મન્સ બજેટ અને Phase 17 QA Checklist.

**Related docs:** [Phase 17 index](./README.md) · [VFX Implementation §4](../../VFX_IMPLEMENTATION.md) · [Performance Optimization §3](../../PERFORMANCE_OPTIMIZATION.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md)

---

## 1. Visual Design & Pincushion Bosses
- **Royal Velvet Pincushions:**
  - જાંબલી/લાલ મખમલ ફેબ્રિક પર સોનાની ઝૂલ સાથેના મોટા ગાર્ડિયન્સ, જેમાં રંગબેરંગી મોતીવાળી પિનો ખૂંપેલી દેખાય છે.
  - દરેક પિનકુશન પર નાનો સોનેરી HP બેજ પ્રદર્શિત થાય છે જે બાકી રહેલી પિનોની સંખ્યા દર્શાવે છે.
- **Pin Extraction Dynamics:**
  - દોરો નજીકથી પસાર થતાં 1 પિન પિનકુશનમાંથી ખેંચાઈને હવામાં સોનેરી સ્પાર્ક સાથે ઓગળી જાય છે.
- **Armoured Shield Glow:**
  - પિત્તળની શીલ્ડ સક્રિય હોય ત્યારે પિનકુશન ફરતે ગોળાકાર શિલ્ડ ફોર્સ-ફિલ્ડ પ્રગટ થાય છે.

---

## 2. Visual Effects (VFX) Mapping
VFX_IMPLEMENTATION.md §4.4 મુજબ ક્લાસીસનું પુનઃઉપયોગ:

| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `m801_pin_extract` | `counter_pop` + `burst_sparks` | પિનકુશનમાંથી પિન ખેંચાય છે; સોનેરી સ્પાર્કલ્સ અને HP ડ્રોપ | `mediumImpact` |
| `m801_guardian_collapse` | `gate_open` + `morph_flash` | HP 0 થતાં પિનકુશન સંકોચાઈને સુંદર રેશમી રિબન બનીને ઓગળી જાય છે | `heavyImpact` |
| `m802_shield_deflect` | `blocked_bump` | શિલ્ડ પર દોરો અથડાતાં મેટાલિક રિંગ સાઉન્ડ અને સ્પાર્ક્સ | `rigidImpact` |
| `m803_button_spawn` | `grow_burst` | પિનકુશનમાંથી નવું લાકડાનું બટન સ્પ્રાઉટ થાય છે | `lightImpact` |

### Tier Budgets
- **Low Tier:** સિમ્પલ ઇન્સ્ટન્ટ HP ડિક્રીમેન્ટ; મહત્તમ 30 પાર્ટીકલ્સ; 0 dp સ્ક્રીન શેક.
- **Mid Tier:** 200 ms પિન-પુલ એનિમેશન અને સ્પાર્ક્સ; 80 પાર્ટીકલ્સ; 4 dp સ્ક્રીન શેક.
- **High Tier:** સંપૂર્ણ વેલ્વેટ ટેક્સચર રિપલ, પિન-એક્સ્ટ્રેક્શન ડસ્ટ અને ગાર્ડિયન ડિસપિયરન્સ બર્સ્ટ; 150 પાર્ટીકલ્સ; 6 dp સ્ક્રીન શેક.

---

## 3. QA Checklist (Phase 17)
- **QA-P17-01 (Pincushion HP):** પિનકુશનના અડીને આવેલા સેલમાંથી દોરો નીકળતાં સચોટ -1 HP ઘટે છે.
- **QA-P17-02 (Twin Guardians):** જોડિયા પિનકુશન્સ વચ્ચે સંયુક્ત HP પૂલ શેર થાય છે; બંનેમાંથી ગમે તેની પાસેથી દોરો નીકળે તો સંયુક્ત HP ઘટે છે.
- **QA-P17-03 (Armoured Shield):** લીવર શિલ્ડેડ હોય ત્યાં સુધી પિનકુશનને કોઈ ડેમેજ લાગતું નથી.
- **QA-P17-04 (Seeding Pincushion):** દર 4 મૂવ્સ પછી નિયુક્ત પ્રાધાન્યતા સાથે ખાલી સેલમાં બટન સ્પૉન થાય છે.
- **QA-P17-05 (Heart Core):** હાર્ટ પિનકુશનનું HP માત્ર ત્યારે જ ઘટે છે જો લાઇટ બીમ તેના કોર સેલ પર કેન્દ્રિત હોય.
- **QA-P17-06 (0-Hearts Solvability):** L8001–8500 ના તમામ લેવલ્સ 0 hearts અને 0 boosters સાથે સોલ્વેબલ છે.
- **QA-P17-07 (Performance):** 3×3 ગાર્ડિયન્સ અને મલ્ટિપલ સ્પૉન્સ છતાં લો-ટિયર 2 GB RAM ડિવાઇસ પર 60 fps જળવાય છે.
- **QA-P17-08 (Remote Config):** `maxPhase < 17` પર Phase 17 નોડ્સ લૉક રહે છે.
- **QA-P17-09 (Review & Finale):** L8491 રિવ્યૂ લેવલ અને L8500 "The Pincushion Sovereign" સંપૂર્ણ રીતે રમી શકાય છે.

