# 04 — Variants & Modifiers: Phase 12
> Phase 12 ના 45 variant slots, Gravity craft modifiers ના નિયમો અને M551–M554 સાથેના combinations.

**Related docs:** [Phase 12 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_5501_6000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Gravity Craft Modifiers
Phase 12 ના 10 craft modifiers ગ્રેવિટી મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | Gravity નિયમ |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | પ્લમ્બ લીવર લૉક છે; K દોરા બહાર નીકળે પછી જ ગુરુત્વાકર્ષણ ટૉગલ થઈ શકે છે. |
| 2 | `Colored(c)` | **Dyed** | વેઇટેડ દોરો માત્ર ત્યારે જ ગ્રેવિટીથી ખસે છે જો તે c રંગ સાથે જોડાયેલો હોય. |
| 3 | `Fluffed` | **Fluffed** | ફ્લોટ પેચ કે ડ્રોપિંગ બટન વૂલ ફ્લફ નીચે છુપાયેલું છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે ડ્રોપિંગ બટન્સ રિબનથી જોડાયેલા છે; બંને એકસાથે સમાંતર સ્લાઇડ થાય છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી ફ્લોટ પેચ સામાન્ય લિનન બની જાય છે અને વસ્તુઓ પડવા લાગે છે. |
| 6 | `Phasing` | **Sheer Silk** | ડ્રોપિંગ બટન ઓડ મૂવ્સ પર સોલિડ અને ઇવન મૂવ્સ પર ફેન્ટમ બને છે. |
| 7 | `Armored` | **Brass-Plated** | ડ્રોપિંગ બટન હેમરેબલ નથી; માત્ર ગ્રેવિટી શિફ્ટ દ્વારા જ હટાવી શકાય છે. |
| 8 | `Layered` | **Tulle** | વેઇટેડ થ્રેડ માત્ર કાપડના ચોક્કસ લેયર પર જ સરકે છે. |
| 9 | `Mirrored` | **Mirror-Stitched** | ડાબી બાજુનું બટન નીચે પડે ત્યારે જમણી બાજુનું મિરર બટન ઉપર તરફ ચડે છે. |
| 10 | `Growing` | **Mass-Expanding** | ડ્રોપિંગ બટન દરેક ફૉલ પછી પોતાની સાઈઝ 1 સેલ વધારે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L5521–5630):** M551 Plumb Lever Variants (Knotted Levers, Basting Plumbs, Phasing Levers, વગેરે).
- **Blocks 15–25 (L5641–5750):** M552 Dropping Buttons Variants (Chained Droppers, Brass-Plated Buttons, Mirrored Drops, વગેરે).
- **Blocks 27–37 (L5761–5870):** M553 Float Patch Variants (Dyed Patches, Tulle Floats, Countdown Floats, વગેરે).
- **Blocks 39–49 (L5881–5990):** M554 Weighted Thread Variants અને Full Gravity Dynamics (M551 + M552 + M554 સંયોજનો).

---

## 3. Solver Invariants
- ગ્રેવિટી સ્લાઇડિંગથી ક્યારેય એવો કોઈ સોલિડ ટાઈ-અપ ન સર્જાય જેથી બોર્ડ અનસોલ્વેબલ બને; CI જનરેટર તમામ ગ્રેવિટી એક્શન પછી સોલ્વેબિલિટી વેરિફાય કરે છે.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે 100% સોલ્વેબલ છે.

