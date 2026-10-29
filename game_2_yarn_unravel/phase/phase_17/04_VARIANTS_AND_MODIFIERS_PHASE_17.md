# 04 — Variants & Modifiers: Phase 17
> Phase 17 ના 45 variant slots, Guardians craft modifiers ના નિયમો અને M801–M804 સાથેના combinations.

**Related docs:** [Phase 17 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_8001_8500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Guardians Craft Modifiers
Phase 17 ના 10 craft modifiers ગાર્ડિયન મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | Guardians નિયમ |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | પિનકુશન ગાર્ડિયન લૉક છે; K દોરા બહાર નીકળે પછી જ તેની પિન ખેંચી શકાય છે. |
| 2 | `Colored(c)` | **Dyed** | ગાર્ડિયન માત્ર c રંગના દોરાઓ દ્વારા જ ડેમેજ મેળવી શકે છે. |
| 3 | `Fluffed` | **Fluffed** | ગાર્ડિયનનું હાર્ટ સેલ વૂલ ફ્લફ નીચે છુપાયેલું છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે ગાર્ડિયન્સ રિબનથી જોડાયેલા છે; બંનેનું HP સરખું રહે છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી ગાર્ડિયન આપોઆપ સંકોચાઈને ક્લિયર થઈ જાય છે. |
| 6 | `Phasing` | **Sheer Silk** | આર્મર્ડ શિલ્ડ ઓડ મૂવ્સ પર સોલિડ અને ઇવન મૂવ્સ પર ફેન્ટમ બને છે. |
| 7 | `Armored` | **Double-Plated** | પિનકુશન 2 ગણું મજબૂત છે અને વધારાના HP સ્તરો ધરાવે છે. |
| 8 | `Layered` | **Tulle** | ગાર્ડિયન માત્ર કાપડના ચોક્કસ લેયરના દોરાઓથી જ પ્રભાવિત થાય છે. |
| 9 | `Mirrored` | **Mirror-Stitched** | ગાર્ડિયન ડેમેજ મેળવતાં મિરર અક્ષ પર તેની પ્રતિકૃતિ પણ ડેમેજ મેળવે છે. |
| 10 | `Growing` | **Pin-Regenerating** | દર 6 મૂવ્સ પછી જો ડેમેજ ન મળે તો ગાર્ડિયન +1 HP પુનઃપ્રાપ્ત કરે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L8021–8130):** M801 Twin Pincushions Variants (Knotted Guardians, Dyed Twins, Phasing Twins, વગેરે).
- **Blocks 15–25 (L8141–8250):** M802 Armoured Pincushion Variants (Fluffed Shields, Basting Levers, Double-Plated Shields, વગેરે).
- **Blocks 27–37 (L8261–8370):** M803 Seeding Pincushion Variants (Chained Spawners, Fast Sprouters, Tulle Spawners, વગેરે).
- **Blocks 39–49 (L8371–8490):** M804 Heart Pincushion Variants અને Royal Court Multi-Guardian Battles (M801 + M802 + M804 સંયોજનો).

---

## 3. Solver Invariants
- ગાર્ડિયન સ્પૉનિંગથી ક્યારેય અનિવાર્ય ડેડલોક ન સર્જાય તે માટે સ્પૉન રેટ કાઉન્ટર પૂરતી વિન્ડો પૂરી પાડે છે.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે 100% સોલ્વેબલ છે.

