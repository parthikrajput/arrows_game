# 04 — Variants & Modifiers: Phase 13
> Phase 13 ના 45 variant slots, Hidden Info craft modifiers ના નિયમો અને M601–M604 સાથેના combinations.

**Related docs:** [Phase 13 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_6001_6500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Hidden Info Craft Modifiers
Phase 13 ના 10 craft modifiers હિડન ઇન્ફો મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | Hidden Info નિયમ |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | સ્કાઉટ થ્રેડ લૉક છે; K અન્ય દોરાઓ બહાર નીકળે પછી જ ટેપ થઈ શકે છે. |
| 2 | `Colored(c)` | **Dyed** | લેન્ટર્ન પ્લેટ માત્ર ત્યારે જ ગ્લો કરે છે જો c રંગનો દોરો તેના પર બેઠો હોય. |
| 3 | `Fluffed` | **Fluffed** | પેઇન્ટેડ દિવાલ પોતે વધુ જાડા ઊનના સ્તર નીચે છુપાયેલી છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે સ્કાઉટ દોરાઓ જોડાયેલા છે; બંને એકસાથે ક્લિયર થતાં વિશાળ ફોગ વિસ્તાર સાફ થાય છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી ડેકોય ફ્લફ આપોઆપ ઓગળીને સાફ થઈ જાય છે. |
| 6 | `Phasing` | **Sheer Silk** | પેઇન્ટેડ દિવાલ ઓડ મૂવ્સ પર અસલી સોલિડ બ્લોકર અને ઇવન મૂવ્સ પર ભ્રમ બને છે. |
| 7 | `Armored` | **Brass-Plated** | ડેકોય ફ્લફ હેમરેબલ નથી; માત્ર દોરાના સીધા પાસથી જ વિખેરાય છે. |
| 8 | `Layered` | **Tulle** | સ્કાઉટિંગ માત્ર કાપડના ચોક્કસ લેયર પરની રુંવાટી સાફ કરે છે. |
| 9 | `Mirrored` | **Mirror-Stitched** | ડાબી બાજુ ફોગ સાફ થતાં જમણી બાજુનો સમપ્રમાણ વિસ્તાર પણ ઓટો-રિવિલ થાય છે. |
| 10 | `Growing` | **Mist-Expanding** | જો લેન્ટર્ન પ્લેટ પરથી દોરો ખસી જાય, તો દર 5 મૂવ્સે ફોગ ફરી 1 સેલ વિસ્તરે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L6021–6130):** M601 Scout Thread Variants (Knotted Scouts, Chained Scouts, Tulle Scouts, વગેરે).
- **Blocks 15–25 (L6141–6250):** M602 Decoy Fluff Variants (Dyed Decoys, Basting Fluffs, Brass-Plated Decoys, વગેરે).
- **Blocks 27–37 (L6261–6370):** M603 Painted Wall Variants (Phasing Chalks, Mirrored False Walls, વગેરે).
- **Blocks 39–49 (L6381–6490):** M604 Lantern Plate Variants અને Full Mystery Basket Deduction Mix (M601 + M603 + M604 સંયોજનો).

---

## 3. Solver Invariants
- સ્કાઉટિંગ પાથ પહેલાં કોઈ અદૃશ્ય દોરો અજાણતામાં ટેપ કરવાનો ફરજિયાત અનુમાન પ્લેયર પર લાદવામાં આવતો નથી; હંમેશાં દૃશ્યમાન ક્લિયર પાથ મોજૂદ હોય છે.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે 100% સોલ્વેબલ છે.

