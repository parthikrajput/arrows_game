# 04 — Variants & Modifiers: Phase 9
> Phase 9 ના 45 variant slots, Ply & Twist craft modifiers ના નિયમો અને M401–M404 સાથેના combinations.

**Related docs:** [Phase 9 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_4001_4500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Split & Merge Craft Modifiers
Phase 9 ના 10 craft modifiers સ્પ્લિટ અને મર્જ મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | Ply & Twist નિયમ |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | ટ્વિસ્ટિંગ પેડ કે સ્પ્લિટ ટાઇલ લૉક છે; K પડોશી દોરા બહાર નીકળે પછી જ સક્રિય થાય છે. |
| 2 | `Colored(c)` | **Dyed** | મર્જિંગ પેડ માત્ર c કલરના બે દોરાઓને જ જોડે છે; અન્ય કલર માટે ઇનર્ટ રહે છે. |
| 3 | `Fluffed` | **Fluffed** | સ્ટીચ લૉક કે રીજોઈન ગેટ વૂલ ફ્લફ નીચે છુપાયેલો છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે સ્પ્લિટર્સ જોડાયેલા છે; એકમાં દોરો પ્રવેશતાં બંને સ્પ્લિટર્સ એકસાથે ઓપરેટ થાય છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ સુધીમાં જો મર્જિંગ ન થાય, તો ટ્વિસ્ટિંગ પેડ બોર્ડ પરથી અદૃશ્ય થાય છે. |
| 6 | `Phasing` | **Sheer Silk** | રીજોઈન ગેટ ઓડ મૂવ્સ પર સોલિડ બ્લોકર અને ઇવન મૂવ્સ પર ફેન્ટમ બને છે. |
| 7 | `Armored` | **Brass-Plated** | સ્ટીચ લૉક હેમરેબલ નથી; માત્ર કી-થ્રેડ એક્ઝિટ દ્વારા જ અનલૉક થાય છે. |
| 8 | `Layered` | **Tulle** | સ્પ્લિટિંગ માત્ર કાપડના લેયર 1 પર થાય છે, લેયર 2 ના દોરા સીધા પસાર થાય છે. |
| 9 | `Mirrored` | **Mirror-Stitched** | ડાબી બાજુનો સ્પ્લિટિંગ પાથ જમણી બાજુના સ્પ્લિટિંગ પાથ સાથે મિરર થાય છે. |
| 10 | `Growing` | **Ply-Expanding** | સ્પ્લિટ થયેલો અડધો દોરો દર 3 મૂવ્સમાં પોતાની લંબાઈમાં 1 નોડ ઉમેરે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L4021–4130):** M401 Twisting Pad Variants (Knotted Pad, Colored Merge, Basting Pad, વગેરે).
- **Blocks 15–25 (L4141–4250):** M402 Double Split Variants (Fluffed Splitters, Ribbon-Tied Double Splits, Sheer Splits, વગેરે).
- **Blocks 27–37 (L4261–4370):** M403 Stitch Lock Variants (Brass-Plated Stitch Locks, Mirrored Segment Locks, વગેરે).
- **Blocks 39–49 (L4381–4490):** M404 Rejoin Gate Variants અને Complex Ply & Twist Combinations (M401 + M402 + M404 સંયોજનો).

---

## 3. Solver Invariants
- સ્પ્લિટ થયેલા બંને અર્ધભાગો માટે પૂરતો રસ્તો હોવો આવશ્યક છે જેથી કોઈ કાયમી ટાઈ-ડેડલોક ન સર્જાય.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે 100% સોલ્વેબલ છે.

