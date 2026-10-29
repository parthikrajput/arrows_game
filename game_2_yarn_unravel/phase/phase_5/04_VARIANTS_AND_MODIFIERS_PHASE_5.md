# 04 — Variants & Modifiers: Phase 5
> Phase 5 ના 45 variant slots, પુશ ફિઝિક્સ craft modifiers ના નિયમો અને M201–M204 સાથેના combinations.

**Related docs:** [Phase 5 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_2001_2500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Push-Physics Craft Modifiers
Phase 5 ના 10 craft modifiers પુશેબલ ક્રેઇટ્સ અને મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | પુશ ફિઝિક્સ નિયમ |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | ક્રેઇટ દોરાથી બાંધેલી છે; જ્યાં સુધી પડોશના K દોરા ન નીકળે ત્યાં સુધી ધકેલી શકાતી નથી. |
| 2 | `Colored(c)` | **Dyed** | ક્રેઇટ માત્ર c કલરના દોરા દ્વારા જ ધકેલી શકાય છે; અન્ય કલર સ્નેગ થાય છે. |
| 3 | `Fogged` | **Fluffed** | ક્રેઇટ વૂલ ફ્લફ નીચે છુપાયેલી છે; પડોશી દોરો નીકળતાં જ પ્રગટ થાય છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે ક્રેઇટ્સ રિબનથી જોડાયેલી છે; એક ધકેલાતાં બીજી પણ તે જ દિશામાં સમાંતર ખસે છે. |
| 5 | `Countdown(N)` | **Basting** | ક્રેઇટ N મૂવ્સ પછી ઓગળીને તૂટી જાય છે. |
| 6 | `Phasing` | **Sheer Silk** | ઓડ મૂવ્સ પર ક્રેઇટ સોલિડ રહે છે; ઇવન મૂવ્સ પર ઘોસ્ટ બને છે (દોરા આરપાર નીકળે છે). |
| 7 | `Armored` | **Thimble-Reinforced** | ક્રેઇટને સ્નિપ કરવા માટે 2 ગોલ્ડન સિઝર્સ સ્ટ્રાઇક્સની જરૂર પડે છે. |
| 8 | `Layered` | **Multi-Layer** | ક્રેઇટ ઉપલા ફેબ્રિક લેયર પર રહે છે અને નીચલા દોરાઓને અસર કરતી નથી. |
| 9 | `Reflected` | **Reflected** | બોર્ડના અડધા ભાગમાં ક્રેઇટ ધકેલાતાં મિરર ભાગમાં જોડિયા ક્રેઇટ વિરુદ્ધ દિશામાં ખસે છે. |
| 10 | `Growing` | **Knit-Expanding** | ક્રેઇટ પિટમાં પડતાં પિટ ભરાય છે પણ તેની આસપાસ વૂલ ગ્રોથ 1 સેલ વિસ્તરે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L2021–2130):** M201 Crate Pit Variants (Knotted Pits, Dyed Crates + Pits, Ribbon-Tied Double Pits, Basting Pits, વગેરે).
- **Blocks 15–25 (L2141–2250):** M202 Satin Crate Variants (Sliding Crate + One-Way Arrows M006, Sliding Crate + Deflectors M014, Fluffed Satin Crates, વગેરે).
- **Blocks 27–37 (L2261–2370):** M203 Charm Crate Variants (Chained Charm Crates, Multi-Clasp Charm Crates M043, Armored Charm Boxes, વગેરે).
- **Blocks 39–49 (L2381–2490):** M204 Iron Crate Variants અને Full Workshop Mix (Iron Crate + Satin Crates + Pits).

---

## 3. Solver Invariants
- ક્રેઇટ ધકેલાતાં કોઈ દોરો અનિવાર્યપણે બ્લોક ન થઈ જાય (અનસોલ્વેબલ સ્થિતિ) તે સુનિશ્ચિત કરવા `tools/levelgen` પ્રત્યેક પુશ પર ડેડ-એન્ડ પ્રૂનિંગ ચકાસે છે.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે પૂર્ણ સોલ્વેબલ રહે છે.

