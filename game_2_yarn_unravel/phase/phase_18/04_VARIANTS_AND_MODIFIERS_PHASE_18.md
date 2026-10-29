# 04 — Variants & Modifiers: Phase 18
> Phase 18 ના 45 variant slots, Remix A craft modifiers ના નિયમો અને M851–M854 સાથેના combinations.

**Related docs:** [Phase 18 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_8501_9000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Remix A Craft Modifiers
Phase 18 ના 10 craft modifiers કોમ્બો મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | Remix A નિયમ |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | સાયકલ ક્રેટ લૉક છે; K દોરા બહાર નીકળે પછી જ સાયકલ સાથે સ્વિચ થાય છે. |
| 2 | `Colored(c)` | **Dyed** | ફ્લોર બીમ માત્ર c કલરના કાચમાંથી જ નીચેના માળે પ્રવેશી શકે છે. |
| 3 | `Fluffed` | **Fluffed** | સાટિન ક્રેટનો લક્ષિત ક્લેસ્પ વૂલ ફ્લફ નીચે છુપાયેલો છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે સાયકલ ક્રેટ્સ જોડાયેલા છે; એક ધકેલાતાં બીજો પણ સમાંતર ખસે છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી ફ્લોર બીમ આપોઆપ ઓલવાઈ જાય છે. |
| 6 | `Phasing` | **Sheer Silk** | ફોગ્ડ સીડી ઓડ મૂવ્સ પર સક્રિય અને ઇવન મૂવ્સ પર ફેન્ટમ બને છે. |
| 7 | `Armored` | **Brass-Plated** | સાટિન ક્રેટ હેમરેબલ નથી; માત્ર ક્લેસ્પ પર ધકેલીને જ દૂર કરી શકાય છે. |
| 8 | `Layered` | **Tulle** | કોમ્બો મિકેનિક્સ માત્ર ચોક્કસ કાપડના સ્તર પર જ સક્રિય રહે છે. |
| 9 | `Mirrored` | **Mirror-Stitched** | ડાબી બાજુ ક્રેટ ખસેડતાં જમણી બાજુ મિરર ક્રેટ વિરુદ્ધ દિશામાં સ્લાઇડ થાય છે. |
| 10 | `Growing` | **Mass-Expanding** | ક્રેટ દર 5 મૂવ્સ પછી 1 સેલ મોટો થતો જાય છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L8521–8630):** M851 Cycle Crate Variants (Knotted Cycle Crates, Phasing Crates, Ribbon-Tied Push Blocks, વગેરે).
- **Blocks 15–25 (L8641–8750):** M852 Floor Beam Variants (Dyed Floor Beams, Chained Optics, Basting Beams, વગેરે).
- **Blocks 27–37 (L8761–8870):** M853 Fogged Stair Variants (Mirrored Stairs, Fluffed Stairs, Tulle Elevators, વગેરે).
- **Blocks 39–49 (L8871–8990):** M854 Satin Charm Crate Variants અને Multi-System Synthesis (M851 + M852 + M854 સંયોજનો).

---

## 3. Solver Invariants
- બહુવિધ સિસ્ટમોના મિશ્રણથી સોલ્વર સર્ચ સ્પેસ એક્સપ્લોડ ન થાય તે માટે DAG ડેડલોક ચેકર્સ સુનિશ્ચિત કરે છે કે નોડ કાઉન્ટ $\le 1.5\text{M}$ રહે.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે 100% સોલ્વેબલ છે.
